//
//  HomeView.swift
//  Guadeloupe
//
//  Created by Ludovic HENRY on 08/11/2020.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var content: HomeContent

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    Text("Récent")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.bottom, -10)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(content.spots, id: \.self) { (result: Spot) in
                                NavigationLink(destination: SpotDetailView(content: SpotDetailContent(spot: result))) {
                                    SpotCellView(content: SpotCellContent(spot: result))
                                        .frame(width: 250)
                                        .padding(.trailing, 10.0)
                                }
                            }
                        }
                    }
                    .padding()
                    Spacer()
                }
            }
            .navigationTitle("Découvrir")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let content = HomeContent(context: PersistenceController.preview.container.viewContext)
        HomeView(content: content)
    }
}
