//
//  Caching.swift
//  MasgedSilencer
//
//  Created by abuzeid on 26.03.24.
//

import CoreData
import Foundation

class LocationEntity: NSManagedObject {
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
}

extension LocationEntity {
    static func create(in context: NSManagedObjectContext, latitude: Double, longitude: Double) -> LocationEntity {
        let location = LocationEntity(context: context)
        location.latitude = latitude
        location.longitude = longitude
        return location
    }
}

import Combine
import CoreData

protocol LocationRepository {
    func fetchAll() -> [MosqueItem]
    func addLocation(_ location: MosqueItem)
    func deleteAllLocations()
}

class MadinatyMosqueRepo: LocationRepository {
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

// TODO: should be changed, very slow not scalable.
class UserDefaultsLocationRepository: LocationRepository {
    private let key = "MosquelocationsArray"
    private let defaults = UserDefaults.standard

    func fetchAll() -> [MosqueItem] {
        guard let data = defaults.data(forKey: key) else { return [] }
        let decoder = PropertyListDecoder()
        do {
            let locations = try decoder.decode([MosqueItem].self, from: data)
            return locations
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

// class CoreDataLocationRepository: ObservableObject {
//    private let context = CoreDataStack.shared.managedObjectContext
//
//    @Published var locations: [MosqueItem] = []
//
//    init() {
//        fetchLocations()
//    }
//
//     func fetchLocations() {
//        let fetchRequest: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
//        do {
//            let result = try context.fetch(fetchRequest)
//            locations = result.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
//        } catch {
//            print("Error fetching locations: \(error.localizedDescription)")
//        }
//    }
//
//    func addLocation(_ location: MosqueItem) {
//        let _ = LocationEntity.create(in: context, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        saveContext()
//        fetchLocations()
//    }
//
//    func deleteAllLocations() {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = LocationEntity.fetchRequest()
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        do {
//            try context.execute(batchDeleteRequest)
//            locations.removeAll()
//        } catch {
//            print("Error deleting locations: \(error.localizedDescription)")
//        }
//    }
//
//    private func saveContext() {
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context: \(error.localizedDescription)")
//        }
//    }
// }
