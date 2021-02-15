//
//  FavoriteView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 09/02/2021.
//

import SwiftUI

struct FavoriteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var spotsFavorite: [Spot] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(spotsFavorite, id: \.self) { spotFavorite in
                    NavigationLink(
                        destination:
                            DetailView(content: DetailContent(spot: spotFavorite)),
                        label: {
                            SpotItemView(content: SpotCellContent(spot: spotFavorite))
                        }
                    )
                }
            }
            .onAppear {
                Favorite.getFavoriteSpots(context: viewContext) { (spots) in
                    spotsFavorite = spots
                }
            }
            .navigationTitle("Favorite spots")
        }
    }
    
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
            .environment(\.managedObjectContext, Preview.context)
    }
}
