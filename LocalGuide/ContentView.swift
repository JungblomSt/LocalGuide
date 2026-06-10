//
//  ContentView.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-12.
//


import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var auth = AuthService()
    @State private var userRepository = UserRepository()

    var body: some View {
        if auth.isSignedIn {
            mainTabView
                .environment(auth)
        } else {
            LoginView(auth: auth, userRepository: userRepository)
        }
    }

    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            Tab("Karta", systemImage: "map", value: 0) {
                HomeMapView()
            }
            Tab("Lägg till", systemImage: "plus", value: 1) {
                AddGuidesView(auth: auth)
            }
            Tab("Lista", systemImage: "list.bullet", value: 2) {
                GuideListView()
            }
            Tab("Profil", systemImage: "person", value: 3) {
                ProfileView(auth: auth, userRepository: userRepository)
            }
        }
        .environment(auth)
        .environment(userRepository)
    }
}

#Preview {
    ContentView()
}
