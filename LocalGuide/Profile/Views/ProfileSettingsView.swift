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
            }
        }
        .navigationTitle("Inställningar")
    }
}

#Preview {
    NavigationStack {
        ProfileSettingsView(auth: AuthService())
    }
}
