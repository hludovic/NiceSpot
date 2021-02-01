//
//  CommentSheet.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 01/02/2021.
//

import SwiftUI

struct CommentSheet: View {
    @ObservedObject var content: CommentContent
    @Binding var showCommentSheetView: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Comment")) {
                    TextField("Pseudonym", text: $content.pseudonym)
                    TextField("Title", text: $content.title)
                    TextEditor(text: $content.detail)
                        .frame(height: 100.0)
                }
            }
            .navigationTitle("Write a comment")
            .navigationBarItems(
                leading: Button(action: { showCommentSheetView = false }) {
                    Text("Cancel")
                },
                trailing: Button(action: { content.saveComment() }) {
                    Text("Save")
                }
                .disabled(content.isLoading)
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CommentSheet_Previews: PreviewProvider {
    static var previews: some View {
        let content = CommentContent(spotId: "")
        CommentSheet(content: content, showCommentSheetView: .constant(false))
    }
}
