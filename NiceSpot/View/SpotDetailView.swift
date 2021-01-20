//
//  SpotDetailView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 19/01/2021.
//

import SwiftUI
import CoreData

struct SpotDetailView: View {
    @ObservedObject var content: SpotDetailContent

    var body: some View {
        VStack {
            Text(content.title)
            content.imageLarge
        }

    }
}

struct SpotDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let request: NSFetchRequest<Spot> = Spot.fetchRequest()
        let result = try! context.fetch(request)
        let spotDetailContent = SpotDetailContent(spot: result.first!)
        SpotDetailView(content: spotDetailContent)
    }
}
