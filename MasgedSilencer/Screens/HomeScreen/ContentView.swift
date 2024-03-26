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

struct ContentView: View {
    @EnvironmentObject var router: Router
    private var locationListener = LocationListener()
    @ObservedObject var locationManager = LocationManager()
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                HStack {
                    Spacer()
                    Text("Current Location:")
                    if let loc = locationManager.currentLocation {
                        Text("\(loc.coordinate.latitude), \(loc.coordinate.longitude)")
                    } else {
                        Text("Waiting for location...")
                    }
                    Spacer()
                }
                Spacer()
                Text("قَدْ أَفْلَحَ الْمُؤْمِنُونَ ۝ الَّذِينَ هُمْ فِي صَلَاتِهِمْ خَاشِعُونَ")
                    .font(.largeTitle)
                if FeatureFlag.isEnabled(.addNewMosque) {
                    Spacer()
                    Button("Add New Mosque") {
                        router.path.append(Screen.mapScreen)
                    }
                }
                if FeatureFlag.isEnabled(.showNearbySupportedMosques) {
                    Spacer()
                    Button("Show All") {
                        router.path.append(Screen.mosqueList)
                    }
                }
                Spacer()
                Text(locationListener.isCurrentLocationMosque ? "This is a mosque" : "You are far away from the mosque")
            }
            .background(locationListener.isCurrentLocationMosque ? Color.green : Color(UIColor.lightGray))
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

#Preview {
    ContentView()
}
