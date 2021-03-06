//
//  Persistence.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 17/01/2021.
//

import CoreData

class PersistenceController: ObservableObject {

    // MARK: - CloudKit Static Property

    static let publicCKDB: CKDatabase = CKContainer(identifier: "iCloud.fr.hludovic.container1").publicCloudDatabase

    static var isICloudAvailable: Bool {
        if FileManager.default.ubiquityIdentityToken != nil {
            return true
        } else { return false }
    }

    // MARK: - CoreData Static Property

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "NiceSpot")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
