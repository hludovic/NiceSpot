//
//  SpotDetailView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 19/01/2021.
//

import SwiftUI
import CoreData

struct SpotDetailView: View {
    @ObservedObject var content: SpotDetailContent

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            NavigationLink(
                destination: content.imageLarge
                    .navigationTitle(content.title),
                label: {
                    content.imageLarge
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
            Rectangle()
                .foregroundColor(.white)
                .frame(height: 50)
                .cornerRadius(30)
                .offset(y: -30)
                .padding(.bottom, -50)
            VStack {
                HStack {
                    Text(content.title)
                        .font(.title)
                        .fontWeight(.regular)
                        .lineLimit(2)
                    Spacer()
                }
                HStack {
                    Image("\(content.category)")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .clipShape(Capsule())
                    Text(content.category)
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(5)
                        .background(Color.green)
                        .clipShape(Capsule())
                        .foregroundColor(.white)
                    Text(content.municipality)
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(5)
                        .background(Color.orange)
                        .clipShape(Capsule())
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding()
            Divider()
            Text(content.detail)
                .font(.body)
                .foregroundColor(Color.gray)
                .padding()
            NavigationLink(
                destination:
                    VStack {
                        MapView(spotLocation: content.location)
                        Link("Open in Maps", destination: content.mapLink)
                    }
                    .navigationTitle(content.title)
                ,
                label: {
                    MapView(spotLocation: content.location)
                        .frame(height: 300)
                        .cornerRadius(10)
                })

        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal ) {
                Text(content.category)
            }
        }
    }
}

struct SpotDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let request: NSFetchRequest<Spot> = Spot.fetchRequest()
        let result = try! context.fetch(request)
        let spotDetailContent = SpotDetailContent(spot: result.first!)
        SpotDetailView(content: spotDetailContent)
    }
}
