//
//  QuietQiblaApp.swift
//  QuietQibla
//
//  Created by abuzeid on 26.03.24.
//

import SwiftUI

@main
struct QuietQiblaApp: App {
    private let router = Router()
    @StateObject private var themeManager = ThemeManager(theme: .init(primaryColor: .secondary,
                                                                      background: .white.opacity(0.15)))

    var body: some Scene {
        WindowGroup {
            MainScreenView()
                .environmentObject(router)
                .environment(\.locale, .init(identifier: "ar"))
                .environmentObject(themeManager)
        }
    }
}
