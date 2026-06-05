//
//  GuideDetailView.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-20.
//



import SwiftUI
import CoreLocation
import MapKit

struct GuideDetailView: View {

    @State private var viewModel: GuideDetailViewModel

    init(guide: Guide) {
        _viewModel = State(initialValue: GuideDetailViewModel(guide: guide))
    }

    var body: some View {
        ScrollView {
            VStack {
                imageSection
                titleCityAudioSection
                if viewModel.isAudioLoaded {
                    audioProgressSection
                }
                Divider()
                averageSection
                descriptionSection
                mapSection
                Divider()
                myReviewSection
                Divider()
                reviewsListSection
            }
        }
        .ignoresSafeArea(edges: .top)
        .scrollDismissesKeyboard(.interactively) 
        .task {
            await viewModel.loadReviews()
        }
    }
}

#Preview {
    GuideDetailView(guide: Guide.sampleData[0])
        .environment(LocationManager())
}

extension GuideDetailView {

  

    private var imageSection: some View {
        VStack {
            if let urlString = viewModel.guide.imageURL {
                AsyncImage(url: URL(string: urlString)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .frame(height: 300)
                            .scaledToFill()
                    case .empty:
                        ProgressView()
                            .frame(height: 300)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(height: 300)
                    .scaledToFit()
            }
        }
        .frame(height: 300)
        .tabViewStyle(PageTabViewStyle())
        .shadow(radius: 20, x: 0, y: 10)
    }

    private var titleCityAudioSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.guide.title)
                    .font(Font.largeTitle.bold())
                Text(viewModel.guide.city)
                    .font(.title2.italic())
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()

            if viewModel.guide.audioURL != nil {
                Button {
                    viewModel.toggleAudio()
                } label: {
                    VStack(spacing: 12) {
                        Image(systemName: viewModel.isPlaying ? "pause.fill" : "speaker.wave.2.fill")
                            .font(.largeTitle)
                        Text(viewModel.isPlaying ? "Pausa" : "Lyssna")
                    }
                }
                .padding(40)
            }
        }
    }

    private var audioProgressSection: some View {
        VStack(spacing: 6) {
            Slider(
                value: Binding(
                    get: { viewModel.currentTime },
                    set: { viewModel.seek(to: $0) }
                ),
                in: 0...max(viewModel.duration, 0.01)
            )
            .tint(.accentColor)

            HStack {
                Text(formatTime(viewModel.currentTime))
                Spacer()
                Text(formatTime(viewModel.duration))
            }
            .font(.caption.monospacedDigit())
            .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    private func formatTime(_ time: TimeInterval) -> String {
        guard time.isFinite, time >= 0 else { return "0:00" }
        let total = Int(time)
        return String(format: "%d:%02d", total / 60, total % 60)
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.guide.description)
                .font(.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }

    private var mapSection: some View {
        Map(initialPosition: .region(MKCoordinateRegion(
            center: viewModel.guide.coordinates,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))) {
            Marker(viewModel.guide.title, coordinate: viewModel.guide.coordinates)
        }
        .aspectRatio(1, contentMode: .fit)
        .allowsHitTesting(false)
    }

    // MARK: - Genomsnittligt betyg

    private var averageSection: some View {
        HStack(spacing: 10) {
            if viewModel.reviewCount > 0 {
                Text(String(format: "%.1f", viewModel.averageRating))
                    .font(.title2.bold())
                starsDisplay(filledFor: viewModel.averageRating)
                Text("(\(viewModel.reviewCount) recensioner)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Text("Inga betyg ännu")
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal)
    }

    // MARK: - Lämna ditt betyg

    private var myReviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ditt betyg")
                .font(.headline)

            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { i in
                    Button {
                        viewModel.myRating = i
                    } label: {
                        Image(systemName: i <= viewModel.myRating ? "star.fill" : "star")
                            .font(.title)
                            .foregroundColor(.yellow)
                    }
                    .buttonStyle(.plain)
                }
            }

            TextField("Skriv en kommentar (valfritt)",
                      text: $viewModel.myComment,
                      axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...6)

            if let error = viewModel.submitError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }

            Button {
                Task { await viewModel.submitReview() }
            } label: {
                HStack {
                    Spacer()
                    if viewModel.isSubmitting {
                        ProgressView()
                    } else {
                        Text("Skicka betyg")
                    }
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(!viewModel.canSubmit)
        }
        .padding()
    }

    // MARK: - Recensioner 

    private var reviewsListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recensioner")
                .font(.headline)

            if viewModel.reviews.isEmpty {
                Text("Inga recensioner ännu.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.reviews) { review in
                    reviewRow(review)
                    Divider()
                }
            }
        }
        .padding()
    }

    private func reviewRow(_ review: Review) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(review.authorName)
                    .font(.subheadline.bold())
                Spacer()
                Text(review.createdAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            starsDisplay(filledFor: Double(review.rating))
            if !review.comment.isEmpty {
                Text(review.comment)
                    .font(.body)
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 4)
    }

    private func starsDisplay(filledFor rating: Double) -> some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { i in
                Image(systemName: Double(i) <= rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
    }
}
