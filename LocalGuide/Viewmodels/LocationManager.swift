//
//  LocationManager.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-18.
//

import CoreLocation
import Observation

/// Manages location permission for the app using Core Location
/// This class requests access to the user's location and stores the current permission status
@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    /// Handles communication with Core Location
    private let manager = CLLocationManager()
    
    var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        manager.delegate = self
        authorizationStatus = manager.authorizationStatus
    }
    
    /// Triggers the iOS system popup for location permission while the app is in use
    func requestLocationAccess() {
        manager.requestWhenInUseAuthorization()
    }
}
