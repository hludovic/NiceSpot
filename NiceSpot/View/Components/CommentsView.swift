//
//  CommentsView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 31/01/2021.
//

import SwiftUI

struct CommentsView: View {
    @ObservedObject var content: DetailContent

    var body: some View {
        VStack {
            Text("Comments")
                .font(.title3)
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    ForEach(content.comments) { (comment: Comment.Item) in
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
        CommentsView(content: Preview.detailContent)
            .previewLayout(.fixed(width: 450, height: 200))
    }
}
