//
//  ContentView.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-12.
//


import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var auth = AuthService()
    @State private var userRepository = UserRepository()

    var body: some View {
        if auth.isSignedIn {
            mainTabView
        } else {
            LoginView(auth: auth, userRepository: userRepository)
        }
    }

    private var mainTabView: some View {
        TabView {
            Tab("Karta", systemImage: "map") {
                HomeMapView(guides: Guide.sampleData)
            }
            Tab("Lägg till", systemImage: "plus") {
                AddGuidesView()
            }
            Tab("Lista", systemImage: "list.bullet") {
                GuideListView()
            }
            Tab("Profil", systemImage: "person") {
                profileView
            }
        }
    }

    private var profileView: some View {
        NavigationStack {
            Form {
                if let email = auth.currentUser?.email {
                    Section("Inloggad som") {
                        Text(email)
                    }
                }
                Section {
                    Button("Logga ut", role: .destructive) {
                        try? auth.signOut()
                    }
                }
            }
            .navigationTitle("Profil")
        }
    }
}

#Preview {
    ContentView()
}
