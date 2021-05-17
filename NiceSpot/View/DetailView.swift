//
//  DetailView.swift
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
            MapView(content: content)
                .padding(.bottom, 20)
                .frame(height: 300)
                .padding(.horizontal)
            if PersistenceController.isICloudAvailable {
                if content.comments.count != 0 {
                    CommentsView(content: content)
                }
                CommentButton(content: content)
            }
            Spacer(minLength: 50)
        }
        .onAppear {
            content.loadImage { _ in }
            content.refreshComments()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(content.spot.category)
        .navigationBarItems(trailing: ShareButton(content: content))
    }
}

struct SpotDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(content: DetailContent(spot: Preview.spot))
            .environment(\.managedObjectContext, Preview.context)
    }
}
