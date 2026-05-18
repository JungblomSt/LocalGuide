//
//  HomeMapView.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-15.
//

import SwiftUI
import MapKit

struct HomeMapView: View {
    
    @State private var locationManager = LocationManager()
    
    // Centers the map on the user's location when available
    // If location is unavailable, the map falls back to a region centered over Sweden
    // Delta values control the fallback zoom level: higher values show a larger area
    @State private var cameraPosition: MapCameraPosition = .userLocation(
        fallback: .region(
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
    )

    var body: some View {
        Map(position: $cameraPosition) {
            UserAnnotation()
        }
        .mapStyle(.hybrid)
        .onAppear {
            locationManager.requestLocationAccess()
        }
    }
}

#Preview {
    HomeMapView()
}
