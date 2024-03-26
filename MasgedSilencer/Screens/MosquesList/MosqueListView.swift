//
//  MosqueListView.swift
//  MasgedSilencer
//
//  Created by abuzeid on 26.03.24.
//

import Foundation
import SwiftUI

struct MosqueListView: View {
    let locations: [MosqueItem] = MadinatyMosqueRepo().fetchAll()
    var body: some View {
        VStack {
            List(locations, id: \.id) { mosque in
                Text("\(mosque.name), \(mosque.latitude), \(mosque.longitude)")
            }

            Text("Silencer Location Count: \(locations.count)")
                .padding()
        }
    }
}
