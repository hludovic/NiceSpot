//
//  Persistence.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 17/01/2021.
//

import CoreData

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<3 {
            let newItem = Spot(context: viewContext)
            newItem.category = Category.beach.rawValue
            newItem.detail = """
                La plage de l’Anse Rifflet se situe au nord de la belle Basse Terre. A une poignée de kilomètres de la bourgade de Deshaies, il faut tourner à gauche, dans une descente (panneau) pour y accéder.
                
                Elle se trouve juste à côté de la très belle plage de la Perle. Les lieux ne sont pas connus du tourisme de masse. Ceux-ci préfèrent aller sur la jolie mais bien plus fréquentée plage de Grande Anse.

                La plage de l’Anse Rifflet appelle au farniente et à la contemplation. Impossible de rater vos photos de cette plage, les lieux sont tout droit sortis d’une carte postale.
                """
            newItem.id = "E621E\(i)F8-C36C-495A-93FC-0C247A3E6E5F"
            newItem.latitude = 16.336675
            newItem.longitude = -61.785863
            newItem.municipality = Municipality.deshaie.rawValue
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

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "NiceSpot")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
}

enum Category: String {
    case unknown = "Unknown"
    case beach = "Beach"
    case mountain = "Mountain"
    case river = "River"
}

enum Municipality: String {
    case unknown = "Unknown"
    case deshaie = "Deshaie"
    case sainterose = "Sainte-Rose"
    case lamentin = "Lamentin"
    case SaintClaude = "Saint-Claude"
}

