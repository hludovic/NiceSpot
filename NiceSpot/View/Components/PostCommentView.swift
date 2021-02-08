//
//  CommentSheet.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 01/02/2021.
//

import SwiftUI

struct PostCommentView: View {
    @ObservedObject var content: DetailContent
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Comment")) {
                    TextField("Pseudo", text: $content.userComment.authorPseudo)
                    TextField("Title", text: $content.userComment.title)
                    TextEditor(text: $content.userComment.detail)
                        .frame(height: 100.0)
                }
            }
            .navigationTitle("Write a comment")
            .navigationBarItems(
                leading: Button(action: { content.showCommentSheet = false }) {
                    Text("Cancel")
                },
                trailing: Button(action: {
                    content.saveButtonDisabled = false
                    content.saveComment()
                    content.comments.append(
                        Comment.Item(
                            id: "ID",
                            title: content.userComment.title,
                            detail: content.userComment.detail,
                            authorID: "__defaultOwner__",
                            authorPseudo: content.userComment.authorPseudo,
                            creationDate: Date()
                        )
                    )
                }) {
                    Text("Save")
                }
                .disabled(content.saveButtonDisabled)
            )
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $content.showAlert) {
                Alert(title: Text("Error"), message: Text(content.errorMessage), dismissButton: .default(Text("Ok")))
            }
        }
    }
}

struct CommentSheet_Previews: PreviewProvider {
    static var previews: some View {
        let spotDetailContent = DetailContent(spot: Preview.spot)
        PostCommentView(content: spotDetailContent)
    }
}
