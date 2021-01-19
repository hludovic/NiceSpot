//
//  NiceSpotApp.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 17/01/2021.
//

import SwiftUI

@main
struct NiceSpotApp: App {
    let homeContent = HomeContent(context: PersistenceController.shared.container.viewContext)

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(homeContent)
        }
    }
}
