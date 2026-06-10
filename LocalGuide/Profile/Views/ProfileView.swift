//
//  ProfileView.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-24.
//

import SwiftUI

struct ProfileView: View {
    private let auth: AuthService
    @State private var viewModel: ProfileViewModel

    init(auth: AuthService, userRepository: UserRepository) {
        self.auth = auth
        _viewModel = State(
            initialValue: ProfileViewModel(
                auth: auth,
                userRepository: userRepository
            )
        )
    }
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

                    if !viewModel.bio.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bio")
                                .font(.headline)

                            Text(viewModel.bio)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)

                    }
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
                        SharedGuidesView(viewModel: viewModel)
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ProfileSettingsView(auth: auth)
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
        // Loads the user's profile when the profile screen appears
        .onAppear {
            Task {
                await viewModel.loadProfile()
                await viewModel.loadSavedGuides()
                viewModel.loadSharedGuides()
            }
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
    ProfileView(
        auth: AuthService(),
        userRepository: UserRepository()
    )
}
