//
//  SpotContent.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 18/01/2021.
//

import Foundation
import SwiftUI

class SpotCellContent: ObservableObject {
    private let urlAssets = "https://github.com/hludovic/NiceSpot_Assets/blob/master/"
    private let imageManager = ImageManager()
    private let spot: Spot
    @Published private(set) var isRedacted: Bool = true
    @Published private(set) var title: String
    @Published private(set) var municipality: String
    @Published private(set) var category: String
    @Published private(set) var image: Image
    
    init(spot: Spot) {
        self.spot = spot
        self.title = spot.title!
        self.municipality = spot.municipality!
        self.category = spot.category!
        self.image = Image("placeholder")
        loadImage(imageName: spot.imageName!)
    }
    
    private func loadImage(imageName: String) {
        imageManager.loadImage(imageName: imageName) { image in
            DispatchQueue.main.async {
                self.image = image
                self.isRedacted = false
            }
        }
    }
}
