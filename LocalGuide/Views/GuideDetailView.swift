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

///    aktivera om man vill kunna se avståndet även i detaljvyn
//    @State private var locationManager = LocationManager()
//
//    private let userLocation = CLLocation(latitude: 59.3293, longitude: 18.0686)
    
    var body: some View {
        ScrollView {
            VStack {
                imageSection
                titleCityAudioSection
                Divider()
                descriptionSection
                mapSection
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GuideDetailView(guide: Guide.sampleData[0])
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
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFill()
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFill()
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
                        Image(systemName: viewModel.isPlaying ? "stop.fill" : "speaker.wave.2.fill")
                            .font(.largeTitle)
                        Text(viewModel.isPlaying ? "Stoppa" : "Lyssna")
                    }
                }
                .padding(40)
            }
            
        }
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
