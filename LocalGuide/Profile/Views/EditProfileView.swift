//
//  EditProfileView.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-26.
//

import SwiftUI
import UIKit

struct EditProfileView: View {
    @Bindable var viewModel: ProfileViewModel
    var body: some View {
        Form {
            Section("Användarnamn") {
                HStack {
                    TextField("Användarnamn", text: $viewModel.username)

                    Button("Spara") {
                        Task {
                            await viewModel.updateUsername()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            Section("Bio") {
                TextEditor(text: $viewModel.bio)
                    .frame(minHeight: 100)
                HStack {
                    Spacer()
                    
                    Button("Spara") {
                        Task {
                            await viewModel.updateBio()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .navigationTitle("Redigera profil")
    }
}

#Preview {
    NavigationStack {
        EditProfileView(
            viewModel: ProfileViewModel(
                auth: AuthService(),
                userRepository: UserRepository()
            )
        )
    }
}
