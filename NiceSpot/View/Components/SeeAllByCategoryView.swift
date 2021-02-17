//
//  SeeAllByCategoryView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 16/02/2021.
//

import SwiftUI

struct SeeAllByCategoryView: View {
    let category: String
    @State var spots: [Spot] = []
    
    var body: some View {
        List {
            ForEach(spots) { spot in
                NavigationLink(
                    destination: DetailView(content: DetailContent(spot: spot)),
                    label: {
                        SpotItemView(content: SpotCellContent(spot: spot))
                    }
                )
            }
        }
        .navigationTitle(Text("\(category)s"))
    }
}

struct SeeAllByCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        let spots = Preview.spots
        SeeAllByCategoryView(category: Spot.Category.beach.rawValue, spots: spots)
    }
}
