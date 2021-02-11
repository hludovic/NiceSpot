//
//  SpotDetailContent.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 19/01/2021.
//

import Foundation
import SwiftUI
import MapKit
import CoreData

class DetailContent: ObservableObject {
    // MARK: - Public Property
    
    let spot: Item
    @Published var mapRegion : MKCoordinateRegion
    @Published var comments: [Comment.Item] = []
    @Published var showAlert: Bool = false
    @Published var userComment : Comment.Item {
        didSet { refreshSaveButtonStatus() }
    }
    @Published private(set) var isSaveButtonDisabled = true
    @Published private(set) var canComment: Bool = false
    @Published private(set) var image: Image = Image("placeholder")
    @Published private(set) var errorMessage: String = "" {
        didSet { showAlert = true }
    }
    @Published var displayCommentSheet: Bool = false {
        didSet { if displayCommentSheet && canComment { clearUserLoadedComment() } }
    }
//    @Published var isFavorite: Bool = false
    
    // MARK: - Private Property
    
    private let imageManager = ImageManager()
    private var isLoading: Bool = false {
        didSet { refreshSaveButtonStatus() }
    }
    
    init(spot: Spot) {
        let coodinate = CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude)
        let item = Item(id: spot.id!,
                        title: spot.title!,
                        detail: spot.detail!,
                        imageName: spot.imageName!,
                        municipality: spot.municipality!,
                        category: spot.category!,
                        location: Location(coordinate: coodinate),
                        mapLink: URL(string: "maps://?ll=\(spot.latitude),\(spot.longitude)")!
        )
        
        self.mapRegion = MKCoordinateRegion(
            center: coodinate,
            span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        )
        self.spot = item
        self.userComment = Comment.Item(id: "", title: "", detail: "", authorID: "", authorPseudo: "", creationDate: Date())
    }
    
    // MARK: - Public Methods
    
    func refreshComments() {
        Comment.getComments(ckDatabase: Comment.publicDB, spotId: spot.id) { [unowned self] (result) in
            switch result {
            case .failure(_ ):
                DispatchQueue.main.async { errorMessage = "ERROR LOADING COMMENTS" }
            case .success(let comments):
                DispatchQueue.main.async {
                    self.comments = comments
                    self.refreshCanCommentStatus(comments: comments)
                }
            }
        }
    }
    
    func loadUserComment() {
        Comment.getComments(ckDatabase: Comment.publicDB, spotId: spot.id) { [unowned self] (result) in
            switch result {
            case .failure(_ ):
                DispatchQueue.main.async { errorMessage = "ERROR LOADING COMMENT" }
            case .success(let comments):
                for comment in comments {
                    if comment.authorID == "__defaultOwner__" {
                        DispatchQueue.main.async {
                            self.userComment = comment
                            self.displayCommentSheet.toggle()
                        }
                        break
                    } else {
                        DispatchQueue.main.async { errorMessage = "ERROR LOADING COMMENT" }
                    }
                }
            }
        }
    }
    
    func updateUserComment() {
        isLoading = true
        guard
            userComment.title != "",
            userComment.authorPseudo != "",
            userComment.detail != ""
        else {
            self.isLoading = false
            errorMessage = "ERROR ..."
            return
        }
        Comment.updateComment(commentId: userComment.id, title: userComment.title, comment: userComment.detail, pseudo: userComment.authorPseudo) { [unowned self] (success) in
            guard success else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "ERROR EDDITING"
                }
                return
            }
            DispatchQueue.main.async {
                self.isLoading = false
                self.displayCommentSheet = false
                self.canComment = false
                self.isSaveButtonDisabled = false
                refreshComments()
            }
        }
    }
    
    func saveUserComment() {
        isLoading = true
        guard
            userComment.title != "",
            userComment.authorPseudo != "",
            userComment.detail != ""
        else {
            self.isLoading = false
            errorMessage = "ERROR ..."
            return
        }
        Comment.postComment(spotId: spot.id, title: userComment.title, content: userComment.detail, pseudo: userComment.authorPseudo) { [unowned self] (success) in
            guard success else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "ERROR SAVING"
                }
                return
            }
            DispatchQueue.main.async {
                self.isLoading = false
                self.displayCommentSheet = false
                self.canComment = false
                self.isSaveButtonDisabled = false
                refreshComments()

            }
        }
    }
    
    func loadImage() {
        imageManager.getUIImage(imageName: spot.imageName) { [unowned self] (uiImage) in
            guard let uiImage = uiImage else { return }
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
            }
        }
    }
    
    func pressFavoriteButton(context: NSManagedObjectContext, completion: @escaping (_ iconName: String?) -> Void) {
        Favorite.isFavorite(context: context, spotId: spot.id) { (isFavorite) in
            if isFavorite {
                Favorite.remove(context: context, spotId: self.spot.id) { (success) in
                    guard success else { return completion(nil) }
                    completion("bookmark")
                }
            } else {
                Favorite.saveSpotId(context: context, spotId: self.spot.id) { (success) in
                    guard success else { return completion(nil) }
                    completion("bookmark.fill")
                }
            }
        }
    }
    
}

// MARK: - Private Methods
private extension DetailContent {
    func refreshCanCommentStatus(comments: [Comment.Item]) {
        guard comments.count > 0 else { return canComment = true }
        for comment in comments {
            if comment.authorID == "__defaultOwner__" {
                canComment = false
            } else {
                canComment = true
            }
        }
    }
    
    func clearUserLoadedComment() {
        userComment.title = ""
        userComment.authorPseudo = ""
        userComment.detail = ""
    }
    
    func refreshSaveButtonStatus() {
        let isNotFill = (userComment.title == "" || userComment.authorPseudo == "") || (userComment.detail == "")
        isSaveButtonDisabled = isNotFill || isLoading
    }
    
}

// MARK: - Nested Struct
extension DetailContent {
    struct Item {
        let id: String
        let title: String
        let detail: String
        let imageName: String
        let municipality: String
        let category: String
        let location: Location
        let mapLink: URL
    }
    
    /// A structure representing a location that can be used as annotationItems in a Map.
    struct Location: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
    
}
