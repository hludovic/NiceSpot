//
//  SearchView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 26/01/2021.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var content = SearchContent(context: PersistenceController.shared.container.viewContext)

    var body: some View {
        NavigationView {
            SearchSubView(content: SearchContent(context: viewContext))
                .navigationTitle("Search")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environment(\.managedObjectContext, Preview.context)
    }
}
