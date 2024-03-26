//
//  ContentView.swift
//  MasgedSilencer
//
//  Created by abuzeid on 26.03.24.
//

import AVFoundation
import CoreLocation
import MapKit
import SwiftUI
import UIKit

//


struct ContentView: View {
    @EnvironmentObject var router: Router
    private var locationListener = LocationListener()
    @State var locationManager = LocationManager()
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                HStack {
                    Text("Current Location:")
                    if let loc = locationManager.currentLocation {
                        Text("\(loc.coordinate.latitude)") + Text("\(loc.coordinate.longitude)")
                    }
                }
                if locationListener.isCurrentLocationMosque {
                    Text("This is a mosque")
                        .background(.green)
                }
                Spacer()
                Button("Add New Mosque") {
                    router.path.append(Screen.mapScreen)
                }
                Spacer()
                Button("Show All") {
                    router.path.append(Screen.mosqueList)
                }
                Spacer()
            }
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .mapScreen:
                    MapScreen()
                case .mosqueList:
                    MosqueListView()
                }
            }
        }
    }
}


var mosqueRadius: CLLocationDistance = 200


#Preview {
    ContentView()
}

