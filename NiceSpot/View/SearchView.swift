//
//  SearchView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 26/01/2021.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    TextField("Rechercher...", text: $searchText)
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding()
                        .onTapGesture {
                            isSearching = true
                        }
                    
                    if isSearching {
                        Button("Annuler") {
                            isSearching = false
                            searchText = ""
                        }
                        .padding(.trailing, 20)
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                    }
                }
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
