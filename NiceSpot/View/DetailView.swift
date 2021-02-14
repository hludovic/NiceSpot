//
//  SpotDetailView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 19/01/2021.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var content: DetailContent
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            content.image
                .resizable()
                .aspectRatio(contentMode: .fit)
            HStack {
                Image("\(content.spot.category)")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .clipShape(Capsule())
                Text(content.spot.title)
                Spacer()
                Text(content.spot.municipality)
                    .font(.caption)
                FavoriteButton(content: content)
            }
            .padding(.horizontal)
            .foregroundColor(.white)
            .background(Color.black.opacity(0.5))
            .offset(y: -32.0)
            .padding(.bottom, -32)
            Text(content.spot.detail)
                .font(.body)
                .foregroundColor(Color.gray)
                .padding([.leading, .bottom, .trailing])
            Group {
                HStack {
                    Text("Location")
                        .fontWeight(.medium)
                    Spacer()
                    Link("Open in Maps", destination: content.spot.mapLink)
                }
                .font(.subheadline)
                .offset(y: -5)
                .padding(.bottom, -5)
                MapView(content: content)
                    .padding(.bottom, 20)
                    .frame(height: 300)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            VStack {
                HStack {
                    Text("Comments")
                        .fontWeight(.medium)
                    Spacer()
                    if PersistenceController.isICloudAvailable {
                        CommentButton(content: content)
                    }
                }
                .offset(y: -5)
                .padding(.bottom, -5)
                .font(.subheadline)
                .padding(.horizontal)
                if content.comments.count != 0 {
                    CommentsView(content: content)
                }
            }
            Spacer(minLength: 50)
        }
        .onAppear{
            content.loadImage()
            content.refreshComments()
        }
        .navigationTitle(content.spot.category)
    }
}

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
        .onAppear{
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

struct SpotDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(content: DetailContent(spot: Preview.spot))
            .environment(\.managedObjectContext, Preview.context)
    }
}
