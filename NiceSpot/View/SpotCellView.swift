//
//  viewPointItem.swift
//  Guadeloupe
//
//  Created by Ludovic HENRY on 08/11/2020.
//

import SwiftUI
import CoreData

struct SpotCellView: View {
    @ObservedObject var content: SpotCellContent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            content.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300.0, height: 170.0)
                .clipped()
                .cornerRadius(10.0)
                .shadow(radius: 10)

            VStack(alignment: .leading, spacing: 5.0) {
                Text(content.title)
                    .font(.headline)
                    .foregroundColor(Color.primary)
                Text(content.detail)
                    .foregroundColor(Color.secondary)
                    .lineLimit(2)
            }
        }
    }
}

struct viewPointItem_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let request: NSFetchRequest<Spot> = Spot.fetchRequest()
        let result = try! context.fetch(request)
        let spotCellContent = SpotCellContent(spot: result.first!)
        SpotCellView(content: spotCellContent)
    }
}
