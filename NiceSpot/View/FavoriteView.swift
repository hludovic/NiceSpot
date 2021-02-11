//
//  FavoriteView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 09/02/2021.
//

import SwiftUI

struct FavoriteView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State var favorites: [Favorite] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favorites, id: \.self) { favorite in
                    Text(favorite.spotId!)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Saved Spots").font(.headline)
                    }
                }
            }
        }
        .onAppear {
            Favorite.getFavorites(context: viewContext) { (favorites) in
                self.favorites = favorites
            }
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
            .environment(\.managedObjectContext, Preview.context)
    }
}
