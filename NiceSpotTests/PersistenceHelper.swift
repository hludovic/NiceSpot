//
//  PersistanceHelper.swift
//  NiceSpotTests
//
//  Created by Ludovic HENRY on 06/02/2021.
//

import Foundation
import CoreData
@testable import NiceSpot

class PersistenceHelper {
    static func saveFakeSpots(context: NSManagedObjectContext) {
        for i in 1..<4 {
            let newItem = Spot(context: context)
            newItem.category = Spot.Category.beach.rawValue
            newItem.detail = """
La plage de l’Anse Rifflet se situe au nord de la belle Basse Terre. A une poignée de kilomètres de la bourgade de Deshaies, il faut tourner à gauche, dans une descente (panneau) pour y accéder.

Elle se trouve juste à côté de la très belle plage de la Perle. Les lieux ne sont pas connus du tourisme de masse. Ceux-ci préfèrent aller sur la jolie mais bien plus fréquentée plage de Grande Anse.

La plage de l’Anse Rifflet appelle au farniente et à la contemplation. Impossible de rater vos photos de cette plage, les lieux sont tout droit sortis d’une carte postale.
"""
            newItem.id = "B1\(i)FDB9F-A933-DA3C-0855-FCDF5AEC017E"
            newItem.latitude = 16.336675
            newItem.longitude = -61.785863
            newItem.municipality = Spot.Municipality.deshaies.rawValue
            newItem.imageName = "rifflet"
            newItem.title = "La plage de l’Anse Rifflet"
        }
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    static func clearSpots(context: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Spot.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            completion(true)
        } catch {
            completion(false)
        }
        ImageManager.imageCache.removeAllObjects()
    }
    
    static func getFakeSpots(context: NSManagedObjectContext) -> [Spot] {
        let request: NSFetchRequest<Spot> = Spot.fetchRequest()
        let result = try! context.fetch(request)
        return result
    }
}
