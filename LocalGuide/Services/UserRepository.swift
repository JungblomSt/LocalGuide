//
//  UserRepository.swift
//  LocalGuide
//
//  Created by neda khalajnejad on 2026-05-26.
//

import FirebaseFirestore

final class UserRepository {
    private let collection = Firestore.firestore().collection("users")

    func createProfile(_ profile: UserProfile) async throws {
        guard let uid = profile.id else {
            throw RepositoryError.missingID
        }
        try collection.document(uid).setData(from: profile)
    }

    func fetchProfile(uid: String) async throws -> UserProfile {
        let snapshot = try await collection.document(uid).getDocument()
        return try snapshot.data(as: UserProfile.self)
    }

    func updateProfile(_ profile: UserProfile) async throws {
        guard let uid = profile.id else {
            throw RepositoryError.missingID
        }
        try collection.document(uid).setData(from: profile, merge: true)
    }

    /// Updates only the display name field for a user profile in Firestore
    func updateDisplayName(uid: String, displayName: String) async throws {
        try await collection.document(uid).updateData([
            "displayName": displayName
        ])
    }

    /// Updates only the bio field for a user profile in Firestore
    func updateBio(uid: String, bio: String) async throws {
        try await collection.document(uid).updateData([
            "bio": bio
        ])
    }
}

enum RepositoryError: Error {
    case missingID
}
