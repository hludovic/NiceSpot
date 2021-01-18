//
//  HomeContent.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 17/01/2021.
//

import Foundation
import CloudKit.CKRecord

class HomeContent {
    let container: CKContainer
    let publicDB: CKDatabase

    private var fetchedSpots: [FetchedSpot] = []

    init() {
        container = CKContainer(identifier: "iCloud.fr.hludovic.container1")
        publicDB = container.publicCloudDatabase
    }
    
    func fetchSpots(completion: @escaping (Result<[FetchedSpot], Error>) -> Void) {
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
            else { completion(.failure(ErrorSpot.test)); return }
            
            let spotFetched = FetchedSpot(recordID: record.recordID, title: title, detail: detail, category: category, location: location, pictureName: pictureName, municipality: municipality)
            newSpotsCK.append(spotFetched)
        }

        operation.queryCompletionBlock =  { (cursor, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(newSpotsCK))
            }
        }
        publicDB.add(operation)
    }
    
    static func getPicture(id: CKRecord.ID, completion: @escaping (Result<URL, Error>) -> Void) {
    }
    
    enum ErrorSpot: Error {
        case test
    }

}

struct FetchedSpot {
    let recordID: CKRecord.ID
    let title: String
    let detail: String
    let category: String
    let location: CLLocation
    var pictureName: String
    var municipality: String
}
