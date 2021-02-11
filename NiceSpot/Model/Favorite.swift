//
//  Favorite.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 10/02/2021.
//

import Foundation
import CoreData

extension Favorite {
    
    static func getFavorites(context: NSManagedObjectContext, completion: @escaping([Favorite]) -> Void ) {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        if let result = try? context.fetch(request) {
            completion(result)
        } else { completion([]) }
    }
    
    static func getFavorite(context: NSManagedObjectContext, spotId: String, completion: @escaping (Favorite?) -> Void ) {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        let predicate = NSPredicate(format: "spotId == %@", spotId)
        request.predicate = predicate
        if let result = try? context.fetch(request){
            guard !result.isEmpty else { return completion(nil) }
            completion(result.first)
        } else { completion(nil) }
    }
    
    static func isFavorite(context: NSManagedObjectContext, spotId: String, completion: @escaping (Bool) -> Void) {
        getFavorites(context: context) { (favorites) in
            if favorites.count > 0 {
                for favorite in favorites {
                    guard let favoriteId = favorite.spotId else { return }
                    if favoriteId == spotId {
                        return completion(true)
                    }
                }
                completion(false)
            } else {
                completion(false)
            }
        }
    }
        
    static func saveSpotId(context: NSManagedObjectContext, spotId: String, success: @escaping (Bool) -> Void) {
        isFavorite(context: context, spotId: spotId) { (isFavorite) in
            guard !isFavorite else { return success(false) }
            let favorite = Favorite(context: context)
            favorite.spotId = spotId
            do {
                try context.save()
            } catch {
                success(false)
            }
            success(true)
        }
    }
    
    static func remove(context: NSManagedObjectContext, spotId: String, success: @escaping (Bool) -> Void) {
        getFavorite(context: context, spotId: spotId) { (favorite) in
            guard let favorite = favorite else { return success(false) }
            context.delete(favorite)
            success(true)
        }
    }

}
