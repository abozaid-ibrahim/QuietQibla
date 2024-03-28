//
//  DontDisturbToggler.swift
//  MasgedSilencer
//
//  Created by abuzeid on 28.03.24.
//

import Foundation
import AVFoundation

final class DontDisturbToggler: ModeChanger {
    let watcher = ModeChangerWatcher()
    private(set) var isSalahModeEnabled = false

    func shouldEnableSalahMode()->Bool {
        guard !isSalahModeEnabled else { return false }
        return enableFocusMode()
    }

    private func enableFocusMode()->Bool {
        guard !isSalahModeEnabled else { return false }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
            isSalahModeEnabled = true
            watcher.salahModeIsActivated(true)
            return true
        } catch {
            print("Failed to enable focus mode: \(error.localizedDescription)")
            return false
        }
    }

    func shouldDisableSalahMode()->Bool {
        guard isSalahModeEnabled, watcher.modeChanged else { return false }
        return disableFocusMode()
    }

    private func disableFocusMode()->Bool {
        guard isSalahModeEnabled else { return false }

        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
            isSalahModeEnabled = false
            watcher.salahModeIsActivated(false)
            return true
        } catch {
            print("Failed to disable focus mode: \(error.localizedDescription)")
            return false
        }
    }
}
