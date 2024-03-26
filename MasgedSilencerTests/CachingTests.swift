//
//  CachingTests.swift
//  MasgedSilencerTests
//
//  Created by abuzeid on 26.03.24.
//

import Foundation
import XCTest
@testable import MasgedSilencer

final class UserDefaultsLocationRepositoryTests: XCTestCase {
    
    var repository: UserDefaultsLocationRepository!
    
    override func setUp() {
        super.setUp()
        repository = UserDefaultsLocationRepository()
        repository.deleteAllLocations()
    }
    
    override func tearDown() {
        repository.deleteAllLocations()
        repository = nil
        super.tearDown()
    }
    
    func testSaveAndRetrieveLocations() {
        let location1 = MosqueItem(name: "Mosque 1", latitude: 37.7749, longitude: -122.4194)
        let location2 = MosqueItem(name: "Mosque 2", latitude: 37.773, longitude: -122.42)
        
        // Add locations
        repository.addLocation(location1)
        repository.addLocation(location2)
        
        // Retrieve locations
        let savedLocations = repository.fetchAll()
        
        // Assert that saved locations match added locations
        XCTAssertEqual(savedLocations.count, 2)
        XCTAssertEqual(savedLocations[0].name, "Mosque 1")
        XCTAssertEqual(savedLocations[1].name, "Mosque 2")
    }
}
