//
//  PrayerTimes.swift
//  QuietQibla
//
//  Created by abuzeid on 28.03.24.
//
/*
 Technical requiremtn:
 1. get updated version every day of the salah times for the current user location
 2. cache the reponse for one day in proper caching mechanism
 3. cache eviction should happen on daily basis
 4. next request in the same day returns the cache, and never hits the network again till the next day

 */
import Foundation

final class PrayerTimes {
    let network: APIClient
    let location: MyLocation
    let prayerManager: PrayerManager
    private(set) var cache: CachingPolicy?

    init(network: APIClient = NetworkAPIClient(),
         prayerManager: PrayerManager = PrayerManager(),
         location: MyLocation,
         cache: CachingPolicy? = nil)
    {
        self.network = network
        self.prayerManager = prayerManager
        self.location = location
        self.cache = cache
    }

    func getLastValidCacheVersion() -> Timings? {
        if let cached = cache,
           cached.lastAPICallTime.isSameDay()
        {
            return cached.prayerTimes
        }
        return nil
    }

    private func minuteToNextSalah(_ timings: Timings) -> PrayTime? {
        if let nextPrayer = prayerManager.minutesLeftForNextPrayer(timings: timings) {
            return PrayTime(name: nextPrayer.name, minutes: nextPrayer.minutes)
        }
        return nil
    }

    func minutesToPreviousSalah(_ timings: Timings) -> PrayTime? {
        if let previousPrayer = prayerManager.minutesSincePreviousPrayer(timings: timings) {
            return PrayTime(name: previousPrayer.name, minutes: previousPrayer.minutes)
        }
        return nil
    }

    func nextSalahTime() async throws -> Int {
        if let cachedTiming = getLastValidCacheVersion(), let time = minuteToNextSalah(cachedTiming) {
            return time.minutes
        }
        guard let response = try? await fetchPrayerTimes(location), let time = minuteToNextSalah(response)
        else { return 0 }
        return time.minutes
    }

    func fetchPrayerTimes(_ location: MyLocation) async throws -> Timings? {
        var path = "timings/\(Int(Date().timeIntervalSince1970))?"
        path += "latitude=\(location.latitude)&longitude=\(location.longitude)&method=2"
        let response: PrayerTimesJSONResponse = try await network.fetchData(for: EndPoint(path: path))
        guard let timings = response.data.first?.timings else { return nil }
        cache = .init(lastAPICallTime: Date(), prayerTimes: timings)
        return timings
    }
}

struct MyLocation {
    let latitude: Double, longitude: Double
}
