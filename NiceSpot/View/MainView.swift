//
//  MainVIew.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 01/02/2021.
//

import SwiftUI

struct MainView: View {
    let content = HomeContent(context: PersistenceController.shared.container.viewContext)
    let context = PersistenceController.shared.container.viewContext
    
    var body: some View {
        TabView {
            HomeView(content: content)
                .environment(\.managedObjectContext, context)
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
    }
}
