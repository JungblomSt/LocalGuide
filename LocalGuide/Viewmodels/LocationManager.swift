//
//  LocationManager.swift
//  LocalGuide
//
//  Created by Jimmy kroneld on 2026-05-18.
//

import CoreLocation
import Observation

@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        manager.delegate = self
        authorizationStatus = manager.authorizationStatus
    }
    
    func requestLocationAccess() {
        manager.requestWhenInUseAuthorization()
    }
}
