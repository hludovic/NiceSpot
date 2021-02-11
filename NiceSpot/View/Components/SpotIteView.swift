//
//  SpotIteView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 09/02/2021.
//

import SwiftUI

struct mView: View {
    @ObservedObject var content : SpotCellContent
    
    var body: some View {
        HStack {
            content.image
                .resizable()
                .frame(width: 50.0, height: 50.0)
                .cornerRadius(5.0)
            VStack {
                HStack {
                    Text(content.title)
                        .font(.title3)
                    Spacer()
                }
                HStack {
                    Text(content.category)
                    Text(content.municipality)
                    Spacer()
                }
                .font(.subheadline)
            }
        }
        .redacted(reason: content.isRedacted ? .placeholder: .init())
    }
}

struct SpotIteView_Previews: PreviewProvider {
    static var previews: some View {
        mView(content: SpotCellContent(spot: Preview.spot))
            .previewLayout(.fixed(width: 450, height: 100))
            .previewDisplayName("SpotCell")
    }
}
