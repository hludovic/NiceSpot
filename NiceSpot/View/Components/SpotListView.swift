//
//  SpotsListView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 04/02/2021.
//

import SwiftUI
import CoreData

struct SpotListView: View {
    @State var spots: [Spot]

    var body: some View {
        List {
            ForEach(spots) { spot in
                NavigationLink(
                    destination:
                        DetailView(content: DetailContent(spot: spot)),
                    label: {
                        SpotItemView(content: SpotCellContent(spot: spot))
                    }
                )
            }
        }
    }
}

struct SpotItemView: View {
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


struct SpotsListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let request: NSFetchRequest<Spot> = Spot.fetchRequest()
        let result = try! context.fetch(request)
        SpotListView(spots: result)

        SpotItemView(content: SpotCellContent(spot: result.first!))
            .previewLayout(.fixed(width: 450, height: 100))
            .previewDisplayName("SpotCell")
    }
}
