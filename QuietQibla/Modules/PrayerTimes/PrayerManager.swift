//
//  PrayerManager.swift
//  QuietQibla
//
//  Created by abuzeid on 29.03.24.
//

import Foundation

final class PrayerManager {
    
    func minutesLeftForNextPrayer(timings: Timings) -> (name: String, minutes: Int)? {
        // Get current date and time
        let currentDate = Date()
        let calendar = Calendar.current
        let currentTime = calendar.component(.hour, from: currentDate) * 60 + calendar.component(.minute, from: currentDate)

        // Create an array of prayer times in minutes
        let prayerTimesInMinutes = [
            ("Fajr", convertToMinutes(timings.fajr)),
            ("Dhuhr", convertToMinutes(timings.dhuhr)),
            ("Asr", convertToMinutes(timings.asr)),
            ("Maghrib", convertToMinutes(timings.maghrib)),
            ("Isha", convertToMinutes(timings.isha))
        ]

        // Sort the array based on time
        let sortedPrayerTimes = prayerTimesInMinutes.sorted { $0.1 > $1.1 }

        // Find the next prayer
        for index in 0..<sortedPrayerTimes.count {
            if currentTime < sortedPrayerTimes[index].1 {
                let minutesLeft = sortedPrayerTimes[index].1 - currentTime
                return (sortedPrayerTimes[index].0, minutesLeft)
            }
        }

        // If current time is after Isha, return Fajr for next day
        if let firstPrayerTime = prayerTimesInMinutes.first {
            let minutesLeft = 24 * 60 - currentTime + firstPrayerTime.1
            return (firstPrayerTime.0, minutesLeft)
        }

        return nil
    }

    func minutesSincePreviousPrayer(timings: Timings) -> (name: String, minutes: Int)? {
        // Get current date and time
        let currentDate = Date()
        let calendar = Calendar.current
        let currentTime = calendar.component(.hour, from: currentDate) * 60 + calendar.component(.minute, from: currentDate)

        // Create an array of prayer times in minutes
        let prayerTimesInMinutes = [
            ("Fajr", convertToMinutes(timings.fajr)),
            ("Dhuhr", convertToMinutes(timings.dhuhr)),
            ("Asr", convertToMinutes(timings.asr)),
            ("Maghrib", convertToMinutes(timings.maghrib)),
            ("Isha", convertToMinutes(timings.isha))
        ]

        // Sort the array based on time
        let sortedPrayerTimes = prayerTimesInMinutes.sorted { $0.1 < $1.1 }

        // Find the previous prayer
        for index in 0..<sortedPrayerTimes.count {
            if currentTime > sortedPrayerTimes[index].1 {
                let minutesSince = currentTime - sortedPrayerTimes[index].1
                return (sortedPrayerTimes[index].0, minutesSince)
            }
        }

        // If current time is before Fajr, return Isha from previous day
        if let lastPrayerTime = prayerTimesInMinutes.last {
            let minutesSince = currentTime + (24 * 60 - lastPrayerTime.1)
            return (lastPrayerTime.0, minutesSince)
        }

        return nil
    }

    private func convertToMinutes(_ timeString: String) -> Int {
        let components = timeString.split(separator: ":")
        if components.count == 2,
           let hour = Int(components[0]),
           let minute = Int(components[1])
        {
            return hour * 60 + minute
        }
        return 0
    }
}
