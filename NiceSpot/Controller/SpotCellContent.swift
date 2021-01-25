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
    private let cache = NSCache<NSString, UIImage>()
    @Published var image: Image = Image("placeholder")

    init(spot: Spot) {
        self.title = spot.title!
        self.imageName = spot.imageName!
        loadImage()
    }

    func loadImage() {
        if let imageCached = cache.object(forKey: NSString(string: imageName)) {
            image = Image(uiImage: imageCached)
        } else {
            getPictureData(imageName: imageName) {(result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.image = Image("placeholder")
                        print(error.localizedDescription)
                    }
                case .success(let data):
                    DispatchQueue.main.async {
                        let uiImage = UIImage(data: data)
                        self.image = Image(uiImage: uiImage!)
                        self.cache.setObject(uiImage!, forKey: NSString(string: self.imageName))
                    }
                }
            }
        }
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
