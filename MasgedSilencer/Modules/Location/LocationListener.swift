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
    private let schedular = TimeSchedular()
    func start() {
        locationManager.startUpdatingLocation()
    }

    func stop() {
        locationManager.stopUpdatingLocation()
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
        // TODO: I dont like this piece of code, fix it
        if schedular.shouldDisableMosqueLocationListener {
            stop()
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {// dont deallocate this object
                self.start()
            }
            return
        }
        mosqueFinder.checkIfCurrentLocationIsMosque(currentLocation)
    }
}
