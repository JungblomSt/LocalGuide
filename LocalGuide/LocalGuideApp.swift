//
//  LocalGuideApp.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-12.
//

import SwiftUI
import Firebase

@main
struct LocalGuideApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
