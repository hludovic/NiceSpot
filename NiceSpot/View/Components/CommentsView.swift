//
//  CommentsView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 31/01/2021.
//

import SwiftUI

struct CommentsView: View {
    @State var comments: [Comment.Item]
    
    var body: some View {
        VStack {
            Divider()
            HStack {
                Text("Comments")
                Spacer()
            }
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    ForEach(comments) { (comment: Comment.Item) in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(comment.title)
                                    .font(.subheadline)
                                Spacer()
                            }
                            Text(comment.detail)
                                .font(.footnote)
                                .lineLimit(3)
                            Spacer()
                        }
                        .padding(.top)
                        .frame(width: 240, height: 110)
                    }
                    .padding(.horizontal)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(14.0)
                }
                .padding([.horizontal, .bottom], 10)
            }
        }
    }
}


struct CommentSheet: View {
    @State var title = ""
    @State var detail = ""
    @State var pseudo = ""
    @State private var isLoading = false
    var spotId: String
    @Binding var showCommentSheetView: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Comment")) {
                    TextField("Pseudonym", text: $pseudo)
                    TextField("Title", text: $title)
                    TextEditor(text: $detail)
                        .frame(height: 100.0)
                }
            }
            .navigationTitle("Write a comment")
            .navigationBarItems(
                leading: Button(action: { self.showCommentSheetView = false }) {
                    Text("Cancel")
                },
                trailing: Button(action: {
                    self.isLoading = true
                    Comment.postComment(spotId: spotId, title: title, content: detail) { (success) in
                        if success {
                            self.isLoading = false
                            print("ok")
                        } else {
                            self.isLoading = false
                            showCommentSheetView = false
                        }
                    }
                }) {
                    Text("Save")
                }
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        let commentItem = Comment.Item(
            id: "",
            title: "C'était super",
            detail: "J'ai beaucoup aimé, blabla géniale",
            authorID: ""
        )
        CommentsView(comments: [commentItem, commentItem, commentItem])
            .previewLayout(.fixed(width: 450, height: 200))
    }
}
