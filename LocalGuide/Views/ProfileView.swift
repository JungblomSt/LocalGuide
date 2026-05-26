//
//  ProfileView.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-24.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 90))
                    .foregroundStyle(.blue)

                VStack(spacing: 4) {
                    Text("Min profil")
                        .font(.title.bold())

                    Text(viewModel.username)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 12) {
                    NavigationLink {
                        SavedGuidesView(guides: viewModel.savedGuides)
                    } label: {
                        profileRow(
                            title: "Sparade guider",
                            systemImage: "heart"
                        )
                    }

                    NavigationLink {
                        SharedGuidesView(guides: viewModel.sharedGuides)
                    } label: {
                        profileRow(
                            title: "Mina delade",
                            systemImage: "square.and.arrow.up"
                        )
                    }

                    NavigationLink {
                        EditProfileView(viewModel: viewModel)
                    } label: {
                        profileRow(
                            title: "Redigera profil",
                            systemImage: "pencil"
                        )
                    }
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding()
            .navigationTitle("Profil")
        }
    }

    private func profileRow(title: String, systemImage: String) -> some View {
        HStack {
            Image(systemName: systemImage)
                .frame(width: 28)

            Text(title)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ProfileView()
}
