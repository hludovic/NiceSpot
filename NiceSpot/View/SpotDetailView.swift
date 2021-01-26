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
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            ScrollView(.vertical, showsIndicators: false) {
                NavigationLink(
                    destination: content.image
                        .navigationTitle(content.title),
                    label: {
                        content.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    })
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
            BackButton()
                .padding([.top, .leading], 5.0)
        }
        .onAppear{ content.loadImage()}
        .navigationBarHidden(true)
    }
}

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "arrow.backward.circle.fill")
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundColor(Color.gray.opacity(0.5))
            
        })
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
