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
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Location")
                    .fontWeight(.medium)
                Spacer()
                Button(action: {
                    showingSheet = true
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                })
            }
            .font(.subheadline)
            .offset(y: -5)
            .padding(.bottom, -5)
            Map(coordinateRegion: $content.mapRegion,
                interactionModes: MapInteractionModes.zoom,
                annotationItems: [content.spot.location]) { spot in
                MapMarker(coordinate: spot.coordinate, tint: .red)
            }
        }
        .actionSheet(isPresented: $showingSheet) {
            ActionSheet(
                title: Text("Do you want to consult the location on Maps ?"),
                message: nil,
                buttons: [
                    .default(Text("Open in maps"), action: {
                        content.openInMap()
                    }),
                    .cancel()
                ]
            )
        }

    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(content: Preview.detailContent)
    }
}

