//
//  SearchView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 26/01/2021.
//

import SwiftUI
import CoreData

struct SearchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var content = SearchContent(context: PersistenceController.shared.container.viewContext)
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search...", text: $content.searchText)
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding()
                        .onTapGesture {
                            content.isSearching = true
                        }
                    if content.isSearching {
                        Button("Cancel") {
                            content.isSearching = false
                            content.searchText = ""
                        }
                        .padding(.trailing, 20)
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                    }
                }
                
                List {
                    ForEach(content.spots) { spot in
                        NavigationLink(
                            destination:
                                DetailView(content: DetailContent(spot: spot)),
                            label: {
                                SpotItemView(content: SpotCellContent(spot: spot))
                            }
                        )
                    }
                }
                .listStyle(PlainListStyle())
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Rechercher").font(.headline)
                    }
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
