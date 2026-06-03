//
//  StorageManager.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-25.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageService {
    static let shared = StorageService()
    private init() {}

    private let storage = Storage.storage().reference()

    private var guideImagesReference: StorageReference {
        storage.child("guide_images")
    }

    private var guideAudioReference: StorageReference {
        storage.child("guide_audio")
    }
    
    func saveGuideImage(data: Data) async throws -> (Path: String, Name: String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpg"
        let returnedMetaData = try await guideImagesReference.child(path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
        
        return (returnedName, returnedPath)

    }
    func saveImage(image: UIImage) async throws -> (Path: String, Name: String) {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw URLError(.badURL)
        }
        return try await saveGuideImage(data: data)
    }
    
    func getDownloadURL(path: String) async throws -> URL {
        try await guideImagesReference.child(path).downloadURL()
    }
    
    func getData(path: String) async throws -> Data {
        try await guideImagesReference.child(path).data(maxSize: 10 * 1024 * 1024) // 10MB max
    }
    
    func saveImageAndGetURL(image: UIImage) async throws -> String {
        let (path, _) = try await saveImage(image: image)
        let url = try await getDownloadURL(path: path)
        return url.absoluteString
    }

    func saveAudioAndGetURL(localURL: URL) async throws -> String {
        let meta = StorageMetadata()
        meta.contentType = "audio/mpeg"

        let path = "\(UUID().uuidString).mp3"
        let data = try Data(contentsOf: localURL)
        let returnedMetaData = try await guideAudioReference.child(path).putDataAsync(data, metadata: meta)

        guard let returnedPath = returnedMetaData.path else {
            throw URLError(.badServerResponse)
        }

        let url = try await guideAudioReference.child(returnedPath.components(separatedBy: "/").last ?? path).downloadURL()
        return url.absoluteString
    }
}

