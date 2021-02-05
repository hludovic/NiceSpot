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
    @Published var isRedacted: Bool = true
    @Published private(set) var title: String = ""
    @Published private(set) var municipality: String = ""
    @Published private(set) var category: String = ""
    @Published private(set) var image: Image = Image("placeholder")

    init(spot: Spot) {
        self.spot = spot
    }

    func loadContent() {
        guard
            let title = spot.title,
            let municipality = spot.municipality,
            let category = spot.category,
            let imageNamge = spot.imageName
        else { return }
        imageManager.getUIImage(imageName: imageNamge) { (uiImage) in
            guard let uiImage = uiImage else { return }
            DispatchQueue.main.async {
                self.title = title
                self.municipality = municipality
                self.category = category
                self.image = Image(uiImage: uiImage)
                self.isRedacted = false
            }
        }
    }
}
