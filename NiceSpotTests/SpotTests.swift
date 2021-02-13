//
//  SpotTests.swift
//  NiceSpotTests
//
//  Created by Ludovic HENRY on 12/02/2021.
//

import XCTest
import CoreData
@testable import NiceSpot

class SpotTests: XCTestCase {
    var viewContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        self.viewContext = loadTestableContext()
    }

    
    
    
    

    func loadTestableContext() -> NSManagedObjectContext {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: "NiceSpot")
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container.newBackgroundContext()
    }

}
