//
//  ProfileSettingsView.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-30.
//

import SwiftUI
import UIKit

struct ProfileSettingsView: View {
    let auth: AuthService
    @State private var showDeleteAccountConfirmation = false

    
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
                    do {
                        try auth.signOut()
                    } catch {
                        print("Could not sign out: \(error.localizedDescription)")
                    }
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
            Button("Ta bort konto", role: .destructive) {
                // Account deletion will be connected in the next step.
            }
            
            Button("Avbryt", role: .cancel) { }
        } message: {
            Text("Det här går inte att ångra.")
        }
    }
}

#Preview {
    NavigationStack {
        ProfileSettingsView(auth: AuthService())
    }
}
