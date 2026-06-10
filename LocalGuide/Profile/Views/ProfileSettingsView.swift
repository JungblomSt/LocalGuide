//
//  ProfileSettingsView.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-30.
//

import SwiftUI
import UIKit

struct ProfileSettingsView: View {
    @State private var viewModel: ProfileSettingsViewModel
    @State private var showDeleteAccountConfirmation = false
    @State private var deleteAccountPassword = ""

    init(auth: AuthService, userRepository: UserRepository) {
        _viewModel = State(
            initialValue: ProfileSettingsViewModel(
                auth: auth,
                userRepository: userRepository
            )
        )
    }

    
    var body: some View {
        Form {
            Section("App") {
                Button {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Label("Öppna appinställningar", systemImage: "gear")
                }
            }

            Section("Konto") {
                Button(role: .destructive) {
                    viewModel.signOut()
                } label: {
                    Label("Logga ut", systemImage: "rectangle.portrait.and.arrow.right")
                }
                
                Button(role: .destructive) {
                    showDeleteAccountConfirmation = true
                } label: {
                    Label("Ta bort konto", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Inställningar")
        .alert(
            "Är du säker på att du vill ta bort ditt konto?",
            isPresented: $showDeleteAccountConfirmation
        ) {
            SecureField("Lösenord", text: $deleteAccountPassword)
            
            Button("Ta bort konto", role: .destructive) {
                Task {
                    await viewModel.deleteAccount(password: deleteAccountPassword)
                    deleteAccountPassword = ""
                }
            }
            
            Button("Avbryt", role: .cancel) {
                deleteAccountPassword = ""
            }
        } message: {
            Text("Det här går inte att ångra.")
        }
    }
}

#Preview {
    NavigationStack {
        ProfileSettingsView(
            auth: AuthService(),
            userRepository: UserRepository()
        )
    }
}
