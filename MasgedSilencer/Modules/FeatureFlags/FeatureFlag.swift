//
//  FeatureFlag.swift
//  MasgedSilencer
//
//  Created by abuzeid on 26.03.24.
//

import Foundation

enum Feature: CaseIterable {
    case addNewMosque
    case showNearbySupportedMosques
}

enum FeatureFlag {
    private static var enabledFeatures: Set<Feature> = .init()
    static func isEnabled(_ feature: Feature) -> Bool {
        return enabledFeatures.contains(feature)
    }
}
