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
    private let context: NSManagedObjectContext
    private let spotId: String
    //UIIMAGE TO NSDATA
    private let cache = NSCache<NSString, UIImage>()
    @Published var isRedacted: Bool = true
    @Published private(set) var title: String = ""
    @Published private(set) var image: Image = Image("placeholder")

    init(spotId: String, context: NSManagedObjectContext) {
        self.spotId = spotId
        self.context = context
        loadContent { (success) in
            DispatchQueue.main.async {
                self.isRedacted = false
            }
        }
    }
    
    func loadContent(success: @escaping (Bool) -> Void) {
        getSpot(id: spotId) { (result) in
            guard let spot = result else {
                print("--- ERROR LOADING SPOT ---")
                success(false)
                return
            }
            DispatchQueue.main.async { self.title = spot.title! }
            self.getImage(imageName: spot.imageName!) { (image) in
                DispatchQueue.main.async { self.image = image }
                success (true)
                return
            }

        }
    }
    
    func getImage(imageName: String, completion: @escaping (Image) -> Void) {
        if let imageCached = cache.object(forKey: NSString(string: imageName)) {
            print("--- Get Image Cached ---")
            completion(Image(uiImage: imageCached))
        } else {
            getPictureData(imageName: imageName) {(result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(Image("placeholder"))
                case .success(let data):
                    let uiImage = UIImage(data: data)
                    self.cache.setObject(uiImage!, forKey: NSString(string: imageName))
                    completion(Image(uiImage: uiImage!))
                }
            }
        }
    }
    
    private func getSpot(id: String, completion: @escaping (Spot?) -> Void) {
        let fetch = NSFetchRequest<Spot>(entityName: "Spot")
        fetch.predicate = NSPredicate(format: "id == %@", spotId)
        guard let result = try? context.fetch(fetch) else {
            completion(nil)
            return
        }
        guard let spot = result.first else {
            completion(nil)
            return
        }
        completion(spot)
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
