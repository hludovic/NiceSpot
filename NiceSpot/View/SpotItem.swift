//
//  viewPointItem.swift
//  Guadeloupe
//
//  Created by Ludovic HENRY on 08/11/2020.
//

import SwiftUI

struct SpotItem: View {
    var spot: Spot
    
    var body: some View {        
        VStack(alignment: .leading, spacing: 10.0) {
            Image(spot.pictureName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .padding(.bottom, 130.0)
                .frame(width: 300.0, height: 170.0)
                .clipped()
                .cornerRadius(10.0)
                .shadow(radius: 10)

            VStack(alignment: .leading, spacing: 5.0) {
                Text(spot.title)
                    .font(.headline)
                    .foregroundColor(Color.primary)
                Text(spot.detail)
                    .foregroundColor(Color.secondary)
                    .lineLimit(2)
            }
        }
        
    }
}

//struct viewPointItem_Previews: PreviewProvider {
//    static var previews: some View {
//        let
//        SpotItem(spot: <#T##Spot#>)
//    }
//}
