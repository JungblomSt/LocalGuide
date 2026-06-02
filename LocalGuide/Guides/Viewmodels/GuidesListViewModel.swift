//
//  GuideListViewModel.swift
//  LocalGuide
//
//  Created by Stina Thun on 2026-06-02.
//

import Foundation
import CoreLocation

@Observable
class GuidesListViewModel {
    var guides: [Guide] = []
    var isLoading = false
    var errorMessage: String?
    
    let locationManager = LocationManager()
    
    var userLocation: CLLocation? {
        locationManager.currentLocation
    }
    
    var sortedGuides: [Guide] {
        guard let location = userLocation else { return guides}
        return guides.sorted {
            $0.distance(from: location) < $1.distance(from: location)
        }
    }
    
    func loadGuides() async {
        isLoading = true
        do {
            guides = try await GuideService.shared.fetchGuides()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}


