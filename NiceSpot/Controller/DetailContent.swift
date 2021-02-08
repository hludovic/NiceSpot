//
//  SpotDetailContent.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 19/01/2021.
//

import Foundation
import CoreLocation
import SwiftUI
import MapKit

class DetailContent: ObservableObject {
    var spot: Item
    @Published var userComment = Comment.Item(id: "", title: "", detail: "", authorID: "", authorPseudo: "", creationDate: Date()) {
        didSet { refreshSaveButton() }
    }
    private var isLoading: Bool = false {
        didSet { refreshSaveButton() }
    }
    private let imageManager = ImageManager()
    @Published var comments: [Comment.Item] = []
    @Published var showAlert: Bool = false
    @Published var saveButtonDisabled = true
    @Published var showCommentSheet: Bool = false
    @Published private(set) var canComment: Bool = false
    @Published private(set) var errorMessage: String = "" {
        didSet { showAlert = true }
    }
    @Published private(set) var image: Image = Image("placeholder")
    
    init(spot: Spot) {
        let coodinate = CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude)
        let item = Item(id: spot.id!,
                        title: spot.title!,
                        detail: spot.detail!,
                        imageName: spot.imageName!,
                        municipality: spot.municipality!,
                        category: spot.category!,
                        location: Location(coordinate: coodinate),
                        mapLink: URL(string: "maps://?ll=\(spot.latitude),\(spot.longitude)")!,
                        mapRegion: MKCoordinateRegion(
                            center: coodinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
                        )
        )
        self.spot = item
    }
    
    private func canComment(comments: [Comment.Item]) {
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
    
    private func refreshSaveButton() {
        let isNotFill = (userComment.title == "" || userComment.authorPseudo == "") || (userComment.detail == "")
        saveButtonDisabled = isNotFill || isLoading
    }
    
    func loadComments() {
        Comment.getComments(ckDatabase: Comment.publicDB, spotId: spot.id) { [unowned self] (result) in
            switch result {
            case .failure(let error):
                print("ERROR LOADING COMMENTS \(error.localizedDescription)")
            case .success(let comments):
                DispatchQueue.main.async {
                    self.comments = comments
                    self.canComment(comments: comments)
                }
            }
        }
    }
    
    func loadSelfComment(success: @escaping (Bool) -> Void) {
        Comment.getComments(ckDatabase: Comment.publicDB, spotId: spot.id) { [unowned self] (result) in
            switch result {
            case .failure(let error):
                print("ERROR LOADING COMMENT \(error.localizedDescription)")
            case .success(let comments):
                for comment in comments {
                    if comment.authorID == "__defaultOwner__" {
                        DispatchQueue.main.async {
                            self.userComment = comment
                            success(true)
                        }
                        break
                    }
                }
                success(false)
            }
        }
    }
    
    func updateComment() {
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
                self.showCommentSheet = false
                self.canComment = false
                self.saveButtonDisabled = false
                clearUserComment()
            }
            loadComments()
        }
    }
    
    func saveComment() {
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
                self.showCommentSheet = false
                self.canComment = false
                self.saveButtonDisabled = false
                self.comments.append( Comment.Item(
                    id: "ID",
                    title: userComment.title,
                    detail: userComment.detail,
                    authorID: "__defaultOwner__",
                    authorPseudo: userComment.authorPseudo,
                    creationDate: Date())
                )
                clearUserComment()
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
    
    private func clearUserComment() {
        userComment.title = ""
        userComment.authorPseudo = ""
        userComment.detail = ""
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
        var mapRegion : MKCoordinateRegion
    }
    
    /// A structure representing a location that can be used as annotationItems in a Map.
    struct Location: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
    
}
