//
//  MapView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 21/01/2021.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var content: DetailContent
    
    var body: some View {
        Map(coordinateRegion: $content.spot.mapRegion,
            interactionModes: MapInteractionModes.zoom,
            annotationItems: [content.spot.location]) { spot in
            MapMarker(coordinate: spot.coordinate, tint: .red)
//            MapAnnotation(coordinate: spot.coordinate) {
//                VStack {
//                    Circle()
//                        .stroke(Color.red)
//                        .frame(width: 40, height: 40)
//                }
//            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let spotDetailContent = DetailContent(spot: Preview.spot)
        MapView(content: spotDetailContent)
    }
}

