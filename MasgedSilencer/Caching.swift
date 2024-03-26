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

class UserDefaultsLocationRepository: LocationRepository {
    let key = "locationsArrray"
    let current = UserDefaults.standard
    func fetchAll() -> [MosqueItem] {
        guard let mosque = current.array(forKey: key),
              let array = mosque as? [MosqueItem] else { return [] }
        return array
    }

    func addLocation(_ location: MosqueItem) {
        var cached = fetchAll()
        cached.append(location)
        current.set(cached, forKey: key)
        current.synchronize()
    }

    func deleteAllLocations() {
        current.set(nil, forKey: key)
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
