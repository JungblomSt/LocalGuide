//
//  GuideManager.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-27.
//

import Foundation
import FirebaseFirestore

final class GuideService {
    
    static let shared = GuideService()
    
    private init() {}
    
    private let guidesCollection = Firestore.firestore().collection("guides")
    
    private func guideDocument(guideId: String) -> DocumentReference {
        guidesCollection.document(guideId)
    }
    
    func uploadGuide(guide: Guide) async throws {
        try guideDocument(guideId: guide.id.uuidString).setData(from: guide, merge: false)
    }
    
    func fetchGuides() async throws -> [Guide] {
        let snapshot = try await guidesCollection.getDocuments()
        return try snapshot.documents.map { try $0.data(as: Guide.self) }
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
