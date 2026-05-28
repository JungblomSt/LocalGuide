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
    
    /// Stores the user's latest known location.
    var currentLocation: CLLocation?
    
    /// Returns true if the user has denied location access or if access is restricted
    var isLocationDenied: Bool {
        authorizationStatus == .denied || authorizationStatus == .restricted
    }
    
    override init() {
        super.init()
        manager.delegate = self
        authorizationStatus = manager.authorizationStatus
    }
    
    /// Triggers the iOS system popup for location permission while the app is in use
    func requestLocationAccess() {
        manager.requestWhenInUseAuthorization()
        
        if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    /// Updates permission status and requests the user's location when access is granted.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    /// Updates the user's current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    /// Handles errors when requesting the user's location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}
