//
//  ProfileViewModel.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-26.
//

import Foundation
import Observation
import FirebaseAuth

@Observable
final class ProfileViewModel {
    
    var username: String = "Användarnamn"
    var savedGuides: [Guide] = Guide.sampleData
    var sharedGuides: [Guide] = Guide.sampleData
    
    /// Stores an error message when profile data cannot be loaded or updated
    var errorMessage: String?

    /// Handles authentication and provides the current Firebase user
    private let auth: AuthService
    
    
    /// Handles reading and updating user profile data in Firestore
    private let userRepository: UserRepository

    init(
        auth: AuthService,
        userRepository: UserRepository
    ) {
        self.auth = auth
        self.userRepository = userRepository
    }
    
    /// Loads the current user's profile from Firestore and updates the displayed username
    func loadProfile() async {
        guard let uid = auth.currentUser?.uid else {
            errorMessage = "Ingen inloggad användare hittades."
            return
        }

        do {
            let profile = try await userRepository.fetchProfile(uid: uid)
            username = profile.displayName
        } catch {
            errorMessage = "Kunde inte hämta profilen."
        }
    }

    /// Updates the current user's display name in Firestore
    func updateUsername() async {
        guard let uid = auth.currentUser?.uid else {
            errorMessage = "Ingen inloggad användare hittades."
            return
        }

        do {
            try await userRepository.updateDisplayName(
                uid: uid,
                displayName: username
            )
        } catch {
            errorMessage = "Kunde inte uppdatera användarnamnet."
        }
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
