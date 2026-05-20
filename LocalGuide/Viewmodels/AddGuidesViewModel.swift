//
//  AddGuideViewModel.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-05-14.
//

import Foundation
import Observation


@Observable
class AddGuideViewModel {
    var title: String = ""
    var description: String = ""
    var category: Category = .other
    
    var titleError: String? = nil
    var descriptionError: String? = nil
    
    var isValid: Bool {
        titleError == nil && descriptionError == nil
    }
    
    func saveGuide() {
        
        
        // TODO: This
        
        
    }
    
    func reset() {
        title = ""
        description = ""
        category = .other
        titleError = nil
        descriptionError = nil
    }
    
    func validateTextField(_ text: String, maxLength: Int) -> String? {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return "* Fältet får inte vara tomt." }
        if trimmed.count < 3 { return "* Minst 3 tecken." }
        if trimmed.count > maxLength { return "* Max \(maxLength) tecken." }
        return nil
    }
    
    func validate() -> Bool {
        titleError = validateTextField(title, maxLength: 50)
        descriptionError = validateTextField(description, maxLength: 1000)
        return isValid
    }
    
}
