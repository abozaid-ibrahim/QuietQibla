//
//  MadinatyMosqueRepo.swift
//  QuietQibla
//
//  Created by abuzeid on 28.03.24.
//

import Foundation

final class MadinatyMosqueRepo: LocationRepository {
    func addLocation(_: MosqueItem) {}

    func deleteAllLocations() {}

    func fetchAll() -> [MosqueItem] {
        guard let path = Bundle.main.path(forResource: "madinaty_mosques", ofType: "json") else {
            return []
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return try JSONDecoder().decode([MosqueItem].self, from: data)
        } catch {
            print("Error loading JSON file: \(error)")
            return []
        }
    }
}
