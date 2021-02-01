//
//  SpotDetailContent.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 19/01/2021.
//

import Foundation
import CoreLocation
import SwiftUI

class DetailContent: ObservableObject {
    let spot: Item
    @Published var userComment: UserComment? = nil
    @Published var canComment: Bool = false
    @Published var image: Image = Image("placeholder")
    @Published var comments: [Comment.Item] = []
    @Published var errorMessage: String = ""
    @Published var isSaving: Bool = false

    init(spot: Spot) {
        let coodinate = CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude)
        let item = Item(id: spot.id!,
                        title: spot.title!,
                        detail: spot.detail!,
                        imageName: spot.imageName!,
                        municipality: spot.municipality!,
                        category: spot.category!,
                        location: SpotLocation(coordinate: coodinate),
                        mapLink: URL(string: "maps://?ll=\(spot.latitude),\(spot.longitude)")!
        )
        self.spot = item
    }

    func canComment(comments: [Comment.Item]) {
        guard comments.count > 0 else {
            return DispatchQueue.main.async { self.canComment = true }
        }
        for comment in comments {
            if comment.authorID == "__defaultOwner__" {
                return DispatchQueue.main.async { self.canComment = false }
            }
        }
        return DispatchQueue.main.async { self.canComment = true }
    }

    func loadComments() {
        Comment.getComments(ckDatabase: Comment.publicDB, spotId: spot.id) { (result) in
            switch result {
            case .failure(let error):
                print(" ERROR LOADING COMMENTS \(error.localizedDescription)")
            case .success(let comments):
                DispatchQueue.main.async { self.comments = comments }
                print(comments.count)
                self.canComment(comments: comments)
            }
        }
    }

//    func saveComment() {
//        guard let comment = userComment else { return errorMessage = " " }
//        isSaving = true
//        Comment.postComment(spotId: spot.id, title: comment.title, content: comment.detail, pseudo: comment.pseudo) { [unowned self] (success) in
//            guard success else {
//                self.isSaving = false
//                self.errorMessage = " "
//                return
//            }
//            DispatchQueue.main.async {
//                self.isSaving = false
//            }
//        }
//    }

    func loadImage() {
        if let imageCached = NiceSpotApp.imageCache.object(forKey: NSString(string: spot.imageName)) {
            image = Image(uiImage: imageCached)
        }
    }
}

extension DetailContent {
    struct Item {
        let id: String
        let title: String
        let detail: String
        let imageName: String
        let municipality: String
        let category: String
        let location: SpotLocation
        let mapLink: URL
    }
    
    struct UserComment {
        var title: String
        var detail: String
        var pseudo: String
    }
}
