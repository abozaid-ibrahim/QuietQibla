//
//  MapScreen.swift
//  MasgedSilencer
//
//  Created by abuzeid on 26.03.24.
//

import Foundation
import MapKit
import SwiftUI

struct MapScreen: View {
    @EnvironmentObject var router: Router

    @State private var tappedLocation: CLLocationCoordinate2D?
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var showDoneButton = false
    @ObservedObject var location = LocationManager()
    @State private var region = MKCoordinateRegion()
    let repo: LocationRepository = UserDefaultsLocationRepository()
    var body: some View {
        VStack {
            MapView(region: $region, tappedLocation: $tappedLocation, selectedLocation: $selectedLocation, showDoneButton: $showDoneButton)

            Spacer()

            if showDoneButton {
                Button("Done") {
                    if let location = selectedLocation {
                        repo.addLocation(MosqueItem(latitude: location.latitude, longitude: location.longitude))
                    }
                    router.path.removeLast()
                }
                .disabled(selectedLocation == nil)
                .padding()
            }
        }
        .navigationBarBackButtonHidden(false)
        .onAppear {
            if let currentLocation = location.currentLocation {
                region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            }
        }
    }
}
