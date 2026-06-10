//
//  UserRepository.swift
//  LocalGuide
//
//  Created by neda khalajnejad on 2026-05-26.
//

import Observation
import FirebaseFirestore

@Observable
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
    
    /// Saves a guide id to the user's saved guides collection
    func saveGuide(uid: String, guideId: String) async throws {
        try await collection
            .document(uid)
            .collection("savedGuides")
            .document(guideId)
            .setData([
                "guideId": guideId,
                "savedAt": Date()
            ])
    }

    /// Removes a guide id from the user's saved guides collection
    func removeSavedGuide(uid: String, guideId: String) async throws {
        try await collection
            .document(uid)
            .collection("savedGuides")
            .document(guideId)
            .delete()
    }

    /// Fetches all saved guide ids for a user
    func fetchSavedGuideIds(uid: String) async throws -> [String] {
        let snapshot = try await collection
            .document(uid)
            .collection("savedGuides")
            .getDocuments()

        return snapshot.documents.compactMap { document in
            document.data()["guideId"] as? String
        }
    }
    
    /// Deletes all saved guide references for a user
    func deleteSavedGuides(uid: String) async throws {
        let snapshot = try await collection
            .document(uid)
            .collection("savedGuides")
            .getDocuments()
        
        let batch = Firestore.firestore().batch()
        
        for document in snapshot.documents {
            batch.deleteDocument(document.reference)
        }
        
        try await batch.commit()
    }
    
    /// Deletes the user's Firestore profile data
    func deleteUserData(uid: String) async throws {
        try await deleteSavedGuides(uid: uid)
        try await collection.document(uid).delete()
    }
}

enum RepositoryError: Error {
    case missingID
}
