//
//  Localization.swift
//  MasgedSilencer
//
//  Created by abuzeid on 26.03.24.
//

import Foundation
import SwiftUI

enum Localization {
    enum Home: String {
        case home_aya = "home.screen.aya"
        case thisIsMosque = "this.is.mosque"
        case thisIsNotAmosque = "this.is.not.mosque"
        case lookingForLocation = "looking.for.your.location"
        case currentLocation = "current_location"
        var key: LocalizedStringKey {
            self.rawValue.localizedKey
        }
    }
}

extension String {
    var localizedKey: LocalizedStringKey {
        LocalizedStringKey(self)
    }
}
