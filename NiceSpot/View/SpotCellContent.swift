//
//  SpotContent.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 18/01/2021.
//

import Foundation
import SwiftUI

class SpotCellContent: ObservableObject {
    private(set) var title: String
    private(set) var detail: String
    private(set) var pictureName: String
    private(set) var municipality: String
    @Published var image: Image = Image("placeholder")
    private let imageName: String
//    @Environment(\.managedObjectContext) private var viewContext
    private let urlAssets = "https://github.com/hludovic/NiceSpot_Assets/blob/master/"

    init(spot: Spot) {
        self.title = spot.title
        self.detail = spot.detail
        self.pictureName = spot.pictureName
        self.municipality = spot.municipality
        self.imageName = spot.pictureName
        updateImage() 
    }
    
    func updateImage() {
        getPictureData(imageName: imageName) { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            case .success(let data):
                print("Success")

                DispatchQueue.main.async { [self] in
                let newImage = UIImage(data: data)
                self.image = Image(uiImage: newImage!)
                }
            }
        }
    }
    
    private func savePicture(data: Data, completion: @escaping (Bool) -> Void) {
        
    }

    private func getPictureData(imageName: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlSession = URLSession(configuration: .default)
        var urlRequest = URLComponents(string: "\(urlAssets)/\(imageName).imageset/image@1x.png")!
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
