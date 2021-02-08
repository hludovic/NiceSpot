//
//  MainVIew.swift
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
                    Image(systemName: "house")
                    Text("Home")
                }.tag(0)
            Text("Second View")
                .tabItem {
                    Image(systemName: "star")
                    Text("Favorite")
                }.tag(1)
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }.tag(1)
        }
    }
}

struct MainVIew_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environment(\.managedObjectContext, Preview.context)
    }
}
