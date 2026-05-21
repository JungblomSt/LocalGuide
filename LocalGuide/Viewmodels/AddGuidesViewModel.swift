//
//  AddGuideViewModel.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-14.
//

import Foundation
import CoreLocation
import Observation


@Observable
class AddGuideViewModel {
    var title: String = ""
    var city: String = ""
    var description: String = ""
    var tempLocation: CLLocationCoordinate2D?

    let locationManager = LocationManager()

    var category: Category = .other
    
    var titleError: String? = nil
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
    
    func saveGuide() {
        
        
        // TODO: This
        
        
    }
    
    func reset() {
        title = ""
        description = ""
        tempLocation = nil
        city = ""
        category = .other
        titleError = nil
        descriptionError = nil
        locationError = nil
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
        titleError = validateTextField(title, maxLength: 58)
        descriptionError = validateTextField(description, maxLength: 1000)
        locationError = validateLocation(tempLocation)
        return isValid
    }
    
}
