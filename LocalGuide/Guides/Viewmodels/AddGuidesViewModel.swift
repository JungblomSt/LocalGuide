//
//  AddGuideViewModel.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-14.
//

import Foundation
import CoreLocation
import Observation
import _PhotosUI_SwiftUI
import UIKit
import FirebaseAuth


@Observable
class AddGuideViewModel {
    private let auth: AuthService
    
    init(auth: AuthService){
        self.auth = auth
    }
    
    var title: String = ""
    var city: String = ""
    var description: String = ""
    
    var imageURL: String? = nil
    var isUploadingImage: Bool = false
    
    var tempLocation: CLLocationCoordinate2D?
    let locationManager = LocationManager()

    var category: Category = .other
    
    var titleError: String? = nil
    var cityError: String? = nil
    var descriptionError: String? = nil
    var locationError: String? = nil

    var isValid: Bool {
        titleError == nil && descriptionError == nil && locationError == nil
    }

    func useCurrentLocation() {
        locationManager.requestLocationAccess()
        if let coordinate = locationManager.currentLocation?.coordinate {
            tempLocation = coordinate
        }
    }
    
    func uploadImage(_ image: UIImage) async {
        isUploadingImage = true
        do {
            print("Laddar upp bild...")
            let url = try await StorageService.shared.saveImageAndGetURL(image: image)
            imageURL = url
            print("Bild uppladdad! URL: \(url)")
        } catch {
            print("Fel vid bilduppladdning: \(error.localizedDescription)")
        }
        isUploadingImage = false
    }
    
    func saveGuide() async throws {
        
        guard validate() else { return }
        guard let location = tempLocation else { return }
        guard let uid = auth.currentUser?.uid else { return }
        
        let newGuide = Guide(
            id: UUID().uuidString,
            title: title.trimmingCharacters(in: .whitespaces),
            city: city.trimmingCharacters(in: .whitespaces),
            category: category.rawValue,
            description: description,
            longitude: location.longitude,
            latitude: location.latitude,
            image: imageURL,
            createdBy: uid
        )
        
        try await GuideService.shared.uploadGuide(guide: newGuide)
        
        reset()
    }
    
    func reset() {
        title = ""
        description = ""
        tempLocation = nil
        city = ""
        category = .other
        imageURL = nil
        titleError = nil
        descriptionError = nil
        locationError = nil
        isUploadingImage = false
    }
    
    func validateTextField(_ text: String, maxLength: Int) -> String? {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return "* Fältet får inte vara tomt." }
        if trimmed.count < 3 { return "* Minst 3 tecken." }
        if trimmed.count > maxLength { return "* Max \(maxLength) tecken." }
        return nil
    }
    
    func validateLocation(_ location: CLLocationCoordinate2D?) -> String? {
        if location == nil { return "* Välj en plats." }
        return nil
    }

    func validate() -> Bool {
        titleError = validateTextField(title, maxLength: 30)
        cityError = validateTextField(city, maxLength: 58)
        descriptionError = validateTextField(description, maxLength: 1000)
        locationError = validateLocation(tempLocation)
        return isValid
    }
}
