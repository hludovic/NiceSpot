//
//  PreviewItem.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 07/02/2021.
//

import Foundation
import CoreData

class Preview {
    static let context = Preview.persistenceController.container.viewContext
    
    static let spot: Spot = {
        let context = Preview.context
        let request: NSFetchRequest<Spot> = Spot.fetchRequest()
        let result = try! context.fetch(request)
        return result.first!
    }()
    
    static let spots: [Spot] = {
        let context = Preview.context
        let request: NSFetchRequest<Spot> = Spot.fetchRequest()
        let result = try! context.fetch(request)
        return result
    }()

    
    static var detailContent: DetailContent = {
        let detailContent = DetailContent(spot: Preview.spot)
        let comment = Comment.Item(
            id: "",
            title: "Super",
            detail: "C'était super géniale\nj'ai beaucoup aimé!",
            authorID: "",
            authorPseudo: "MonPseudo",
            creationDate: Date()
        )
        detailContent.comments = [comment, comment, comment]
        return detailContent
    }()
    
    static let searchContent: SearchContent = {
        return SearchContent(context: Preview.context)
    }()
    
    static let persistenceController: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<3 {
            let newItem = Spot(context: viewContext)
            newItem.category = Spot.Category.beach.rawValue
            newItem.detail = """
                La plage de l’Anse Rifflet se situe au nord de la belle Basse Terre. A une poignée de kilomètres de la bourgade de Deshaies, il faut tourner à gauche, dans une descente (panneau) pour y accéder.
                
                Elle se trouve juste à côté de la très belle plage de la Perle. Les lieux ne sont pas connus du tourisme de masse. Ceux-ci préfèrent aller sur la jolie mais bien plus fréquentée plage de Grande Anse.

                La plage de l’Anse Rifflet appelle au farniente et à la contemplation. Impossible de rater vos photos de cette plage, les lieux sont tout droit sortis d’une carte postale.
                """
            newItem.id = "E621E\(i)F8-C36C-495A-93FC-0C247A3E6E5F"
            newItem.latitude = 16.336675
            newItem.longitude = -61.785863
            newItem.municipality = Spot.Municipality.deshaies.rawValue
            newItem.imageName = "rifflet"
            newItem.title = "La plage de l’Anse Rifflet"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

}
