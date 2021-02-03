//
//  HomeView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 08/11/2020.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var content: HomeContent = HomeContent()
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    Button(action: {
                        content.refreshSpots(context: viewContext) { (success) in
                            DispatchQueue.main.async { print("REFRESHED") }
                        }
                    }, label: {
                        Text("TODO: Pull to Refresh")
                    })
                    Text("Récent")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.bottom, -10)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(content.spots, id: \.self) { (result: Spot) in
                                NavigationLink(destination: DetailView(content: DetailContent(spot: result))) {
                                    SpotCellView(spotId: result.id!)
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
            .navigationTitle(Text("Découvrir"))
        }
        .onAppear {
            content.loadSpots(context: viewContext)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(content: HomeContent())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
