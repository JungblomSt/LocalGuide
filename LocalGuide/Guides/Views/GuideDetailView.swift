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
    @Environment(AuthService.self) private var auth
    @Environment(UserRepository.self) private var userRepository
    
    @State private var viewModel: GuideDetailViewModel
    @State private var favoritesViewModel: FavoritesViewModel?
    
    init(guide: Guide) {
        _viewModel = State(initialValue: GuideDetailViewModel(guide: guide))
    }

///    aktivera om man vill kunna se avståndet även i detaljvyn
//    @State private var locationManager = LocationManager()
//
//    private let userLocation = CLLocation(latitude: 59.3293, longitude: 18.0686)
    
    var body: some View {
        ScrollView {
            VStack {
                imageSection
                titleCityAudioSection
                if viewModel.isAudioLoaded {
                    audioProgressSection
                }
                Divider()
                descriptionSection
                mapSection
            }
        }
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        if favoritesViewModel == nil {
                            favoritesViewModel = FavoritesViewModel(
                                auth: auth,
                                userRepository: userRepository
                            )
                        }

                        await favoritesViewModel?.toggleSaved(viewModel.guide)
                    }
                } label: {
                    let isSaved = favoritesViewModel?.isSaved(viewModel.guide) ?? false
                    
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .foregroundStyle(isSaved ? .red : .primary)
                }
            }
        }
        .task {
            if favoritesViewModel == nil {
                favoritesViewModel = FavoritesViewModel(
                    auth: auth,
                    userRepository: userRepository
                )
            }

            await favoritesViewModel?.loadSavedGuides()
        }
    }
}

#Preview {
    let auth = AuthService()
    let userRepository = UserRepository()
    GuideDetailView(guide: Guide.sampleData[0])
        .environment(auth)
        .environment(userRepository)
        .environment(LocationManager())
}

extension GuideDetailView {
    
    private var imageSection: some View {
        VStack {
            // TODO: Show Image
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
            VStack (alignment: .leading, spacing: 8) {
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
        VStack (alignment: .leading, spacing: 8) {
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
}
