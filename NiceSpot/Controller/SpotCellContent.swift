//
//  SpotContent.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 18/01/2021.
//

import Foundation
import SwiftUI
import CoreData

class SpotCellContent: ObservableObject {
    private let urlAssets = "https://github.com/hludovic/NiceSpot_Assets/blob/master/"
    private let imageManager = ImageManager()
    @Published var isRedacted: Bool = true
    @Published private(set) var title: String = ""
    @Published private(set) var image: Image = Image("placeholder")

    func loadContent(spotId: String, context: NSManagedObjectContext, success: @escaping (Bool) -> Void) {
        Spot.getSpot(spotId: spotId, context: context) { [unowned self] (result) in
            guard let spot = result else { return success(false) }
            guard let spotTitle = spot.title else { return success(false) }
            guard let spotImageName = spot.imageName else { return success(false) }
            DispatchQueue.main.async { self.title = spotTitle }
            imageManager.getUIImage(imageName: spotImageName) { [unowned self] (uiImage) in
                guard let uiImage = uiImage else { return success(false) }
                DispatchQueue.main.async { self.image = Image(uiImage: uiImage) }
                success(true)
            }
        }
    }

}
