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
        SearchSubView(content: SearchContent(context: Preview.context))
        
        SpotItemView(content: SpotCellContent(spot: Preview.spot))
            .previewLayout(.fixed(width: 450, height: 100))
            .previewDisplayName("SpotCell")
    }
}
