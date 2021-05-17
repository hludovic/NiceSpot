//
//  MainView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 01/02/2021.
//

import SwiftUI

struct MainView: View {

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "rectangle.stack")
                    Text("Spots")
                }.tag(0)
            FavoriteView()
                .tabItem {
                    Image(systemName: "bookmark")
                    Text("Saved")
                }.tag(1)
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }.tag(2)
        }
    }
}

struct MainVIew_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environment(\.managedObjectContext, Preview.context)
    }
}
