//
//  viewPointItem.swift
//  Guadeloupe
//
//  Created by Ludovic HENRY on 08/11/2020.
//

import SwiftUI

struct SpotView: View {
//    var spot: Spot
    @ObservedObject var newContent: SpotContent

    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            newContent.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300.0, height: 170.0)
                .clipped()
                .cornerRadius(10.0)
                .shadow(radius: 10)

            VStack(alignment: .leading, spacing: 5.0) {
                Text(newContent.title)
                    .font(.headline)
                    .foregroundColor(Color.primary)
                Text(newContent.detail)
                    .foregroundColor(Color.secondary)
                    .lineLimit(2)
            }
        }
    }
}

struct viewPointItem_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let homeContent = HomeContent(context: context)
        
        let spotContent = SpotContent(spot: homeContent.allSpots().first!)
        SpotView(newContent: spotContent)
//        SpotView(content: homeContent.allSpots().first!, newContent: <#T##SpotContent#>)
////            .environmentObject(SpotContent(spot: homeContent.allSpots().first!))
    }
}
