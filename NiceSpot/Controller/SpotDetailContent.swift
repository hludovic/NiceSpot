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
    let pictureName: String
    let municipality: String
    let category: String
    let location: SpotLocation
    let mapLink: URL
    let imageData: Data?
    @Published var imageLarge: Image = Image("placeholder")
    private let urlAssets = "https://github.com/hludovic/NiceSpot_Assets/blob/main"

    init(spot: Spot) {
        let coodinate = CLLocationCoordinate2D(latitude: spot.longitude, longitude: spot.latitude)
        self.title = spot.title!
        self.detail = spot.detail!
        self.pictureName = spot.pictureName!
        self.municipality = spot.municipality!
        self.category = spot.category!
        self.location = SpotLocation(coordinate: coodinate)
        self.mapLink = URL(string: "maps://?ll=\(spot.latitude),\(spot.longitude)")!
        self.imageData = spot.pictureData
        loadPicture { (success) in
            if success {
                print("YEAH")
            } else {
                print("❌ No")
            }
        }
    }

    private func loadPicture(completion: @escaping (Bool) -> Void) {
        
        if let imageData = imageData {
            let newImage = UIImage(data: imageData)
            if let largeData = newImage {
                imageLarge = Image(uiImage: largeData)
                completion(true)
                return
            }
            completion(false)
        }
        let urlSession = URLSession(configuration: .default)
        var urlRequest = URLComponents(string: "\(urlAssets)/\(pictureName).imageset/image@2x.jpg")!
        urlRequest.queryItems = [URLQueryItem(name: "raw", value: "true")]
        let dataTask = urlSession.dataTask(with: urlRequest.url!) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(false)
                return
            }
            if let newImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageLarge = Image(uiImage: newImage)
                }
                completion(true)
            }
            completion(false)
        }
        dataTask.resume()
    }
}

struct SpotLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
