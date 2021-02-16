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
        Map(coordinateRegion: $content.mapRegion,
            interactionModes: MapInteractionModes.zoom,
            annotationItems: [content.spot.location]) { spot in
            MapMarker(coordinate: spot.coordinate, tint: .red)
        }
    }
    
    struct MapView_Previews: PreviewProvider {
        static var previews: some View {
            MapView(content: Preview.detailContent)
        }
    }
}
