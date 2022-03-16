//
//  Spot.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 15/03/2022.
//

import Foundation
import CoreData
import CloudKit

class Spot {
    let recordID: String
    let creationDate: Date
    let title: String
    let detail: String
    let category: Spot.Category
    let longitude: Double
    let latitude: Double
    let pictureName: String
    let municipality: Spot.Municipality
    let recordChangeTag: String
    private static let viewContext = PersistenceController.shared.container.viewContext
    
    private init(id: String,
                 date: Date,
                 title: String,
                 category: Spot.Category,
                 detail: String,
                 longitude: Double,
                 latitude: Double,
                 picture: String,
                 municipality: Spot.Municipality,
                 sha: String) {
        self.recordID = id
        self.creationDate = date
        self.title = title
        self.detail = detail
        self.category = category
        self.longitude = longitude
        self.latitude = latitude
        self.pictureName = picture
        self.municipality = municipality
        self.recordChangeTag = sha
    }
    
    func isFavorite(context: NSManagedObjectContext = viewContext) throws -> Bool {
        let request: NSFetchRequest<FavoriteMO> = FavoriteMO.fetchRequest()
        let predicate = NSPredicate(format: "spotID == %@", self.recordID)
        request.predicate = predicate
        let result = try context.fetch(request)
        return result.isEmpty ? false : true
    }
    
    static func getSpots(context: NSManagedObjectContext = viewContext) throws -> [Spot] {
        let request: NSFetchRequest<SpotMO> = SpotMO.fetchRequest()
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        request.sortDescriptors = [sort]
        let spotsMO: [SpotMO] = try context.fetch(request)
        var result: [Spot] = []
        for spotMO in spotsMO {
            let spot = try convertSpotMOToSpot(spotMO)
            result.append(spot)
        }
        return result
    }
    
    static func getFavorites(context: NSManagedObjectContext = viewContext) throws -> [Spot] {
        let favoriteIDs = try getFavoriteIDs(context: context)
        var result: [Spot] = []
        for favoriteID in favoriteIDs {
            let spot = try getSpot(context: context, id: favoriteID)
            result.append(spot)
        }
        return result
    }
    
    static func searchSpots(context: NSManagedObjectContext = viewContext, titleContains: String) throws -> [Spot] {
        guard (titleContains != "") && (titleContains != " ") else {throw SpotError.searchSpotWrongName }
        let request: NSFetchRequest<SpotMO> = SpotMO.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", titleContains)
        request.predicate = predicate
        let spotsMO = try context.fetch(request)
        var result: [Spot] = []
        for spotMO in spotsMO {
            let spot = try convertSpotMOToSpot(spotMO)
            result.append(spot)
        }
        return result
    }
    
    func saveToFavorite(context: NSManagedObjectContext = viewContext, date: Date = Date()) throws -> Bool {
        let isFavorite = try isFavorite(context: context)
        guard !isFavorite else { return false }
        let favoriteMO = FavoriteMO(context: context)
        favoriteMO.spotID = self.recordID
        favoriteMO.dateSaved = date
        try context.save()
        return true
    }
    
    func removeToFavorite(context: NSManagedObjectContext) throws -> Bool {
        let isFavorite = try isFavorite(context: context)
        guard isFavorite else { return false }
        let favoriteMO = try getFavoriteMO(context: context, id: self.recordID)
        context.delete(favoriteMO)
        try context.save()
        return true
    }
    
    static func refreshSpots(context: NSManagedObjectContext = viewContext, completion: @escaping (Result<Bool, Error>) -> Void) {
        Spot.fetchSpots { result in
            switch result {
            case .failure(let error):
                return completion(Result.failure(error))
            case .success(let spots):
                Spot.saveSpots(context: context, spots: spots) { result in
                    switch result {
                    case .failure(let error):
                        return completion(.failure(error))
                    case .success(let success):
                        return completion(.success(success))
                    }
                }
            }
        }
    }

}

// MARK: - Private Methods CoreData

private extension Spot {

    static func convertSpotMOToSpot(_ spotMO: SpotMO) throws -> Spot {
        guard
            let spotID = spotMO.recordID,
            let date = spotMO.creationDate,
            let title = spotMO.title,
            let detail = spotMO.detail,
            let categoryString = spotMO.category,
            let pictureName = spotMO.pictureName,
            let municipalityString = spotMO.municipality,
            let recordChangeTag = spotMO.recordChangeTag
        else { throw SpotError.failReadingSpotMOWhenConvert }
        let spot = Spot(id: spotID,
                        date: date,
                        title: title,
                        category: Spot.Category(rawValue: categoryString) ?? .unknown,
                        detail: detail,
                        longitude: spotMO.longitude,
                        latitude: spotMO.latitude,
                        picture: pictureName,
                        municipality: Spot.Municipality(rawValue: municipalityString) ?? .unknown,
                        sha: recordChangeTag
        )
        return spot
    }
    
