//
//  HomeMapView.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-15.
//

import SwiftUI
import MapKit

struct HomeMapView: View {
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
        Map(position: $cameraPosition)
            .mapStyle(.hybrid)
    }
}

#Preview {
    HomeMapView()
}
