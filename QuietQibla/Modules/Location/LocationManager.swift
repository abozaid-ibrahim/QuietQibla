//
//  LocationManager.swift
//  QuietQibla
//
//  Created by abuzeid on 26.03.24.
//

import CoreLocation
import Foundation
import MapKit

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private var locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocation()
        case .denied, .restricted:
            print("Location services denied or restricted.")
        case .notDetermined:
            print("Location services not determined.")
        @unknown default:
            print("Unknown authorization status.")
        }
    }
}
