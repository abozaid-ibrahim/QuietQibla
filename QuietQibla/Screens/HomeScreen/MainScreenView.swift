//
//  MainScreenView.swift
//  QuietQibla
//
//  Created by abuzeid on 26.03.24.
//

import AVFoundation
import CoreLocation
import MapKit
import SwiftUI
import UIKit

struct MainScreenView: View {
    @ObservedObject var locationManager = LocationManager()
    @State private var viewModel = MainScreenViewModel()
    @EnvironmentObject private var theme: ThemeManager
    @EnvironmentObject private var router: Router

    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                HStack {
                    Spacer()
                    Text(Localization.Home.currentLocation.key)
                    if let loc = locationManager.currentLocation {
                        Text("\(loc.coordinate.latitude), \(loc.coordinate.longitude)")
                    } else {
                        Text(Localization.Home.lookingForLocation.key)
                    }
                    Spacer()
                }
                if let locationUpdate = LocationListener.shared.mosqueFinder.locationUpdate {
                    Text("Last updated: \(locationUpdate.lastUpdated)")
                    // formatter: DateFormatter.localizedString(from:, dateStyle: .medium, timeStyle: .medium)
                } else {
                    Text("Location update not available")
                }
                Spacer()
                Text(Localization.Home.homeAya.key)
                    .font(.largeTitle)
                    .padding()
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
                Text(viewModel.isMosque ? Localization.Home.thisIsMosque.key : Localization.Home.thisIsNotAmosque.key)
            }
            .background(viewModel.isMosque ? theme.current.primaryColor : Color(UIColor.lightGray))
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .mapScreen:
                    MapScreen()
                case .mosqueList:
                    MosqueListView()
                }
            }
        }
        .onAppear {
            LocationListener.shared.start()
        }
    }
}

final class MainScreenViewModel {
    var location: LocationUpdate? {
        LocationListener.shared.mosqueFinder.locationUpdate
    }

    var isMosque: Bool {
        location?.isCurrentLocationMosque ?? false
    }
}

#Preview {
    MainScreenView()
}
