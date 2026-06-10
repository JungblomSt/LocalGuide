//
//  SavedGuidesView.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-25.
//

import SwiftUI

struct SavedGuidesView: View {
    let viewModel: ProfileViewModel

    var body: some View {
        List(viewModel.savedGuides) { guide in
            NavigationLink {
                GuideDetailView(guide: guide)
                    .onDisappear {
                        Task {
                            await viewModel.loadSavedGuides()
                        }
                    }
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
        SavedGuidesView(viewModel: ProfileViewModel(
            auth: AuthService(),
            userRepository: UserRepository()
        ))
    }
}
