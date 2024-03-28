//
//  MadinatyMosqueRepo.swift
//  QuietQibla
//
//  Created by abuzeid on 28.03.24.
//

import Foundation

final class MadinatyMosqueRepo: LocationRepository {
    func addLocation(_ location: MosqueItem) {}

    func deleteAllLocations() {}

    func fetchAll() -> [MosqueItem] {
        guard let path = Bundle.main.path(forResource: "madinaty_mosques", ofType: "json") else {
            return []
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let mosques = try JSONDecoder().decode([MosqueItem].self, from: data)
            return mosques
        } catch {
            print("Error loading JSON file: \(error)")
            return []
        }
    }
}

