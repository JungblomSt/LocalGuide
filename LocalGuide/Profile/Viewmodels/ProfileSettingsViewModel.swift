//
//  ProfileSettingsViewModel.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-06-09.
//

import Foundation
import Observation
import FirebaseAuth

@Observable
final class ProfileSettingsViewModel {
    private let auth: AuthService
    private let userRepository: UserRepository

    init(auth: AuthService, userRepository: UserRepository) {
        self.auth = auth
        self.userRepository = userRepository
    }

    func signOut() {
        do {
            try auth.signOut()
        } catch {
            print("Could not sign out: \(error.localizedDescription)")
        }
    }

    func deleteAccount(password: String) async {
        guard let uid = auth.currentUser?.uid else { return }

        do {
            try await auth.reauthenticate(password: password)
            try await userRepository.deleteUserData(uid: uid)
            try await auth.deleteAccount()
        } catch {
            print("Could not delete account: \(error.localizedDescription)")
        }
    }
}
