//
//  LocalGuideApp.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-12.
//

import SwiftUI

@main
struct LocalGuideApp: App {
    @State private var vm = GuideViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(vm)
        }
    }
}
