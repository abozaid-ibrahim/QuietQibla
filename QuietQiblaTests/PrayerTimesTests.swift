//
//  PrayerTimesTests.swift
//  QuietQiblaTests
//
//  Created by abuzeid on 26.03.24.
//

@testable import QuietQibla
import XCTest

final class PrayerTimesTests: XCTestCase {
    func testCaculateNextPrayTimeAccurately() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testCaculatePreviousPrayTimeAccurately() throws {}

    // Mock objects for testing
    class MockAPIClient: APIClient {
        func fetchData<T>(for endpoint: QuietQibla.EndPoint) async throws -> T where T : Decodable {
            let timing = Timings(fajr: "03:57", dhuhr: "12:59", asr: "16:55", maghrib: "20:12", isha: "22:02")
            
            return PrayerTimesJSONResponse(code: 200, status: "", data: [.init(timings: timing, date: nil, meta: nil)]) as! T
        }
        
        static var baseUrl: String = ""
        
//        func fetchData(for endPoint: EndPoint) async throws -> PrayerTimesJSONResponse {
//            let timing = Timings(fajr: "03:57", dhuhr: "12:59", asr: "16:55", maghrib: "20:12", isha: "22:02")
//            
//            return .init(code: 200, status: "", data: [.init(timings: timing, date: nil, meta: nil)])
//        }
    }
    
    func testGetLastValidCacheVersion_WithValidCache() {
        // Arrange
        let mockCache = CachingPolicy(lastAPICallTime: Date(), prayerTimes: Timings(fajr: "03:57", dhuhr: "12:59", asr: "16:55", maghrib: "20:12", isha: "22:02"))
        let prayerTimes = PrayerTimes(network: MockAPIClient(),
                                      prayerManager: PrayerManager(),
                                      location: .init(latitude: 0, longitude: 0),
                                      cache: mockCache)
        
        // Act
        let result = prayerTimes.getLastValidCacheVersion()
        
        // Assert
        XCTAssertNotNil(result)
    }
    
    func testGetLastValidCacheVersion_WithInvalidCache() {
        // Arrange
        let prayerTimes = PrayerTimes(network: MockAPIClient(), prayerManager: PrayerManager(), location: .init(latitude: 0, longitude: 0))
        
        // Act
        let result = prayerTimes.getLastValidCacheVersion()
        
        // Assert
        XCTAssertNil(result)
    }
    
    // Add more test cases for other methods as needed
}
