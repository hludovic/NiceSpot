//
//  SpotDetailView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 19/01/2021.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @ObservedObject var content: DetailContent
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            NavigationLink(destination: content.image) {
                content.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            HStack {
                Image("\(content.category)")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .clipShape(Capsule())
                Text(content.category)
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(5)
                    .background(Color.green)
                    .clipShape(Capsule())
                    .foregroundColor(.white)
                Text(content.municipality)
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
            Text(content.detail)
                .font(.body)
                .foregroundColor(Color.gray)
                .padding()
            NavigationLink(
                destination:
                    VStack {
                        MapView(spotLocation: content.location)
                        Link("Open in Maps", destination: content.mapLink)
                    }
                    .navigationTitle(content.title)
                ,
                label: {
                    MapView(spotLocation: content.location)
                        .frame(height: 300)
                        .cornerRadius(10)
                })
                .padding(.horizontal, 10)
            if content.comments.count != 0 {
                CommentsView(comments: content.comments)
            }
            if content.canComment == true {
                AddCommentButton()
            } else {
                EditCommentButton()
            }
        }
        .onAppear{
            content.loadImage()
            content.loadComments()
        }
        .navigationTitle(content.title)
    }
}

struct EditCommentButton: View {
    var body: some View {
        Button(action: {
            print("AA")
        }, label: {
            HStack {
                Image(systemName: "square.and.pencil")
                Text("Edit your comment")
            }
        })
    }
}

struct AddCommentButton: View {
    var body: some View {
        Button(action: {
            print("BB")
        }, label: {
            HStack {
                Image(systemName: "square.and.pencil")
                Text("Write a comment")
            }
        })
    }
}

struct SpotDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let request: NSFetchRequest<Spot> = Spot.fetchRequest()
        let result = try! context.fetch(request)
        let spotDetailContent = DetailContent(spot: result.first!)
        DetailView(content: spotDetailContent)
    }
}
