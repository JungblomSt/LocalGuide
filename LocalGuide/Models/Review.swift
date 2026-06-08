//
//  Review.swift
//  LocalGuide
//
//  Created by neda khalajnejad on 2026-06-03.
//

import Foundation
import FirebaseFirestore


struct Review: Identifiable, Codable {
    @DocumentID var id: String?
    var rating: Int
    var comment: String
    var authorName: String
    var createdAt: Date
}
