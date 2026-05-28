//
//  SavedGuidesView.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-25.
//

import SwiftUI

struct SavedGuidesView: View {
    let guides: [Guide]

    var body: some View {
        List(guides) { guide in
            NavigationLink {
                GuideDetailView(guide: guide)
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(guide.title)
                        .font(.headline)

                    Text(guide.city)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Sparade guider")
    
    }
}

#Preview {
    NavigationStack {
        SavedGuidesView(guides: Guide.sampleData)
    }
}
