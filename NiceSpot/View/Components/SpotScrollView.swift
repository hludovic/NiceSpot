//
//  SpotListView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 09/02/2021.
//

import SwiftUI

struct SpotScrollView: View {
    let cathegory: String
    let spots: [Spot]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(cathegory)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Text("See All")
            }
            .padding(.horizontal)
            .offset(y: 10.0)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(spots) { (result: Spot) in
                        NavigationLink(destination: DetailView(content: DetailContent(spot: result))) {
                            SpotCellView(spot: result)
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
        }
        .padding(.bottom)
        .listRowInsets(EdgeInsets())
    }
}

struct SpotListView_Previews: PreviewProvider {
    static var previews: some View {
        SpotScrollView(
            cathegory: Spot.Category.mountain.rawValue,
            spots: [Preview.spot, Preview.spot, Preview.spot]
        )
    }
}
