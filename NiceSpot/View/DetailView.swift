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
            NavigationLink(destination: content.image) {
                content.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            HStack {
                Image("\(content.spot.category)")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .clipShape(Capsule())
                Text(content.spot.category)
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(5)
                    .background(Color.green)
                    .clipShape(Capsule())
                    .foregroundColor(.white)
                Text(content.spot.municipality)
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(5)
                    .background(Color.orange)
                    .clipShape(Capsule())
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal)
            Divider()
            Text(content.spot.detail)
                .font(.body)
                .foregroundColor(Color.gray)
                .padding()
            Group {
                HStack {
                    Text("Location")
                    Spacer()
                    Link("Open in Maps", destination: content.spot.mapLink)
                }
                MapView(content: content)
                    .frame(height: 300)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 10)
            VStack {
                HStack {
                    Text("Comments")
                    Spacer()
                    if Comment.isICloudAvailable {
                        CommentButton(content: content)
                    }
                }
                .padding(.horizontal)
                if content.comments.count != 0 {
                    CommentsView(comments: content.comments)
                }

            }
            Spacer()
        }
        .onAppear{
            content.loadImage()
            content.loadComments()
        }
        .navigationTitle(content.spot.title)
    }
}

struct CommentButton: View {
    @ObservedObject var content: DetailContent
    
    var  body: some View {
        if content.canComment {
            Button(action: {
                content.showCommentSheet.toggle()
            }, label: {
                HStack {
                    Image(systemName: "square.and.pencil")
                    Text("Write a comment")
                }
                .sheet(isPresented: $content.showCommentSheet) {
                    PostCommentView(content: content)
                }
            })
        } else {
            Button(action: {
            }, label: {
                HStack {
                    Image(systemName: "square.and.pencil")
                    Text("Edit your comment")
                }
            })
        }
    }
}

struct SpotDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(content: DetailContent(spot: Preview.spot))
    }
}
