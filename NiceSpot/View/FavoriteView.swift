//
//  FavoriteView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 09/02/2021.
//

import SwiftUI

struct FavoriteView: View {
    @State var spots: [Spot]
    
    var body: some View {
        NavigationView {
            List {
                SpotItemView(content: SpotCellContent(spot: Preview.spot))
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
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        let spots = [Preview.spot, Preview.spot, Preview.spot]
        FavoriteView(spots: spots)
    }
}
