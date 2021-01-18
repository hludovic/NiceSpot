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

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Spot.entity(), sortDescriptors: []) var spots: FetchedResults<Spot>
    
    func fetch() {
        HomeContent.fetchSpots(quantity: 1) { (result) in
            switch result {
            case .failure(let error):
                print("ERROR \(error.localizedDescription)")
            case .success(let spots):
                print("success \(spots.count)")
            }
        }

    }
    
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
                        ForEach(spots, id: \.self) { spot in
                            NavigationLink(destination: Text(spot.title)) {
                                    SpotItem(spot: spot)
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
            .navigationTitle("Recommendations")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
