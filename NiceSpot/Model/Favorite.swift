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
    
    static func isFavorite(context: NSManagedObjectContext, spotId: String, completion: @escaping (Bool?) -> Void) {
        getFavorites(context: context) { (favorites) in
            guard !favorites.isEmpty else { return completion(true) }
            for favorite in favorites {
                guard let favoriteId = favorite.spotId else { return completion(nil) }
                if favoriteId == spotId {
                    completion(true)
                    break
                }
                completion(false)
            }
        }
    }
    
    static func saveSpotId(context: NSManagedObjectContext, spotId: String, success: @escaping (Bool) -> Void) {
        isFavorite(context: context, spotId: spotId) { (result) in
            guard let result = result else { return success(false) }
            guard result else { return success(false) }
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
