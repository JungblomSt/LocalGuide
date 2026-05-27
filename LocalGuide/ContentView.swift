//
//  ContentView.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-12.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var audioPlayer = AudioPlayerManager()

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Karta", systemImage: "map", value: 0) {
                HomeMapView(guides: Guide.sampleData)
            }
            Tab("Lägg till", systemImage: "plus", value: 1) {
                AddGuidesView()
            }
            Tab("Lista", systemImage: "list.bullet", value: 2) {
                GuideListView()
            }
            Tab("Profil", systemImage: "person", value: 3) {

            }
        }
        .onChange(of: selectedTab) {
            if Int.random(in: 1...1000) == 1,
               let url = Bundle.main.url(forResource: "lsw3_07", withExtension: "mp3") {
                audioPlayer.play(url: url)
            }
        }
    }
}

#Preview {
    ContentView()
}
