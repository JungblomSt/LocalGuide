//
//  User.swift
//  LocalGuide
//
//  Created by neda khalajnejad on 2026-05-26.
//
import Foundation
import FirebaseFirestore

struct UserProfile: Identifiable, Codable {
    @DocumentID var id: String?
    var email: String
    var displayName: String
    var bio: String?
    var photoURL: String?
    var createdAt: Date
}
