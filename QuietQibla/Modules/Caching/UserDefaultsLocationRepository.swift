//
//  UserDefaultsLocationRepository.swift
//  QuietQibla
//
//  Created by abuzeid on 28.03.24.
//

import Foundation

// TODO: should be changed, very slow not scalable.
final class UserDefaultsLocationRepository: LocationRepository {
    private let key = "MosquelocationsArray"
    private let defaults = UserDefaults.standard

    func fetchAll() -> [MosqueItem] {
        guard let data = defaults.data(forKey: key) else { return [] }
        let decoder = PropertyListDecoder()
        do {
            return try decoder.decode([MosqueItem].self, from: data)
        } catch {
            print("Error decoding locations: \(error.localizedDescription)")
            return []
        }
    }

    func addLocation(_ location: MosqueItem) {
        var locations = fetchAll()
        locations.append(location)
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(locations)
            defaults.set(data, forKey: key)
        } catch {
            print("Error encoding locations: \(error.localizedDescription)")
        }
    }

    func deleteAllLocations() {
        defaults.removeObject(forKey: key)
    }
}
