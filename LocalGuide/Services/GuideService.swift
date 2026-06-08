//
//  GuideManager.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-27.
//

import FirebaseFirestore
import Foundation

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

    /// Fetches guides created by a specific user.
    func fetchGuidesCreatedByUser(
        createdBy uid: String,
        completion: @escaping ([Guide]) -> Void
    ) {
        guidesCollection
            .whereField("createdBy", isEqualTo: uid)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting user guides: \(error)")
                    completion([])
                    return
                }

                Task { @MainActor in
                    var guides: [Guide] = []

                    guard let documents = querySnapshot?.documents else {
                        completion([])
                        return
                    }

                    for document in documents {
                        do {
                            let guide = try document.data(as: Guide.self)
                            guides.append(guide)
                        } catch {
                            print("Error decoding user guide: \(error)")
                        }
                    }

                    completion(guides)
                }
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
