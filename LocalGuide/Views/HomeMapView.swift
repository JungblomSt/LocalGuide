//
//  HomeMapView.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-15.
//

import MapKit
import SwiftUI

struct HomeMapView: View {
  @State private var locationManager = LocationManager()
    
  var guides: [Guide]
    // Initial map region centered over Sweden
    // Latitude and longitude set the center point of the map
    // Delta values control the zoom level: higher values show a larger area
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 59.0,
                longitude: 16.0
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 9,
                longitudeDelta: 9
            )
        )

    )

    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(guides) { guide in
                Marker(guide.title, coordinate: guide.coordinates)
            }
            UserAnnotation()
        }
        .mapStyle(.hybrid)
        .overlay(alignment: .bottomTrailing) {
            Button {
                locationManager.requestLocationAccess()
            } label: {
                Image(systemName: "location.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(.blue, lineWidth: 2)
                    }
                    .shadow(radius: 4)
            }
            .padding()
        }
        .onAppear {
            locationManager.requestLocationAccess()
        }
        .onChange(of: locationManager.currentLocation) { _, newLocation in
            guard let coordinate = newLocation?.coordinate else { return }

            cameraPosition = .region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.02,
                        longitudeDelta: 0.02
                    )
                )
            )
        }
    }
}

#Preview {
    HomeMapView(guides: [
        Guide(
            id: "1",
            title: "Liseberg",
            category: "kids",
            description: "Nöjespark",
            longitude: 11.992464,
            latitude: 57.695219
        )
    ])
}
