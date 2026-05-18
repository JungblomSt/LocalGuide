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
//    var isUploading: Bool = false
//    var error: Error?
    
    func saveGuide() {
        
    }
    func reset() {
        title = ""
        description = ""
    }
    
}
