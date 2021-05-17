//
//  CustomButtons.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 16/02/2021.
//

import SwiftUI

// MARK: - Favorite Button

struct FavoriteButton: View {
    @ObservedObject var content: DetailContent
    @Environment(\.managedObjectContext) private var viewContext

    var  body: some View {
        Button(action: {
            content.pressFavoriteButton(context: viewContext)
        }, label: {
            content.favoriteButtonIcon
                .foregroundColor(.red)
        })
        .onAppear {
            content.refreshFavoriteButtonStatus(context: viewContext)
        }
    }
}

// MARK: - Share Button

struct ShareButton: View {
    @ObservedObject var content: DetailContent
    @State private var showingSheet = false

    var body: some View {
        Button(action: {
            showingSheet = true
        }, label: {
            Image(systemName: "square.and.arrow.up")
        })
        .actionSheet(isPresented: $showingSheet) {
            ActionSheet(
                title: Text("Do you want to consult the location on Maps ?"),
                message: nil,
                buttons: [
                    .default(Text("Get Directions"), action: {
                        content.openInMap()
                    }),
                    .cancel()
                ]
            )
        }
    }
}

// MARK: - Comment Button

struct CommentButton: View {
    @ObservedObject var content: DetailContent

    var  body: some View {
        if content.canComment {
            Button(action: {
                content.displayCommentSheet.toggle()
            }, label: {
                HStack {
                    Image(systemName: "square.and.pencil")
                    Text("Write a comment")
                }
                .sheet(isPresented: $content.displayCommentSheet) {
                    PostCommentView(content: content, pageTitle: "Write a comment")
                }
            })
        } else {
            Button(action: {
                content.loadUserComment { _ in }
            }, label: {
                HStack {
                    Image(systemName: "square.and.pencil")
                    Text("Edit your comment")
                }
                .sheet(isPresented: $content.displayCommentSheet) {
                    PostCommentView(content: content, pageTitle: "Edit your comment")
                }
            })
        }
    }
}

struct CustomButtons_Previews: PreviewProvider {
    static var previews: some View {
        let content = DetailContent(spot: Preview.spot)
        FavoriteButton(content: content)
            .environment(\.managedObjectContext, Preview.context)
            .previewLayout(.fixed(width: 100, height: 100))
            .previewDisplayName("Favorite Button")
        ShareButton(content: content)
            .previewLayout(.fixed(width: 100, height: 100))
            .previewDisplayName("Share Button")
        CommentButton(content: content)
            .previewLayout(.fixed(width: 300, height: 100))
            .previewDisplayName("Comment Button")
    }
}