    func getFavoriteMO(context: NSManagedObjectContext, id: String) throws -> FavoriteMO {
        let request: NSFetchRequest<FavoriteMO> = FavoriteMO.fetchRequest()
        let predicate = NSPredicate(format: "spotID == %@", id)
        request.predicate = predicate
        let favoritesMO = try context.fetch(request)
        guard let result = favoritesMO.first else { throw SpotError.readFavoriteMOWhenGettingFavoriteMO }
        return result
    }
    
    static func getSpot(context: NSManagedObjectContext, id: String) throws -> Spot {
        let request: NSFetchRequest<SpotMO> = SpotMO.fetchRequest()
        let predicate = NSPredicate(format: "recordID == %@", id)
        request.predicate = predicate
        let spotsMO: [SpotMO] = try context.fetch(request)
        guard let spotMO = spotsMO.first else { throw SpotError.readSpotMOWhenGettingSpot }
        let result = try convertSpotMOToSpot(spotMO)
        return result
    }
    
    static func getFavoriteIDs(context: NSManagedObjectContext) throws -> [String] {
        let request: NSFetchRequest<FavoriteMO> = FavoriteMO.fetchRequest()
        let sort = NSSortDescriptor(key: "dateSaved", ascending: true)
        request.sortDescriptors = [sort]
        var result: [String] = []
        let favoritesMO = try context.fetch(request)
        for favoriteMO in favoritesMO {
            guard let favoriteID = favoriteMO.spotID else { throw SpotError.readFavoriteInGetFav }
            result.append(favoriteID)
        }
        return result
    }
    
}

// MARK: - CloudKit

private extension Spot {

    static func fetchSpots(completion: @escaping (Result<[Spot], Error>) -> Void ) {
        let predicate = NSPredicate(value: true)
        let querry = CKQuery(recordType: "SpotCK", predicate: predicate)
        let operation = CKQueryOperation(query: querry)
        operation.desiredKeys = ["title", "detail", "category", "location", "municipality", "pictureName"]
        var newSpotsCK: [Spot] = []
        // - recordMatchedBlock -
        operation.recordMatchedBlock = { recordID, recordResult in
            switch recordResult {
            case .failure(let error ):
                return completion(Result.failure(error))
            case .success(let ckrecord):
                guard
                    let date = ckrecord.creationDate,
                    let title = ckrecord["title"] as? String,
                    let detail = ckrecord["detail"] as? String,
                    let recordChangeTag = ckrecord.recordChangeTag,
                    let category = ckrecord["category"] as? String,
                    let location = ckrecord["location"] as? CLLocation,
                    let pictureName = ckrecord["pictureName"] as? String,
                    let municipality = ckrecord["municipality"] as? String
                else { return completion(Result.failure(SpotError.failReadingSpotCK)) }
                let spotFetched = Spot(id: recordID.recordName,
                                  date: date,
                                  title: title,
                                  category: Spot.Category(rawValue: category) ?? .unknown,
                                  detail: detail,
                                  longitude: location.coordinate.longitude,
                                  latitude: location.coordinate.latitude,
                                  picture: pictureName,
                                  municipality: Spot.Municipality(rawValue: municipality) ?? .unknown,
                                  sha: recordChangeTag
                )
                newSpotsCK.append(spotFetched)
            }
        }
        // - querryResultBlock -
        operation.queryResultBlock = { operationResult in
            switch operationResult {
            case .failure( let error ):
                return completion(Result.failure(error))
            case .success:
                return completion(Result.success(newSpotsCK))
            }
        }
        // - run the operation -
        PersistenceController.publicCKDB.add(operation)
    }

    static func saveSpots(context: NSManagedObjectContext, spots: [Spot], completion: @escaping (Result<Bool, Error>) -> Void) {
        guard spots.count > 0 else { return completion(Result.failure(SpotError.noSpotsToSave)) }
        let dispatchGroup = DispatchGroup()
        for spot in spots {
            dispatchGroup.enter()
            spot.saveSpot(context: context) { result in
                if case Result.failure(let error) = result {
                    return completion(Result.failure(error))
                }
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            return completion(Result.success(true))
        }
    }

    func saveSpot(context: NSManagedObjectContext, completion: @escaping (Result<Bool, Error>) -> Void) {
        let spotMO = SpotMO(context: context)
        spotMO.recordID = self.recordID
        spotMO.creationDate = self.creationDate
        spotMO.title = self.title
        spotMO.detail = self.detail
        spotMO.longitude = self.longitude
        spotMO.latitude = self.latitude
        spotMO.category = self.category.rawValue
        spotMO.municipality = self.municipality.rawValue
        spotMO.pictureName = self.pictureName
        spotMO.recordChangeTag = self.recordChangeTag
        do {
            try context.save()
        } catch let error {
            return completion(Result.failure(error))
        }
        return completion(Result.success(true))
    }

}
