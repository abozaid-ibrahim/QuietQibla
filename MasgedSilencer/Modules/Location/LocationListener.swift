//
//  LocationListener.swift
//  MasgedSilencer
//
//  Created by abuzeid on 26.03.24.
//

import CoreLocation
import Foundation
import MapKit

final class LocationListener: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    let mosqueFinder = MosqueFinder(mosqueRadius: 200)
    static let shared = LocationListener()
    func start() {
        locationManager.startUpdatingLocation()
    }

    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        mosqueFinder.checkIfCurrentLocationIsMosque(currentLocation)
    }
}
