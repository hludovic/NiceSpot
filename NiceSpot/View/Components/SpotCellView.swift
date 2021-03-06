//
//  SpotCellView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 08/11/2020.
//

import SwiftUI
import CoreData

struct SpotCellView: View {
    @ObservedObject var content: SpotCellContent
    @Environment(\.managedObjectContext) private var viewContext

    init(spot: Spot) {
        self.content = SpotCellContent(spot: spot)
    }

    var body: some View {
        VStack(alignment: .center, spacing: 10.0) {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                content.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 250.0, height: 150.0)
                    .clipped()
                Text(content.title)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    .foregroundColor(.white)
                    .frame(width: 250.0)
                    .background(Color.black.opacity(0.5))
                    .font(.footnote)
            }
            .cornerRadius(10.0)
        }
        .redacted(reason: content.isRedacted ? .placeholder: .init())
    }
}

struct SpotCellView_Previews: PreviewProvider {
    static var previews: some View {
        SpotCellView(spot: Preview.spot)
    }
}
