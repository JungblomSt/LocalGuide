//
//  GuideListView.swift
//  LocalGuide
//
//  Created by neda khalajnejad on 2026-05-19.
//

import SwiftUI
import CoreLocation


struct GuideListView: View {

    private let userLocation = CLLocation(latitude: 59.3293, longitude: 18.0686)

    private var sortedGuides: [Guide] {
        Guide.sampleData.sorted {
            $0.distance(from: userLocation) < $1.distance(from: userLocation)
        }
    }

    var body: some View {
        NavigationStack {
            List(sortedGuides) { guide in
                NavigationLink {
                    GuideDetailView(guide: guide)
                } label: {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(guide.title)
                            Spacer()
                            Text(guide.city)
                            Spacer()
                        }
                        .font(.headline)
                        Text(guide.description)
                            .font(.subheadline)
                            .lineLimit(2)
                        Text("\(guide.distance(from: userLocation) / 1000, specifier: "%.2f") km bort")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
            .navigationTitle(Text("Nära mig"))
        }
    }
}
#Preview { GuideListView() }
