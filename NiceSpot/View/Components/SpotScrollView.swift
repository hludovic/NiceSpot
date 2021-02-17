//
//  SpotListView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 09/02/2021.
//

import SwiftUI

struct SpotScrollView: View {
    let category: String
    let spots: [Spot]
    
    var body: some View {
        VStack {
            HStack {
                Text(category)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                NavigationLink(
                    destination: SeeAllByCategoryView(category: category, spots: spots),
                    label: {
                        Text("See All")
                            .font(.callout)
                    }
                )
            }
            .offset(y: 12)
            .padding(.top, -12)
            .padding(.horizontal, 8)
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
        .background(LinearGradient(gradient: Gradient(colors: [.clear, Color.primary.opacity(0.07)]), startPoint: .top, endPoint: .bottom))
    }
}

struct SpotListView_Previews: PreviewProvider {
    static var previews: some View {
        SpotScrollView(
            category: Spot.Category.mountain.rawValue,
            spots: [Preview.spot, Preview.spot, Preview.spot]
        )
    }
}
