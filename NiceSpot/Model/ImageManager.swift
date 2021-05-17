//
//  ImageManager.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 05/02/2021.
//

import Foundation

class ImageManager {
    private let urlAssets = "https://raw.githubusercontent.com/hludovic/NiceSpotAssets/main"

    func loadImageData(imageName: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: "\(urlAssets)/\(imageName)/\(imageName)_1.jpg") else { return }
        let cache = URLCache.shared
        let urlRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60.0)
        if let data = cache.cachedResponse(for: urlRequest)?.data {
            return completion(data)
        } else {
            URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                if let data = data, let response = response {
                    let cachedResponse = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedResponse, for: urlRequest)
                    DispatchQueue.main.async {
                        return completion(data)
                    }
                }
            }.resume()
        }
    }
}
