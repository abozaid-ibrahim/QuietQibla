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
    private let mode: ModeChanger = SilentModeChanger()
    var isCurrentLocationMosque: Bool = false
    let mosqueFinder = MosqueFinder()
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        isCurrentLocationMosque = mosqueFinder.isLocationInMosqueRadius(currentLocation: currentLocation)
        isCurrentLocationMosque ? mode.shouldEnableFocusMode() : mode.shouldDisableFocusMode()
    }
}
