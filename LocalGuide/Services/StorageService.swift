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
    
    /// Sparar bildata direkt till Firebase Storage och returnerar sökväg + filnamn
    func saveGuideImage(data: Data) async throws -> (Path: String, Name: String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"  // Talar om för Firebase att det är en JPEG-bild
        
        // Skapar ett unikt filnamn med UUID för att undvika namnkrockar
        let path = "\(UUID().uuidString).jpg"
        
        // Laddar upp datan till FirebaseStorage, guide_images mappen och väntar på svar
        let returnedMetaData = try await guideImagesReference.child(path).putDataAsync(data, metadata: meta)
        
        // Kontrollerar att vi fick tillbaka giltig sökväg och namn, annars kastas ett fel
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
        return (returnedPath, returnedName)
    }

    /// Konverterar en UIImage till JPEG-data och skickar vidare till saveGuideImage
    func saveImage(image: UIImage) async throws -> (Path: String, Name: String) {
        // Komprimerar bilden till 80% kvalitet för att spara utrymme
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw URLError(.badURL)  // Kastas om bilden inte kan konverteras
        }
        return try await saveGuideImage(data: data)
    }

    /// Hämtar en nedladdningsbar URL från Firebase för en given lagringsväg
    func getDownloadURL(path: String) async throws -> URL {
        try await storage.child(path).downloadURL()
    }

    /// Hämtar själva bilddatan från Firebase, max 10MB
    func getData(path: String) async throws -> Data {
        try await guideImagesReference.child(path).data(maxSize: 10 * 1024 * 1024)
    }
    
    /// same as above but audio + max 50MG
    func getAudioData(path: String) async throws -> Data {
        try await storage.child(path).data(maxSize: 50 * 1024 * 1024)
    }

    /// Kombinationsfunktion: sparar bilden OCH returnerar en färdig URL-sträng direkt
    func saveImageAndGetURL(image: UIImage) async throws -> String {
        let (path, _) = try await saveImage(image: image)  // Ignorerar name-värdet med _
        let url = try await getDownloadURL(path: path)
        return url.absoluteString
    }

    func saveGuideAudio(data: Data) async throws -> (Path: String, Name: String) {
        let meta = StorageMetadata()
        meta.contentType = "audio/mpeg"

        let path = "\(UUID().uuidString).mp3"

        let returnedMetaData = try await guideAudioReference.child(path).putDataAsync(data, metadata: meta)

        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
        return (returnedPath, returnedName)
    }

    func saveAudio(localURL: URL) async throws -> (Path: String, Name: String) {
        let data = try Data(contentsOf: localURL)
        return try await saveGuideAudio(data: data)
    }
}

