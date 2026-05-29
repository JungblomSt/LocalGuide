//
//  ProfileViewModel.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-26.
//

import Observation

@Observable
final class ProfileViewModel {
    
    var username: String = "Användarnamn"
    var savedGuides: [Guide] = Guide.sampleData
    var sharedGuides: [Guide] = Guide.sampleData


    private let auth: AuthService
    private let userRepository: UserRepository

    init(
        auth: AuthService,
        userRepository: UserRepository
    ) {
        self.auth = auth
        self.userRepository = userRepository
    }

    func isSaved(_ guide: Guide) -> Bool {
        savedGuides.contains { $0.id == guide.id }
    }

    func toggleSaved(_ guide: Guide) {
        if isSaved(guide) {
            savedGuides.removeAll { $0.id == guide.id }
        } else {
            savedGuides.append(guide)
        }
    }
}
