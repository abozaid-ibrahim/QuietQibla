//
//  MapView.swift
//  MasgedSilencer
//
//  Created by abuzeid on 26.03.24.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: View {
    @Binding var region: MKCoordinateRegion
    @Binding var tappedLocation: CLLocationCoordinate2D?
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Binding var showDoneButton: Bool
    @State private var annotationCoordinate: MosqueItem?

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: [annotationCoordinate].compactMap { $0 }) { coordinate in
            MapMarker(coordinate: .init(latitude: coordinate.latitude, longitude: coordinate.longitude), tint: .red)
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
            annotationCoordinate = .init(name: "مسجد", latitude: tappedLocation!.latitude, longitude: tappedLocation!.longitude)
            showDoneButton = true
        }
    }
}

extension MKMapView {
    func coordinate(from point: CGPoint) -> CLLocationCoordinate2D {
        let coordinate = convert(point, toCoordinateFrom: self)
        return coordinate
    }
}
