//
//  CoreDateCaching.swift
//  QuietQibla
//
//  Created by abuzeid on 28.03.24.
//

import Foundation

import CoreData

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
