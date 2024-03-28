//
//  MosqueFinderTests.swift
//  QuietQiblaTests
//
//  Created by abuzeid on 26.03.24.
//

import CoreLocation
import XCTest
@testable import QuietQibla

final class MosqueFinderTests: XCTestCase {
    var locationManager: MosqueFinder!

    override func tearDown() {
        locationManager = nil
        super.tearDown()
    }

    func testIsLocationInMosqueRadius() {
        // Mock mosque locations
        locationManager = MosqueFinder(mosqueRadius: 150, locationRepository: StubSuccessRepo())

        // Test with a location inside the radius
        let insideLocation = CLLocation(latitude: 37.7748, longitude: -122.4193) // Slightly inside the radius
        XCTAssertTrue(locationManager.isLocationInMosqueRadius(currentLocation: insideLocation))

        let onTheRadiousOfLocation = CLLocation(latitude: 37.7762, longitude: -122.4194) // Same latitude but 149m away
        XCTAssertTrue(locationManager.isLocationInMosqueRadius(currentLocation: onTheRadiousOfLocation))

        // Test with a location outside the radius
        let outsideLocation = CLLocation(latitude: 37.7700, longitude: -122.4100) // Far outside the radius
        XCTAssertFalse(locationManager.isLocationInMosqueRadius(currentLocation: outsideLocation))
    }
}

struct StubSuccessRepo: LocationRepository {
    func addLocation(_: QuietQibla.MosqueItem) {}

    func deleteAllLocations() {}

    func fetchAll() -> [MosqueItem] {
        [.init(latitude: 37.7749, longitude: -122.4194), .init(latitude: 37.7735, longitude: -122.4178)]
    }
}
