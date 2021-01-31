//
//  Comment.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 30/01/2021.
//

import Foundation
import CloudKit

class Comment {
    
    static let publicDB: CKDatabase = CKContainer(identifier: "iCloud.fr.hludovic.container1").publicCloudDatabase


    static func getComments(ckDatabase: CKDatabase, spotId: String, completion: @escaping (Result<[Comment.Item], Error>) -> Void) {
        let record = CKRecord.ID(recordName: spotId)
        let reference = CKRecord.Reference(recordID: record, action: .none)
        
        let predicate = NSPredicate(format: "spot == %@", reference)
        let querry = CKQuery(recordType: "Comments", predicate: predicate)
        let operation = CKQueryOperation(query: querry)
        operation.desiredKeys = ["title", "detail"]
        var commentList: [Item] = []
        
        operation.recordFetchedBlock = { record in
            guard
                let title = record["title"] as? String,
                let detail = record["detail"] as? String,
                let author = record.creatorUserRecordID?.recordName
            else { return }
            
            let commentFetched = Item(id: record.recordID.recordName,title: title, detail: detail, author: author)
            commentList.append(commentFetched)
        }
        
        operation.queryCompletionBlock = { cursor, error in
            if let error = error {
                // ADD THE ERROR !!!
                print("\(error.localizedDescription) >>>")
                completion(.failure(NiceSpotError.wrongUrlSessionStatus))
                print("ERROR")
            } else {
                completion(.success(commentList))
            }
        }
        ckDatabase.add(operation)
    }

    static func postComment(ckDatabase: CKDatabase, spotId: String, title: String, content: String, success: @escaping (Bool) -> Void) {
        guard title != "", content != "" else { return success(false) }
        guard isICloudAvailable() else { return success(false) }
        
        let commentRecord = CKRecord(recordType: "Comments")
        let reference = CKRecord.Reference(recordID: CKRecord.ID(recordName: spotId), action: .deleteSelf)
        commentRecord["title"] = title as CKRecordValue
        commentRecord["detail"] = content as CKRecordValue
        commentRecord["spot"] = reference
        
        ckDatabase.save(commentRecord) { (record, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return success(false)
                
            }
            success(true)
        }
    }

    private static func isICloudAvailable() -> Bool{
        if let _ = FileManager.default.ubiquityIdentityToken{
            return true
        } else {
            return false
        }
    }

    struct Item: Identifiable {
        let id: String
        let title: String
        let detail: String
        let author: String
    }


}
