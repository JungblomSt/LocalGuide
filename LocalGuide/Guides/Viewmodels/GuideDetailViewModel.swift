import Foundation

@Observable
class GuideDetailViewModel {
    private let audioPlayer = AudioPlayerManager()
    let guide: Guide

    /// True medan ljudet laddas ner från Firebase Storage första gången
    var isLoadingAudio = false

    var isPlaying: Bool { audioPlayer.isPlaying }
    var isAudioLoaded: Bool { audioPlayer.isLoaded }
    var currentTime: TimeInterval { audioPlayer.currentTime }
    var duration: TimeInterval { audioPlayer.duration }
    var progress: Double { audioPlayer.progress }

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
}
