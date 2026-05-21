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
    
    let guide: Guide
    
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
            if let urlString = guide.imageURL {
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
                Text(guide.title)
                    .font(Font.largeTitle.bold())
                Text(guide.city)
                    .font(.title2.italic())
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            // TODO: This shuld be a button that starts the audiofile
            VStack (spacing: 12){
                Image(systemName: "speaker.wave.2.fill")
                    .font(.largeTitle)
                Text("Lyssna")
            }
            .padding(40)
            
        }
    }
    
    private var descriptionSection: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text(guide.description)
                .font(.body)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    private var mapSection: some View {
        Map(initialPosition: .region(MKCoordinateRegion(
            center: guide.coordinates,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))) {
            Marker(guide.title, coordinate: guide.coordinates)
        }
        .aspectRatio(1, contentMode: .fit)
        .allowsHitTesting(false)
    }
}
