//
//  EditProfileView.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-26.
//

import SwiftUI

struct EditProfileView: View {
    @Bindable var viewModel: ProfileViewModel
    var body: some View {
        Form {
            Section("Användarnamn") {
                HStack {
                    TextField("Användarnamn", text: $viewModel.username)

                    Button("Spara") {
                        // Firebase update will be added later.
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
        EditProfileView(viewModel: ProfileViewModel())
    }
}
