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
struct MosqueListView: View {
    let locations: [MosqueItem] =  UserDefaultsLocationRepository().fetchAll()
    var body: some View {
        VStack {
            List(locations, id: \.id) { location in
                Text("\(location.location.description)")
            }

            Text("Silencer Location Count: \(locations.count)")
                .padding()
        }
    }
}

enum Screen {
    case mapScreen
    case mosqueList
}

class Router: ObservableObject {
    @Published var path = NavigationPath()
}

var locationManager = LocationManager()

struct ContentView: View {
    @EnvironmentObject var router: Router

    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
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
                    MapScreen(locationManager: locationManager)
                case .mosqueList:
                    MosqueListView()
                }
            }
        }
    }
}

struct MapScreen: View {
    @EnvironmentObject var router: Router

    @ObservedObject var locationManager: LocationManager
    @State private var tappedLocation: CLLocationCoordinate2D?
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var showDoneButton = false
    @ObservedObject var location = CurrentLocation()
    @State private var region = MKCoordinateRegion()
    let repo: LocationRepository = UserDefaultsLocationRepository()
    var body: some View {
        VStack {
            MapView(region: $region, tappedLocation: $tappedLocation, selectedLocation: $selectedLocation, showDoneButton: $showDoneButton)

            Spacer()

            if showDoneButton {
                Button("Done") {
                    if let location = selectedLocation {
                        repo.addLocation(MosqueItem(location: CLLocation(latitude: location.latitude, longitude: location.longitude)))
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

struct MapView: View {
    @Binding var region: MKCoordinateRegion
    @Binding var tappedLocation: CLLocationCoordinate2D?
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Binding var showDoneButton: Bool
    @State private var annotationCoordinate: MosqueItem?
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: [annotationCoordinate].compactMap { $0 }) { coordinate in
            MapMarker(coordinate: coordinate.location.coordinate, tint: .red)
        }
        .edgesIgnoringSafeArea(.all)
        .onTapGesture { tap in
            let mapViewSize = UIScreen.main.bounds.size
            let mapCenter = CGPoint(x: mapViewSize.width / 2, y: mapViewSize.height / 2)
            let tapXFromCenter = tap.x - mapCenter.x
            let tapYFromCenter = tap.y - mapCenter.y
            let longitudePerPixel = region.span.longitudeDelta / Double(mapViewSize.width)
            let latitudePerPixel = region.span.latitudeDelta / Double(mapViewSize.height)
            let longitude = region.center.longitude + Double(tapXFromCenter) * longitudePerPixel
            let latitude = region.center.latitude - Double(tapYFromCenter) * latitudePerPixel
            tappedLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            selectedLocation = tappedLocation
            annotationCoordinate = .init(location: .init(latitude: tappedLocation!.latitude, longitude: tappedLocation!.longitude))
            showDoneButton = true
        }
    }
}

struct MosqueItem: Identifiable {
    let id = UUID()
    let masgadName: String = "Osama bin Zaid"
    let location: CLLocation
}

//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let locationManager = CLLocationManager()
//    @Published var locations: [MosqueItem] = []
//    @Published var region = MKCoordinateRegion()
//    private var isFocusModeEnabled = false
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//
//    func addLocation(_ location: CLLocation) {
//        locations.append(MosqueItem(location: location))
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//
//        for savedLocation in self.locations {
//            let distance = location.distance(from: savedLocation.location)
//            if distance < 100 { // Change 100 to your desired radius in meters
//                shouldEnableFocusMode()
//                return
//            }
//        }
//
//        shouldDisableFocusMode()
//    }
//
//    private func shouldEnableFocusMode() {
//        guard !isFocusModeEnabled else { return }
//        enableFocusMode()
//    }
//
//    private func enableFocusMode() {
//        guard !isFocusModeEnabled else { return }
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
//            isFocusModeEnabled = true
//        } catch {
//            print("Failed to enable focus mode: \(error.localizedDescription)")
//        }
//    }
//
//    private func shouldDisableFocusMode() {
//        guard isFocusModeEnabled else { return }
//
//        disableFocusMode()
//    }
//
//    private func disableFocusMode() {
//        guard isFocusModeEnabled else { return }
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
//            isFocusModeEnabled = false
//        } catch {
//            print("Failed to disable focus mode: \(error.localizedDescription)")
//        }
//    }
//}

#Preview {
    ContentView()
}

class CurrentLocation: NSObject, CLLocationManagerDelegate, ObservableObject {
    private var locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocation()
        case .denied, .restricted:
            print("Location services denied or restricted.")
        case .notDetermined:
            print("Location services not determined.")
        @unknown default:
            print("Unknown authorization status.")
        }
    }
}

extension MKMapView {
    func coordinate(from point: CGPoint) -> CLLocationCoordinate2D {
        let coordinate = convert(point, toCoordinateFrom: self)
        return coordinate
    }
}
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var region = MKCoordinateRegion()
    private var isFocusModeEnabled = false
    private let locationRepository = UserDefaultsLocationRepository()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

        for savedLocation in locationRepository.fetchAll().map{$0.location} {
            let distance = location.distance(from: savedLocation)
            if distance < 100 { // Change 100 to your desired radius in meters
                shouldEnableFocusMode()
                return
            }
        }

        shouldDisableFocusMode()
    }

    private func shouldEnableFocusMode() {
        guard !isFocusModeEnabled else { return }
        enableFocusMode()
    }

    private func enableFocusMode() {
        guard !isFocusModeEnabled else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
            isFocusModeEnabled = true
        } catch {
            print("Failed to enable focus mode: \(error.localizedDescription)")
        }
    }

    private func shouldDisableFocusMode() {
        guard isFocusModeEnabled else { return }

        disableFocusMode()
    }

    private func disableFocusMode() {
        guard isFocusModeEnabled else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
            isFocusModeEnabled = false
        } catch {
            print("Failed to disable focus mode: \(error.localizedDescription)")
        }
    }
}
