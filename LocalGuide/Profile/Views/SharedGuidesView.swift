//
//  SharedGuidesView.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-26.
//

import SwiftUI

struct SharedGuidesView: View {
    let viewModel: ProfileViewModel
    
    var body: some View {
        List(viewModel.sharedGuides) { guide in
            NavigationLink {
                GuideDetailView(guide: guide)
                    .onDisappear {
                        Task {
                            await viewModel.loadSharedGuides()
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
        .navigationTitle("Mina delade")
    }
}

#Preview {
    NavigationStack {
        SharedGuidesView(viewModel: ProfileViewModel(
            auth: AuthService(),
            userRepository: UserRepository()
        ))
    }
}
