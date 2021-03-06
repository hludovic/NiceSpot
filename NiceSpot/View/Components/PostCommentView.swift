//
//  PostCommentView.swift
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
            .navigationBarItems(leading: CancelButton(content: content),
                                trailing: SaveButton(content: content)
            )
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $content.showAlert) {
                Alert(title: Text("Error"), message: Text(content.errorMessage), dismissButton: .default(Text("Ok")))
            }
        }
    }
}

private struct CancelButton: View {
    @ObservedObject var content: DetailContent
    var  body: some View {
        Button(action: {
            content.displayCommentSheet = false
        }, label: {
            Text("Cancel")
        })
    }
}

private struct SaveButton: View {
    @ObservedObject var content: DetailContent
    var  body: some View {
        Button(action: {
            if content.canComment {
                content.saveUserComment { _ in }
            } else {
                content.updateUserComment { _ in }
            }
        }, label: {
            Text("Save")
        }).disabled(content.isSaveButtonDisabled)
    }
}

struct CommentSheet_Previews: PreviewProvider {
    static var previews: some View {
        PostCommentView(content: Preview.detailContent, pageTitle: "Write a comment")
    }
}
