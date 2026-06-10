//
//  GuideManager.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-27.
//

import FirebaseFirestore
import Foundation
import FirebaseStorage

final class GuideService {

    static let shared = GuideService()

    private init() {}

    private let guidesCollection = Firestore.firestore().collection("guides")

    private func guideDocument(guideId: String) -> DocumentReference {
        guidesCollection.document(guideId)
    }

    /// Laddar upp en ny guide till firestore
    func uploadGuide(guide: Guide) async throws {
        try guideDocument(guideId: guide.id.uuidString).setData(
            from: guide,
            merge: false
        )
    }
    
    /// Uppdaterar guiden som redan finns på firestore
    func updateGuide(guide: Guide) async throws {
        try guideDocument(guideId: guide.id.uuidString).setData(
            from: guide,
            merge: true
        )
    }
    
    /// Hämtar samtliga guider
    func fetchGuides() async throws -> [Guide] {
        let snapshot = try await guidesCollection.getDocuments()
        return try snapshot.documents.map { try $0.data(as: Guide.self) }
    }
    
    /// Hämtar en enskild Guide
    func fetchGuide(id: String) async throws -> Guide {
        let snapshot = try await guideDocument(guideId: id).getDocument()
        return try snapshot.data(as: Guide.self)
    }

    /// Fetches guides created by a specific user using a completion handler.
    /// Kept for older code that still uses callback-based loading.
    func fetchGuidesCreatedByUser(
        createdBy uid: String,
        completion: @escaping ([Guide]) -> Void
    ) {
        Task {
            do {
                let guides = try await fetchGuidesCreatedByUser(createdBy: uid)
                completion(guides)
            } catch {
                print("Error getting user guides: \(error)")
                completion([])
            }
        }
    }
    
    /// Fetches guides created by a specific user using async/await.
    func fetchGuidesCreatedByUser(createdBy uid: String) async throws -> [Guide] {
        let snapshot = try await guidesCollection
            .whereField("createdBy", isEqualTo: uid)
            .getDocuments()
        
        return try snapshot.documents.map { document in
            try document.data(as: Guide.self)
        }
    }
    

    ///  Delete Guide, image and audio from firestore/storage
    func deleteGuide(_ guide: Guide) async throws {
        if let imageURL = guide.imageURL {
            try await StorageService.shared.deleteStorageFile(at: imageURL)
        }
        if let audioURL = guide.audioURL {
            try await StorageService.shared.deleteStorageFile(at: audioURL)
        }
        try await Firestore.firestore().collection("guides").document(guide.id.uuidString).delete()
        
    }
    
    /// Deletes all guides created by a specific user
    func deleteGuidesCreatedByUser(uid: String) async throws {
        let guides = try await fetchGuidesCreatedByUser(createdBy: uid)
        
        for guide in guides {
            try await deleteGuide(guide)
        }
    }

    // Funktion för att ladda upp sample data
    func uploadSampleData() async {
        for guide in Guide.sampleData {
            do {
                try await uploadGuide(guide: guide)
                print("✅ Uppladdad: \(guide.title)")
            } catch {
                print("❌ Fel vid uppladdning av \(guide.title): \(error)")
            }
        }
        print("🎉 Alla sample guides uppladdade!")
    }
}
