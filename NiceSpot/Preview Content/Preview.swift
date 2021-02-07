//
//  PreviewItem.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 07/02/2021.
//

import Foundation
import CoreData

class Preview {
    static var context = PersistenceController.preview.container.viewContext
    
    static var spot: Spot = {
        let context = PersistenceController.preview.container.viewContext
        let request: NSFetchRequest<Spot> = Spot.fetchRequest()
        let result = try! context.fetch(request)
        return result.first!
    }()
}
