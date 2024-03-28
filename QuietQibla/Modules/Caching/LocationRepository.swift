//
//  Caching.swift
//  QuietQibla
//
//  Created by abuzeid on 26.03.24.
//

import Combine
import CoreData

protocol LocationRepository {
    func fetchAll() -> [MosqueItem]
    func addLocation(_ location: MosqueItem)
    func deleteAllLocations()
}
