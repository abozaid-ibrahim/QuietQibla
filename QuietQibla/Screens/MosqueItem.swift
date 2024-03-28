//
//  MosqueItem.swift
//  QuietQibla
//
//  Created by abuzeid on 26.03.24.
//

import Foundation

struct MosqueItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
}
