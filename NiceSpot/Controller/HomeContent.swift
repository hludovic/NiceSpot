//
//  HomeContent.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 17/01/2021.
//

import Foundation
import CloudKit.CKRecord
import CoreData

class HomeContent: ObservableObject {
    // MARK: Properties
    private let publicDB: CKDatabase = CKContainer(identifier: "iCloud.fr.hludovic.container1").publicCloudDatabase
    private let context: NSManagedObjectContext
    @Published var spots: [Spot] = []
    @Published var errorMessage: String = ""

    // MARK: - Init Method
    init(context: NSManagedObjectContext) {
        self.context = context
        let request: NSFetchRequest<Spot> = Spot.fetchRequest()
        if let result = try? context.fetch(request) {
            self.spots = result
        } else { self.spots = [] }
    }

    func refreshSpots (success: @escaping (Bool) -> Void) {
        fetchSpots { [unowned self] (result) in
            switch result {
            case .success(let fetchedSpots):
                self.clearSpots() { [unowned self] (cleared) in
                    if cleared {
                        self.saveFetchedSpots(fetchedSpots: fetchedSpots) { [unowned self] (saved) in
                            if saved {
                                Spot.allSpots(context: self.context) { [unowned self] (result) in
                                    DispatchQueue.main.async {
                                        self.spots = result
                                        success(true)
                                    }
                                }
                            } else {
                                self.errorMessage = "ERROR: Not converted"
                                success(false)
                            }
                        }
                    } else {
                        self.errorMessage = "ERROR: Not cleared"
                        success(false)
                    }
                }
                
            case.failure(let error):
                self.errorMessage = "ERROR: Not fetched \(error.localizedDescription)"
                success(false)
            }
        }
    }
}

// MARK: - Private Methods
private extension HomeContent {

    private func clearSpots(completion: @escaping (Bool) -> Void) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Spot.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            completion(true)
        } catch {
            completion(false)
        }
        NiceSpotApp.imageCache.removeAllObjects()
    }

    private func saveFetchedSpots(fetchedSpots: [FetchedSpot], completion: @escaping (Bool) -> Void) {
        for fetchedSpot in fetchedSpots {
            let spot = Spot(context: context)
            spot.id = fetchedSpot.recordID.recordName
            spot.title = fetchedSpot.title
            spot.detail = fetchedSpot.detail
            spot.category = fetchedSpot.category
            spot.municipality = fetchedSpot.municipality
            spot.imageName = fetchedSpot.pictureName
            spot.latitude = fetchedSpot.location.coordinate.latitude
            spot.longitude = fetchedSpot.location.coordinate.longitude
            do {
                try context.save()
            } catch {
                completion(false)
            }
        }
        completion(true)
    }

    private func fetchSpots(completion: @escaping (Result<[FetchedSpot], Error>) -> Void) {
        let predicate = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let querry = CKQuery(recordType: "SpotCK", predicate: predicate)
        querry.sortDescriptors = [sort]
        let operation = CKQueryOperation(query: querry)
        operation.desiredKeys = ["title", "detail", "category", "location", "municipality", "pictureName"]
        var newSpotsCK: [FetchedSpot] = []
        operation.recordFetchedBlock = { record in
            guard
                let title = record["title"] as? String,
                let detail = record["detail"] as? String,
                let category = record["category"] as? String,
                let location = record["location"] as? CLLocation,
                let pictureName = record["pictureName"] as? String,
                let municipality = record["municipality"] as? String
            else { completion(.failure(NiceSpotError.failFetchingSpots)); return }
            
            let spotFetched = FetchedSpot(recordID: record.recordID, title: title, detail: detail, category: category, location: location, pictureName: pictureName, municipality: municipality)
            newSpotsCK.append(spotFetched)
        }
        operation.queryCompletionBlock = { (cursor, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(newSpotsCK))
            }
        }
        publicDB.add(operation)
    }

    private struct FetchedSpot {
        let recordID: CKRecord.ID
        let title: String
        let detail: String
        let category: String
        let location: CLLocation
        var pictureName: String
        var municipality: String
    }
}
