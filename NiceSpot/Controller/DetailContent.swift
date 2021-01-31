//
//  SpotDetailContent.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 19/01/2021.
//

import Foundation
import CoreLocation
import SwiftUI

class DetailContent: ObservableObject {
    private let spotId: String
    let title: String
    let detail: String
    let imageName: String
    let municipality: String
    let category: String
    let location: SpotLocation
    let mapLink: URL
    @Published var image: Image = Image("placeholder")
    @Published var comments: [Comment.Item] = []

    init(spot: Spot) {
        let coodinate = CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude)
        self.spotId = spot.id!
        self.title = spot.title!
        self.detail = spot.detail!
        self.imageName = spot.imageName!
        self.municipality = spot.municipality!
        self.category = spot.category!
        self.location = SpotLocation(coordinate: coodinate)
        self.mapLink = URL(string: "maps://?ll=\(spot.latitude),\(spot.longitude)")!
    }
    
    func loadComments() {
        Comment.getComments(ckDatabase: Comment.publicDB, spotId: spotId) { (result) in
            switch result {
            case .failure(let error):
                print(" ERROR LOADING COMMENTS \(error.localizedDescription)")
            case .success(let comments):
                DispatchQueue.main.async {
                    self.comments = comments
                }
            }
        }
    }

    func loadImage() {
        if let imageCached = NiceSpotApp.imageCache.object(forKey: NSString(string: imageName)) {
            image = Image(uiImage: imageCached)
        }
    }
}
