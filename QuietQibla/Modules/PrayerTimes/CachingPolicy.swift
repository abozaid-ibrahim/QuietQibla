//
//  CachingPolicy.swift
//  QuietQibla
//
//  Created by abuzeid on 29.03.24.
//

import Foundation
/// should fetch salah after 5 minutes
struct CachingPolicy {
    let lastAPICallTime: Date
    let prayerTimes: Timings 
}

extension Date {
    func isSameDay() -> Bool {
        // Get current date and time
        let currentDate = Date()
        let calendar = Calendar.current
        let currentDay = calendar.component(.day, from: currentDate)
        return currentDay == calendar.component(.day, from: self)
    }
}
