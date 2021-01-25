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
    private(set) var title: String
    private let imageName: String
//    private let spotId: String
    @Published var image: Image = Image("placeholder")

    init(spot: Spot) {
//        guard let spotId = spot.id else { return nil }
        self.title = spot.title!
        self.imageName = spot.pictureName!
//        self.spotId = spotId
    }

    func loadImage() {
        getPictureData(imageName: imageName) { (result) in
            switch result {
            case .failure(let error):
                print("❌ \(error.localizedDescription)")
            case .success(let data):
                let newImage = UIImage(data: data)
                DispatchQueue.main.async { self.image = Image(uiImage: newImage!) }
            }
        }
    }

    private func getSpot(id: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
    }

    private func savePicture(data: Data, completion: @escaping (Bool) -> Void) {
        
    }

    private func getPictureData(imageName: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlSession = URLSession(configuration: .default)
        var urlRequest = URLComponents(string: "\(urlAssets)/\(imageName).imageset/image@1x.jpg")!
        urlRequest.queryItems = [URLQueryItem(name: "raw", value: "true")]
        let dataTask = urlSession.dataTask(with: urlRequest.url!) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(NiceSpotError.failLoadingPictureData))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(NiceSpotError.wrongUrlSessionStatus))
                return
            }
            completion(.success(data))
        }
        dataTask.resume()
    }
}
