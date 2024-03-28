//
//  LocationUpdate.swift
//  QuietQibla
//
//  Created by abuzeid on 29.03.24.
//

import Foundation

struct LocationUpdate {
    let isCurrentLocationMosque: Bool
    private let createdAt = Date()
    var lastUpdated: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy 'at' h:mm a"
        return formatter.string(from: createdAt)
    }
}
