//
//  TimeSchedular.swift
//  QuietQibla
//
//  Created by abuzeid on 28.03.24.
//

import Foundation

final class TimeSchedular {
    private let salahTime = PrayerTimes(location: .init(latitude: 0, longitude: 0))

    func getNextSalahTimeByMinutes() -> Int {
        0
    }

    var shouldEnableMosqueLocationListener: Bool {
        getNextSalahTimeByMinutes() < 15
    }

    func getPreviousSalahTimeByMinutes() -> Int {
        0
    }

    var shouldDisableMosqueLocationListener: Bool {
        getNextSalahTimeByMinutes() > 15 && getPreviousSalahTimeByMinutes() < 30
    }
}
