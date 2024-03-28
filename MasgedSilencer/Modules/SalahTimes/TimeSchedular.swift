//
//  TimeSchedular.swift
//  MasgedSilencer
//
//  Created by abuzeid on 28.03.24.
//

import Foundation

final class TimeSchedular {
    let salahTime = SalahTimes()
    func getNextSalahTimeByMinutes() ->Int {
        return 0
    }

    var shouldEnableMosqueLocationListener: Bool {
        return getNextSalahTimeByMinutes() < 15
    }

    func getPreviousSalahTimeByMinutes()->Int {
        return 0
    }

    var shouldDisableMosqueLocationListener: Bool {
        return getNextSalahTimeByMinutes() > 15 && getPreviousSalahTimeByMinutes() < 30
    }
}
