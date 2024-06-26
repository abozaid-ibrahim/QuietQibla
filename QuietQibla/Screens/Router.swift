//
//  Router.swift
//  QuietQibla
//
//  Created by abuzeid on 26.03.24.
//

import Foundation
import SwiftUI

enum Screen {
    case mapScreen
    case mosqueList
}

final class Router: ObservableObject {
    @Published var path = NavigationPath()
}
