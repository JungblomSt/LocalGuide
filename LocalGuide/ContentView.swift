//
//  ContentView.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-12.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
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
                ProfileView()
            }
        }
    }
}

#Preview {
    ContentView()
}
