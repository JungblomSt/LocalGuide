//
//  ReviewService.swift
//  LocalGuide
//
//  Created by neda khalajnejad on 2026-06-03.
//

import Foundation
import FirebaseFirestore

final class ReviewService {
    
    static let shared = ReviewService()
    private init() {}
    
    private let db = Firestore.firestore()
    
    private func reviewsCollection(for guideId: String) -> CollectionReference {
        db.collection("guides").document(guideId).collection("reviews")
    }
    
    func submitReview(_ review: Review, for guideId: String, by uid: String) async throws {
        try reviewsCollection(for: guideId)
            .document(uid)
            .setData(from: review)

    }
    
    func fetchReviews(for guideId: String) async throws -> [Review] {
        let snapshot = try await reviewsCollection(for: guideId)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap {try? $0.data(as: Review.self)}
    }
}
