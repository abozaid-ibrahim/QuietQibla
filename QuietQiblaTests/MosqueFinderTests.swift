//
//  MosqueFinderTests.swift
//  QuietQiblaTests
//
//  Created by abuzeid on 26.03.24.
//

import CoreLocation
@testable import QuietQibla
import XCTest

final class MosqueFinderTests: XCTestCase {
    func testIsLocationInMosqueRadius() {
        // Mock mosque locations
        let locationFinder = LocationMosqueFinder(mosqueRadius: 150, locationRepository: StubSuccessRepo())

        // Test with a location inside the radius
        let insideLocation = CLLocation(latitude: 37.7748, longitude: -122.4193) // Slightly inside the radius
        XCTAssertNotNil(locationFinder.getMosqueOf(currentLocation: insideLocation))

        let onTheRadiousOfLocation = CLLocation(latitude: 37.7762, longitude: -122.4194) // Same latitude but 149m away
        XCTAssertNotNil(locationFinder.getMosqueOf(currentLocation: onTheRadiousOfLocation))

        // Test with a location outside the radius
        let outsideLocation = CLLocation(latitude: 37.7700, longitude: -122.4100) // Far outside the radius
        XCTAssertNil(locationFinder.getMosqueOf(currentLocation: outsideLocation))
    }
}

struct StubSuccessRepo: LocationRepository {
    func addLocation(_: MosqueItem) {}

    func deleteAllLocations() {}

    func fetchAll() -> [MosqueItem] {
        [.init(name: "", latitude: 37.7749, longitude: -122.4194), .init(name: "", latitude: 37.7735, longitude: -122.4178)]
    }
}
