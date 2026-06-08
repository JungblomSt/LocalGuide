//
//  FavoritesViewModel.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-06-06.
//

import Foundation
import Observation
import FirebaseAuth

@Observable
final class FavoritesViewModel {
    private let auth: AuthService
    private let userRepository: UserRepository

    var savedGuideIds: Set<String> = []
    var errorMessage: String?

    init(auth: AuthService, userRepository: UserRepository) {
        self.auth = auth
        self.userRepository = userRepository
    }

    /// Loads all saved guide ids for the current user.
    func loadSavedGuides() async {
        guard let uid = auth.currentUser?.uid else {
            errorMessage = "Ingen inloggad användare hittades."
            return
        }

        do {
            let ids = try await userRepository.fetchSavedGuideIds(uid: uid)
            savedGuideIds = Set(ids)
        } catch {
            errorMessage = "Kunde inte hämta sparade guider."
        }
    }

    func isSaved(_ guide: Guide) -> Bool {
        savedGuideIds.contains(guide.id.uuidString)
    }

    /// Saves or removes a guide from the current user's saved guides.
    func toggleSaved(_ guide: Guide) async {
        guard let uid = auth.currentUser?.uid else {
            errorMessage = "Ingen inloggad användare hittades."
            return
        }

        do {
            if isSaved(guide) {
                try await userRepository.removeSavedGuide(
                    uid: uid,
                    guideId: guide.id.uuidString
                )
                savedGuideIds.remove(guide.id.uuidString)
            } else {
                try await userRepository.saveGuide(
                    uid: uid,
                    guideId: guide.id.uuidString
                )
                savedGuideIds.insert(guide.id.uuidString)
            }
        } catch {
            errorMessage = "Kunde inte uppdatera sparad guide."
        }
    }
}
