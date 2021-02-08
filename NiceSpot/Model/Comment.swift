//
//  Comment.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 30/01/2021.
//

import Foundation
import CloudKit

class Comment {
    // MARK: - Public Static Property
    
    static let publicDB: CKDatabase = CKContainer(identifier: "iCloud.fr.hludovic.container1").publicCloudDatabase
    static var isICloudAvailable: Bool {
        if let _ = FileManager.default.ubiquityIdentityToken{
            return true
        } else { return false }
    }
    
    // MARK: - Public Static methods
    
    /// Retrieves all the comments posted on a Spot.
    /// - Parameters:
    ///   - ckDatabase: The CKDatabase used for this task.
    ///   - spotId: The ID of the spot you wish to querry.
    ///   - completion: The callback called after retrieval.
    /// Returns a table of Comment.Item containing the result of the query, or an Error if the task failed.
    static func getComments(ckDatabase: CKDatabase, spotId: String, completion: @escaping (Result<[Comment.Item], Error>) -> Void) {
        let record = CKRecord.ID(recordName: spotId)
        let reference = CKRecord.Reference(recordID: record, action: .none)
        let predicate = NSPredicate(format: "spot == %@", reference)
        let querry = CKQuery(recordType: "Comments", predicate: predicate)
        let operation = CKQueryOperation(query: querry)
        operation.desiredKeys = ["title", "detail", "pseudo"]
        var commentList: [Item] = []
        
        operation.recordFetchedBlock = { record in
            guard
                let title = record["title"] as? String,
                let detail = record["detail"] as? String,
                let authorPseudo = record["pseudo"] as? String,
                let authorID = record.creatorUserRecordID?.recordName,
                let creationDate = record.creationDate
            else { return }
            let commentFetched = Item(id: record.recordID.recordName,title: title, detail: detail, authorID: authorID, authorPseudo: authorPseudo, creationDate: creationDate)
            commentList.append(commentFetched)
        }
        
        operation.queryCompletionBlock = { cursor, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(commentList))
            }
        }
        ckDatabase.add(operation)
    }
    
    /// Post a comment on a spot.
    /// - Parameters:
    ///   - spotId: The ID of the spot to which this comment relates.
    ///   - title: The title of the comment.
    ///   - content: The content of the comment.
    ///   - pseudo: The pseudonym of the author of the comment.
    ///   - success: Dismiss if the task has been completed successfully.
    static func postComment(spotId: String, title: String, content: String, pseudo: String, success: @escaping (Bool) -> Void) {
        canPostComment(spotId: spotId, userId: "__defaultOwner__") { (canPostComment) in
            guard canPostComment else { return success(false) }
            guard title != "", content != "" else { return success(false) }
            guard isICloudAvailable else { return success(false) }
            let commentRecord = CKRecord(recordType: "Comments")
            let reference = CKRecord.Reference(recordID: CKRecord.ID(recordName: spotId), action: .none)
            commentRecord["title"] = title as CKRecordValue
            commentRecord["detail"] = content as CKRecordValue
            commentRecord["spot"] = reference
            commentRecord["pseudo"] = pseudo
            publicDB.save(commentRecord) { (record, error) in
                guard error == nil else { return success(false) }
                success(true)
            }
        }
    }
    
    static func updateComment(commentId: String, title: String, comment: String, pseudo: String, success: @escaping (Bool) -> Void) {
        let recordId = CKRecord.ID(recordName: commentId)
        publicDB.fetch(withRecordID: recordId) { (record, error) in
            guard let record = record else { return success(false) }
            record["title"] = title
            record["detail"] = comment
            record["pseudo"] = pseudo
            
            self.publicDB.save(record) { ( _, error) in
                guard error == nil else { return success(false) }
                success(true)
            }
        }
    }
    
}

// MARK: - Private Static methods

private extension Comment {
    static func canPostComment(spotId :String, userId: String, success: @escaping (Bool) -> Void) {
        Comment.getComments(ckDatabase: publicDB, spotId: spotId) { (result) in
            switch result {
            case .success(let comments):
                guard comments.count > 0 else { return success(true) }
                for comment in comments {
                    if comment.authorID == userId {
                        success(true)
                        break
                    }
                }
                success(false)
            case .failure( _):
                success(false)
            }
        }
    }
    
}

// MARK: - Nested Struct

extension Comment {
    /// A structure that represents the comments
    struct Item: Identifiable {
        let id: String
        var title: String
        var detail: String
        let authorID: String
        var authorPseudo: String
        let creationDate: Date
        var creationDateString: String {
            let dateFormater = DateFormatter()
            dateFormater.dateStyle = .medium
            return dateFormater.string(from: creationDate)
        }
    }
    
}
