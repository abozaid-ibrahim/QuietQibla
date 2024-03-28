//
//  Localization.swift
//  QuietQibla
//
//  Created by abuzeid on 26.03.24.
//

import Foundation
import SwiftUI

enum Localization {
    static let appName = "app.name"
    enum Home: String {
        case homeAya = "home.screen.aya"
        case thisIsMosque = "this.is.mosque"
        case thisIsNotAmosque = "this.is.not.mosque"
        case lookingForLocation = "looking.for.your.location"
        case currentLocation = "current_location"
        case salahModeOn = "home.salah.mode.on"
        case salahModeOff = "home.salah.mode.off"
        var key: LocalizedStringKey {
            rawValue.localizedKey
        }
    }
}

extension String {
    var localizedKey: LocalizedStringKey {
        LocalizedStringKey(self)
    }
}
