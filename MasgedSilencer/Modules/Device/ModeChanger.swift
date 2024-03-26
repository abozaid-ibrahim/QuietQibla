//
//  ModeChanger.swift
//  MasgedSilencer
//
//  Created by abuzeid on 26.03.24.
//

import AVFoundation
import Foundation

protocol ModeChanger {
    func shouldEnableFocusMode()
    func shouldDisableFocusMode()
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

    func shouldEnableFocusMode() {
        guard !isFocusModeEnabled else { return }
        enableFocusMode()
    }

    private func enableFocusMode() {
        guard !isFocusModeEnabled else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
            isFocusModeEnabled = true
            watcher.changeMode(true)
        } catch {
            print("Failed to enable focus mode: \(error.localizedDescription)")
        }
    }

    func shouldDisableFocusMode() {
        guard isFocusModeEnabled, watcher.modeChanged else { return }

        disableFocusMode()
    }

    private func disableFocusMode() {
        guard isFocusModeEnabled else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
            isFocusModeEnabled = false
            watcher.changeMode(false)
        } catch {
            print("Failed to disable focus mode: \(error.localizedDescription)")
        }
    }
}
