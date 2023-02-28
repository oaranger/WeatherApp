//
//  LocationManager.swift
//  JPMorgan_WeatherApp
//
//  Created by Binh Huynh on 2/26/23.
//

import CoreLocation
import SwiftUI

final class LocationManager: NSObject, ObservableObject {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var lastSeenLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    private let cllLocationManager: CLLocationManager
    
    init(authorizationStatus: CLAuthorizationStatus = .notDetermined) {
        self.authorizationStatus = authorizationStatus
        self.cllLocationManager = CLLocationManager()
        super.init()
        cllLocationManager.delegate = self
        cllLocationManager.desiredAccuracy = kCLLocationAccuracyReduced
        self.authorizationStatus = cllLocationManager.authorizationStatus
        cllLocationManager.startUpdatingLocation()
    }
    
    func updateAuthorizationStatus() {
        authorizationStatus = cllLocationManager.authorizationStatus
    }
    
    func requestWhenInUseAuthorization() {
        cllLocationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        cllLocationManager.startUpdatingLocation()
    }
}

// MARK: - Location status
extension LocationManager {
    var locationIsDisabled: Bool {
        authorizationStatus == .denied ||
        authorizationStatus == .notDetermined ||
        authorizationStatus == .restricted
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updateAuthorizationStatus()
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else { return }
        lastSeenLocation = location
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Location retrieving failed due to: \(error.localizedDescription)")
    }
}
