//
//  ImageManager.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 05/02/2021.
//

import Foundation
import UIKit
import SwiftUI

class ImageManager {
    private let urlAssets = "https://raw.githubusercontent.com/hludovic/NiceSpotAssets/main"
        
    func loadImage(imageName: String, completion: @escaping (Image) -> Void) {
        guard let url = URL(string: "\(urlAssets)/\(imageName)/\(imageName)_1.jpg") else { return }
        let cache = URLCache.shared
        let urlRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60.0)
        if let data = cache.cachedResponse(for: urlRequest)?.data {
            let image = dataToImage(data: data)
            return completion(image)
        } else {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let data = data,  let response = response {
                    let cachedResponse = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedResponse, for: urlRequest)
                    DispatchQueue.main.async {
                        let image = self.dataToImage(data: data)
                        return completion(image)
                    }
                }
            }.resume()
        }
    }
    
    private func dataToImage(data: Data) -> Image {
        guard let uiImage = UIImage(data: data) else {
            return Image(uiImage: UIImage())
        }
        return Image(uiImage: uiImage)
    }
}
