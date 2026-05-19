//
//  ContentView.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-12.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = GuideViewModel()
    
    var body: some View {
        TabView {
            Tab("Karta", systemImage: "map") {
                HomeMapView(guides: viewModel.guides)
            }
            Tab("Lägg till", systemImage: "plus") {
                AddGuidesView()
            }
            Tab("Lista", systemImage: "list.bullet") {
                
            }
            Tab("Profil", systemImage: "person") {
                
            }
        }
    }
}

#Preview {
    ContentView()
}
