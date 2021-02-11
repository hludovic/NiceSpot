//
//  SpotsListView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 04/02/2021.
//

import SwiftUI
import CoreData

struct SearchSubView: View {
    @ObservedObject var content: SearchContent
    
    var body: some View {
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
    }
}

struct SpotsListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSubView(content: Preview.searchContent)
    }
}
