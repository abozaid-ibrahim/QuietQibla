//
//  MosqueFinder.swift
//  MasgedSilencer
//
//  Created by abuzeid on 26.03.24.
//

import CoreLocation
import Foundation

final class MosqueFinder {
    let mosqueRadius: CLLocationDistance
    let locationRepository: LocationRepository
    private lazy var locations: [CLLocation] = locationRepository.fetchAll().map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
    init(mosqueRadius: CLLocationDistance = 150, locationRepository: LocationRepository = MadinatyMosqueRepo()) {
        self.mosqueRadius = mosqueRadius
        self.locationRepository = locationRepository
    }

    // TODO: This is very expensive method, where it has to check for every singl location
    func isLocationInMosqueRadius(currentLocation: CLLocation) -> Bool {
        for mosqueLocation in locations {
            let distance = currentLocation.distance(from: mosqueLocation)
            if distance < mosqueRadius { // desired radius in meters
                return true
            }
        }
        return false
    }
}
