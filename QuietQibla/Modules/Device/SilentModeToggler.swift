//
//  SilentToggler.swift
//  QuietQibla
//
//  Created by abuzeid on 28.03.24.
//

import AVFoundation
import Foundation

final class SilentModeToggler: ModeChanger {
    var isSalahModeEnabled: Bool = false

    let watcher = ModeChangerWatcher()
    func shouldEnableSalahMode() -> Bool {
        if isSalahModeEnabled { return false }
        isSalahModeEnabled = toggleSilentMode(mode: .silent)
        watcher.salahModeIsActivated(true)
        return isSalahModeEnabled
    }

    func shouldDisableSalahMode() -> Bool {
        guard isSalahModeEnabled, watcher.modeChanged else { return false }
        isSalahModeEnabled =  toggleSilentMode(mode: .normal)
        watcher.salahModeIsActivated(false)
        return isSalahModeEnabled
    }

    enum SilentMode {
        case silent
        case normal
    }

    private func toggleSilentMode(mode: SilentMode) -> Bool {
        do {
            switch mode {
            case .silent:
                try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            case .normal:
                try AVAudioSession.sharedInstance().setCategory(.soloAmbient, mode: .default)
            }
            try AVAudioSession.sharedInstance().setActive(true)
            return true
        } catch {
            print("Error toggling silent mode: \(error.localizedDescription)")
            return false
        }
    }
}
