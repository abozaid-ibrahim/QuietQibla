//
//  MosqueFinder.swift
//  QuietQibla
//
//  Created by abuzeid on 26.03.24.
//

import CoreLocation
import Foundation

protocol MosqueFinder {}

final class LocationMosqueFinder: MosqueFinder {
    private let mosqueRadius: CLLocationDistance
    private let locationRepository: LocationRepository
    private let notifier = LocalNotification()
    private let mode: ModeChanger = SilentModeToggler()
    private lazy var locations: [MosqueItem] = locationRepository.fetchAll() + UserDefaultsLocationRepository().fetchAll()
    @Published private(set) var locationUpdate: LocationUpdate?

    init(mosqueRadius: CLLocationDistance,
         locationRepository: LocationRepository = MadinatyMosqueRepo())
    {
        self.mosqueRadius = mosqueRadius
        self.locationRepository = locationRepository
    }

    // TODO: This is very expensive method, where it has to check for every singl location
    func getMosqueOf(currentLocation: CLLocation) -> MosqueItem? {
        for mosque in locations {
            let distance = currentLocation.distance(from: CLLocation(latitude: mosque.latitude, longitude: mosque.longitude))
            if distance < mosqueRadius { // desired radius in meters
                return mosque
            }
        }
        return nil
    }

    func checkIfCurrentLocationIsMosque(_ location: CLLocation) {
        guard let mosque = getMosqueOf(currentLocation: location)
        else {
            locationUpdate = LocationUpdate(isCurrentLocationMosque: false)
            guard mode.shouldDisableSalahMode() else { return }
            notifier.sendNotification(notif: .init(title: Localization.appName, body: "SetFocus off"))
            return
        }
        locationUpdate = LocationUpdate(isCurrentLocationMosque: true)
        guard mode.shouldEnableSalahMode() else { return }
        notifier.sendNotification(notif: .init(title: mosque.name, body: "SetFocus on"))
    }
}
