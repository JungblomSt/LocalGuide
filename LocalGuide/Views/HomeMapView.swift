//
//  HomeMapView.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-15.
//

import SwiftUI
import MapKit


struct HomeMapView: View {
    var body: some View {
        Map()
            .mapStyle(.hybrid)
    }
}

#Preview {
    HomeMapView()
}
