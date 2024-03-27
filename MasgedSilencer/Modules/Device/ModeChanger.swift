//
//  ModeChanger.swift
//  MasgedSilencer
//
//  Created by abuzeid on 26.03.24.
//

import AVFoundation
import Foundation

protocol ModeChanger {
    func shouldEnableFocusMode()->Bool
    func shouldDisableFocusMode()->Bool
}

/// make sure I didnt miss with other apps change the mode
final class ModeChangerWatcher {
    var modeChanged: Bool = UserDefaults.standard.bool(forKey: "Mode_Changed_by_PhoneSilencerAtMosque")
    // Make sure mode changed by our app, and not other apps
    func changeMode(_ changed: Bool) {
        UserDefaults.standard.setValue(changed, forKey: "Mode_Changed_by_PhoneSilencerAtMosque")
        UserDefaults.standard.synchronize()
    }
}

final class SilentModeChanger: ModeChanger {
    let watcher = ModeChangerWatcher()
    private var isFocusModeEnabled = false

    func shouldEnableFocusMode()->Bool {
        guard !isFocusModeEnabled else { return false }
        return enableFocusMode()
    }

    private func enableFocusMode()->Bool {
        guard !isFocusModeEnabled else { return false }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
            isFocusModeEnabled = true
            watcher.changeMode(true)
            return true
        } catch {
            print("Failed to enable focus mode: \(error.localizedDescription)")
            return false
        }
    }

    func shouldDisableFocusMode()->Bool {
        guard isFocusModeEnabled, watcher.modeChanged else { return false }

        return disableFocusMode()
    }

    private func disableFocusMode()->Bool {
        guard isFocusModeEnabled else { return false }

        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
            isFocusModeEnabled = false
            watcher.changeMode(false)
            return true
        } catch {
            print("Failed to disable focus mode: \(error.localizedDescription)")
            return false
        }
    }
}
