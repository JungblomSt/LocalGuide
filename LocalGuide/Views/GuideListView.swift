//
//  GuideListView.swift
//  LocalGuide
//
//  Created by neda khalajnejad on 2026-05-19.
//

import SwiftUI
import CoreLocation


struct GuideListView: View {
    
    @State private var locationManager = LocationManager()
    
   
    
    private var sortedGuides: [Guide] {
            guard let userLocation = locationManager.currentLocation else {
                return Guide.sampleData     // not located yet — show unsorted
            }
            return Guide.sampleData.sorted {
                $0.distance(from: userLocation) < $1.distance(from: userLocation)
            }
        }
    
    var body: some View {
        NavigationStack {
            List(sortedGuides) { guide in
                VStack(alignment: .leading) {
                    Text(guide.title)
                        .font(.headline)
                    Text(guide.description)
                        .font(.subheadline)
                        .lineLimit(2)
                    if let userLocation = locationManager.currentLocation {
                        Text("\(guide.distance(from: userLocation) / 1000, specifier: "%.2f") km bort")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle(Text("Nära mig"))
            .onAppear {
                locationManager.requestLocationAccess()
            }
        }
    }
}
#Preview { GuideListView() }
