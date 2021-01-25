//
//  SpotDetailContent.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 19/01/2021.
//

import Foundation
import CoreLocation
import SwiftUI

class SpotDetailContent: ObservableObject {
    let title: String
    let detail: String
    let imageName: String
    let municipality: String
    let category: String
    let location: SpotLocation
    let mapLink: URL
    @Published var image: Image = Image("placeholder")

    init(spot: Spot) {
        let coodinate = CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude)
        self.title = spot.title!
        self.detail = spot.detail!
        self.imageName = spot.imageName!
        self.municipality = spot.municipality!
        self.category = spot.category!
        self.location = SpotLocation(coordinate: coodinate)
        self.mapLink = URL(string: "maps://?ll=\(spot.latitude),\(spot.longitude)")!
        loadImage()
    }

    func loadImage() {
    }
}

struct SpotLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
