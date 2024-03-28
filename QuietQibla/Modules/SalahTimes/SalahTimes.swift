//
//  SalahTimes.swift
//  QuietQibla
//
//  Created by abuzeid on 28.03.24.
//

import Foundation

struct SalahTimes {
    let network = NetworkAPIClient()
    var cachingPolicy = CachingPolicy(lastAPICallTime: nil, minutes: 0)
    mutating func shouldWaitBeforeNextAPICall() throws -> Bool {
        if let lastCallTime = cachingPolicy.lastAPICallTime, Date().timeIntervalSince(lastCallTime) < 300 {
            return true
        }
        cachingPolicy = CachingPolicy(lastAPICallTime: Date(), minutes: 0)
        return false
    }
       
    mutating func nextSalahTime(latitude: Double, longitude: Double) async throws -> Int {
//        let path = https: // api.aladhan.com/v1/calendar/2017/4?latitude=51.508515&longitude=-0.1254872&method=2http://api.aladhan.com/v1/calendar/2019?latitude=51.508515&longitude=-0.1254872&method=2
        if try shouldWaitBeforeNextAPICall() {
            print("Please wait at least 5 minutes before making another API request.")
            return cachingPolicy.minutes
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
                    cachingPolicy = .init(lastAPICallTime: Date(), minutes: minutes)
                    return minutes
                }
            }
        } catch {
            return 0
        }
        return 0
    }
    
    func fetchPrayerTimings(latitude: String, longitude: String) async throws -> [String: String] {
        let url = URL(string: "https://api.aladhan.com/v1/timings/\(Int(Date().timeIntervalSince1970))?latitude=\(latitude)&longitude=\(longitude)&method=2")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataDict = json["data"] as! [String: Any]
        let timings = dataDict["timings"] as! [String: String]
        
        return timings
    }
}

/// should fetch salah after 5 minutes
struct CachingPolicy {
    let lastAPICallTime: Date?
    let minutes: Int
}
