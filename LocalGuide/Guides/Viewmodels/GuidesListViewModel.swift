//
//  GuideListViewModel.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-06-02.
//

import Foundation

@Observable
class GuidesListViewModel {
    var guides: [Guide] = []
    var isLoading = false
    var errorMessage: String?
    
    private let guideService = GuideService.shared
    private let userLocation = LocationManager.currentLocation
    
    var sortedGuides: [Guide] {
        guides.sorted {
            $0.distance(from: userLocation) < $1.distance(from: userLocation)
        }
    }
    
    func loadGuides() async {
        isLoading = true
        do {
            guides = try await guideService.fetchGuides()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}


