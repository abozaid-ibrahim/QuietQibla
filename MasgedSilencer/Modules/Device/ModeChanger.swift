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

final class SilentModeChanger: ModeChanger {
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
        } catch {
            print("Failed to enable focus mode: \(error.localizedDescription)")
        }
    }

    func shouldDisableFocusMode() {
        guard isFocusModeEnabled else { return }

        disableFocusMode()
    }

    private func disableFocusMode() {
        guard isFocusModeEnabled else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
            isFocusModeEnabled = false
        } catch {
            print("Failed to disable focus mode: \(error.localizedDescription)")
        }
    }
}
