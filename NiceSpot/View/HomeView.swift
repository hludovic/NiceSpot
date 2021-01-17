//
//  HomeView.swift
//  Guadeloupe
//
//  Created by Ludovic HENRY on 08/11/2020.
//

import SwiftUI

struct HomeView: View {
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


                HStack {
                    Text("Populaire")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Text("Tout voir")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
                .padding(.bottom, -10)
                ScrollView(.horizontal, showsIndicators: true, content: {
                    HStack {
                        ForEach(viewpointsData) { viewpoint in
                            NavigationLink(destination: Text(viewpoint.title)) {
                                    SpotItem()
                                    .frame(width: 300)
                                    .padding(.trailing, 20.0)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                })
                .padding()
                Spacer()

            }
            .navigationBarTitle(Text("Recommendations"))

        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
