//
//  MosqueListView.swift
//  MasgedSilencer
//
//  Created by abuzeid on 26.03.24.
//

import Foundation
struct MosqueListView: View {
    let locations: [MosqueItem] = UserDefaultsLocationRepository().fetchAll()
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
