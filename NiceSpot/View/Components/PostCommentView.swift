//
//  CommentSheet.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 01/02/2021.
//

import SwiftUI

struct PostCommentView: View {
    @ObservedObject var content: DetailContent
    let pageTitle: String
    
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
            .navigationTitle(pageTitle)
            .navigationBarItems(
                leading: Button(action: { content.displayCommentSheet = false }) {
                    Text("Cancel")
                },
                trailing: Button(action: {
                    if content.canComment {
                        content.saveUserComment()
                    } else {
                        content.updateUserComment()
                    }
                }) {
                    Text("Save")
                }
                .disabled(content.isSaveButtonDisabled)
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
        PostCommentView(content: Preview.detailContent, pageTitle: "Write a comment")
    }
}
