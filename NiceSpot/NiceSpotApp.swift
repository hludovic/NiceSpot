//
//  NiceSpotApp.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 17/01/2021.
//

import SwiftUI
import MapKit

@main
struct NiceSpotApp: App {
    let content = HomeContent(context: PersistenceController.shared.container.viewContext)
    let context = PersistenceController.shared.container.viewContext
    static let imageCache = NSCache<NSString, UIImage>()

    var body: some Scene {
        WindowGroup {
            HomeView(content: content)
                .environment(\.managedObjectContext, context)
        }
    }
}
