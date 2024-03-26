//
//  LocationListener.swift
//  MasgedSilencer
//
//  Created by abuzeid on 26.03.24.
//

import CoreLocation
import Foundation
import MapKit

class LocationListener: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var region = MKCoordinateRegion()
    private let mode: ModeChanger = SilentModeChanger()
    private let locationRepository = UserDefaultsLocationRepository()
    var isCurrentLocationMosque: Bool = false
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

        for savedLocation in locationRepository.fetchAll().map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) } {
            let distance = location.distance(from: savedLocation)
            if distance < mosqueRadius { // Change 100 to your desired radius in meters
                mode.shouldEnableFocusMode()
                isCurrentLocationMosque = true
                return
            }
        }
        isCurrentLocationMosque = false
        mode.shouldDisableFocusMode()
    }
}
