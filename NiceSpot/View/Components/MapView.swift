//
//  MapView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 21/01/2021.
//

import SwiftUI
import MapKit

struct MapView: View {
    var spotLocation : SpotLocation
    @State private var region = MKCoordinateRegion(center: .init(latitude: 16.336675, longitude: -61.785863),
                                                   latitudinalMeters: 1000,
                                                   longitudinalMeters: 1000
    )
    private func loadMap(spot: SpotLocation) {
        region = MKCoordinateRegion(center: spot.coordinate,
                                    latitudinalMeters: 1000,
                                    longitudinalMeters: 1000
        )
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [spotLocation]) { spot in
            MapAnnotation(coordinate: spot.coordinate) {
                VStack {
                    Circle()
                        .stroke(Color.red)
                        .frame(width: 40, height: 40)
                }
                
            }
        }
        .onAppear {
            loadMap(spot: spotLocation)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let coordinate = CLLocationCoordinate2D(latitude: 25.7617, longitude: 80.1918)
        MapView(spotLocation: .init(coordinate: coordinate))
    }
}


