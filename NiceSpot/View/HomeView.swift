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
                    Text("Récent")
                        .font(.headline)
                        .padding(.leading)
                        .offset(y: 10.0)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(content.spots, id: \.self) { (result: Spot) in
                                NavigationLink(destination: DetailView(content: DetailContent(spot: result))) {
                                    SpotCellView(spotId: result.id!)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Découvrir").font(.headline)
                        Text(content.loadingIndicator).font(.subheadline)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: { content.refreshSpots(context: viewContext) },
                        label: { Image(systemName: "arrow.clockwise") }
                    )
                }
            }
            .alert(isPresented: $content.showAlert) {
                Alert(title: Text("Error"), message: Text(content.errorMessage), dismissButton: .default(Text("Ok")))
            }
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
