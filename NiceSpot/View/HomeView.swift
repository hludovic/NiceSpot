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
            List {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 250)
                    .listRowInsets(EdgeInsets())
                ForEach(content.usedCategories, id: \.self) { (category: String) in
                    SpotScrollView(
                        cathegory: category,
                        spots: content.getSpotsBy(category: category)
                    )
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
                        action: { content.refreshSpots(context: viewContext) { _ in } },
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
            .environment(\.managedObjectContext, Preview.context)
    }
}
