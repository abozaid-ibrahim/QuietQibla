//
//  MosqueItem.swift
//  MasgedSilencer
//
//  Created by abuzeid on 26.03.24.
//

import Foundation

struct MosqueItem: Identifiable, Codable {
    let id = UUID()
    var name: String = "Osama bin Zaid"
    var latitude: Double
    var longitude: Double
}
