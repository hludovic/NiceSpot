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
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)) {
                TextField("Search...", text: $content.searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .overlay(
                        Image(systemName: "magnifyingglass")
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    )
                    .cornerRadius(8)
                    .padding()
                if content.searchText != "" {
                    Button(action: {
                        content.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, 25)
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
