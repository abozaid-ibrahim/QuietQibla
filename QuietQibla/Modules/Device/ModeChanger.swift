//
//  ModeChanger.swift
//  QuietQibla
//
//  Created by abuzeid on 26.03.24.
//

import AVFoundation
import Foundation

protocol ModeChanger {
    var isSalahModeEnabled: Bool { get }

    func shouldEnableSalahMode()->Bool
    func shouldDisableSalahMode()->Bool
}

/// make sure I didnt miss with other apps change the mode
final class ModeChangerWatcher {
    var modeChanged: Bool = UserDefaults.standard.bool(forKey: "Mode_Changed_by_PhoneSilencerAtMosque")
    // Make sure mode changed by our app, and not other apps
    func salahModeIsActivated(_ changed: Bool) {
        UserDefaults.standard.setValue(changed, forKey: "Mode_Changed_by_PhoneSilencerAtMosque")
        UserDefaults.standard.synchronize()
    }
}
