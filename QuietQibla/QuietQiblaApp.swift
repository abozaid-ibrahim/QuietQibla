//
//  QuietQiblaApp.swift
//  QuietQibla
//
//  Created by abuzeid on 26.03.24.
//

import SwiftUI

@main
struct QuietQiblaApp: App {
    let router = Router()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
                .environment(\.locale, .init(identifier: "ar"))
        }
    }
}

