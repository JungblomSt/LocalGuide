//
//  SharedGuidesView.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-26.
//

import SwiftUI

struct SharedGuidesView: View {
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
        .navigationTitle("Mina delade")
    }
}

#Preview {
    NavigationStack {
        SharedGuidesView(guides: Guide.sampleData)
    }
}
