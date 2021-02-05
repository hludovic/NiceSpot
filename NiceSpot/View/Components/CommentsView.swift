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

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        let commentItem = Comment.Item(
            id: "",
            title: "C'était super",
            detail: "J'ai beaucoup aimé, blabla géniale",
            authorID: "", authorPseudo: "Moi"
        )
        CommentsView(comments: [commentItem, commentItem, commentItem])
            .previewLayout(.fixed(width: 450, height: 200))
    }
}
