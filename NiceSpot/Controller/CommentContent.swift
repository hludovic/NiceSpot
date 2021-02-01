//
//  CommentContent.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 01/02/2021.
//

import Foundation

class CommentContent: ObservableObject {
    var spotId: String
    @Published var title: String = ""
    @Published var detail: String = ""
    @Published var pseudonym: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var dismiss: Bool = false

    init(spotId: String) {
        self.spotId = spotId
    }

    init(spotId: String, title: String, detail: String, pseudo: String) {
        self.spotId = spotId
        self.title = title
        self.detail = detail
        self.pseudonym = pseudo
    }

    func saveComment() {
        guard title != "", detail != "", pseudonym != "" else { return errorMessage = " " }
        isLoading = true
        Comment.postComment(spotId: spotId, title: title, content: detail, pseudo: pseudonym) { [unowned self] (success) in
            guard success else {
                self.isLoading = false
                self.errorMessage = " "
                return
            }
            DispatchQueue.main.async {
                self.isLoading = false
                self.dismiss = true
            }
        }
    }
}
