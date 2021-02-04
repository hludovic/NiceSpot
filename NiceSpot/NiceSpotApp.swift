//
//  NiceSpotApp.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 17/01/2021.
//

import SwiftUI

@main
struct NiceSpotApp: App {
    static let imageCache = NSCache<NSString, UIImage>()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
