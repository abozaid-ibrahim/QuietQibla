//
//  SalahTimes.swift
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

struct SalahTimes {
    let network = NetworkAPIClient()
    private(set) var cache: CachingPolicy? = nil
    mutating func getLastValidCacheVersion() throws -> Bool {
        if let lastCallTime = cache?.lastAPICallTime,
           Date().timeIntervalSince(lastCallTime) < 60*60*12
        { // TODO: cache is valid for only one day.
            return true
        }
        return false
    }
       
    mutating func nextSalahTime(latitude: Double, longitude: Double) async throws -> Int {
//        let path = https: // api.aladhan.com/v1/calendar/2017/4?latitude=51.508515&longitude=-0.1254872&method=2http://api.aladhan.com/v1/calendar/2019?latitude=51.508515&longitude=-0.1254872&method=2
        if try getLastValidCacheVersion() {
            print("Please wait at least one day  before making another API request.")
            return 0 // cache.minutes to next salah
        }

        do {
            let timings = try await fetchPrayerTimings(latitude: String(latitude), longitude: String(longitude))
                
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let currentTime = Date()
                
            let sortedTimings = timings.sorted(by: { dateFormatter.date(from: $0.value)! < dateFormatter.date(from: $1.value)! })
            
            for timing in sortedTimings {
                let prayerTime = dateFormatter.date(from: timing.value)!
                if prayerTime > currentTime {
                    let timeDifference = prayerTime.timeIntervalSince(currentTime)
                    let minutes = Int(timeDifference / 60)
                    print("Next Salah in \(minutes) minutes: \(timing.key)")
                    cache = CachingPolicy(lastAPICallTime: Date(), minutes: 0, data: timings)
                    return minutes
                }
            }
        } catch {
            return 0
        }
        return 0
    }

//    TODO: adapt it to use network api client, use fetchPrayerTimings2
    func fetchPrayerTimings(latitude: String, longitude: String) async throws -> [String: String] {
        let url = URL(string: "https://api.aladhan.com/v1/timings/\(Int(Date().timeIntervalSince1970))?latitude=\(latitude)&longitude=\(longitude)&method=2")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataDict = json["data"] as! [String: Any]
        let timings = dataDict["timings"] as! [String: String]
        
        return timings
    }
    
    func fetchPrayerTimings2(latitude: String, longitude: String) async throws -> PrayerTimesJSONResponse {
        let json: PrayerTimesJSONResponse = try await network.fetchData(for: .init(path: "timings/\(Int(Date().timeIntervalSince1970))?latitude=\(latitude)&longitude=\(longitude)&method=2"))
        return json
    }
}

/// should fetch salah after 5 minutes
struct CachingPolicy {
    let lastAPICallTime: Date
    let minutes: Int
    let data: [String: String] // TODO: should be adjusted to contian PrayerTimesJSONResponse
}
