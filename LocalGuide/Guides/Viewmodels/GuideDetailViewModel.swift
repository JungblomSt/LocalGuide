import Foundation
import FirebaseAuth

@Observable
class GuideDetailViewModel {
    private let audioPlayer = AudioPlayerManager()
    let guide: Guide

    // MARK: - Audio
    /// True medan ljudet laddas ner från Firebase Storage första gången
    var isLoadingAudio = false

    var isPlaying: Bool { audioPlayer.isPlaying }
    var isAudioLoaded: Bool { audioPlayer.isLoaded }
    var currentTime: TimeInterval { audioPlayer.currentTime }
    var duration: TimeInterval { audioPlayer.duration }
    var progress: Double { audioPlayer.progress }

    // MARK: - Review state
    var reviews: [Review] = []
    var myRating: Int = 0
    var myComment: String = ""
    var isSubmitting: Bool = false
    var submitError: String?

    var averageRating: Double {
        guard !reviews.isEmpty else { return 0 }
        return Double(reviews.map(\.rating).reduce(0, +)) / Double(reviews.count)
    }
    var reviewCount: Int { reviews.count }
    var canSubmit: Bool {
        myRating > 0 && !isSubmitting && Auth.auth().currentUser != nil
    }

    init(guide: Guide) {
        self.guide = guide
    }

    func toggleAudio() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else if audioPlayer.isLoaded {
            audioPlayer.resume()
        } else if let path = guide.audioURL {
            // Hämtar ljudet från Storage (med disk-cache) och spelar upp det
            Task { await loadAndPlay(path: path) }
        }
    }

    @MainActor
    private func loadAndPlay(path: String) async {
        guard !isLoadingAudio else { return }
        isLoadingAudio = true
        await audioPlayer.play(storagePath: path)
        isLoadingAudio = false
    }

    func seek(to time: TimeInterval) {
        audioPlayer.seek(to: time)
    }

    // MARK: - Reviews

    func loadReviews() async {
        let guideId = guide.id.uuidString
    
        do {
            let fetched = try await ReviewService.shared.fetchReviews(for: guideId)
            self.reviews = fetched
        } catch {
            print("   localizedDescription: \(error.localizedDescription)")
            print("   full error: \(error)")
        }
    }

    func submitReview() async {
        
        guard let user = Auth.auth().currentUser else {
            submitError = "Du måste vara inloggad."
            return
        }
        guard myRating > 0 else {
            print("✍️ no rating — aborting")
            return
        }

        isSubmitting = true
        submitError = nil
        defer { isSubmitting = false }

        let profile = try? await UserRepository().fetchProfile(uid: user.uid)
        let displayName = profile?.displayName ?? user.displayName ?? "Anonym"

        let review = Review(
            rating: myRating,
            comment: myComment.trimmingCharacters(in: .whitespacesAndNewlines),
            authorName: displayName,
            createdAt: Date()
        )

        do {
            try await ReviewService.shared.submitReview(
                review,
                for: guide.id.uuidString,
                by: user.uid
            )
            myRating = 0
            myComment = ""
            await loadReviews()
        } catch {
            print("❌ [submitReview] WRITE FAILED: \(error.localizedDescription)")
            submitError = error.localizedDescription
        }
    }


}

