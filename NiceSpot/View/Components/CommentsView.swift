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
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    ForEach(comments) { (comment: Comment.Item) in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(comment.title)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            HStack {
                                Text(comment.creationDateString)
                                    .font(.caption)
                                Spacer()
                                Text(comment.authorPseudo)
                                    .font(.caption)
                            }
                            Spacer()
                            Text(comment.detail)
                                .font(.footnote)
                                .lineLimit(3)
                            Spacer()
                        }
                        .padding(.top)
                        .frame(width: 250, height: 120)
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
            detail: "J'ai beaucoup aimé. Bravo super cool",
            authorID: "", authorPseudo: "Moi",
            creationDate: Date()
        )
        CommentsView(comments: [commentItem, commentItem, commentItem])
            .previewLayout(.fixed(width: 450, height: 200))
    }
}
