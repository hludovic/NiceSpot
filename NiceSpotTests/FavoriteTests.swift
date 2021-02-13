//
//  FavoriteTests.swift
//  NiceSpotTests
//
//  Created by Ludovic HENRY on 10/02/2021.
//

import XCTest
import CoreData

@testable import NiceSpot

class FavoriteTests: XCTestCase {
    var viewContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        self.viewContext = loadTestableContext()
    }
    
    func testGivenFavoriteIsEmpty_WhenSavingAFavorite_ThenTheFavoriteIsStored() {
        var expectation = XCTestExpectation(description: "Get favorites")
        Favorite.getFavorites(context: viewContext) { (favorites) in
            XCTAssertEqual(favorites.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)

        Favorite.saveSpotId(context: viewContext, spotId: "__SPOT_ID__") { (success) in
            XCTAssertTrue(success)
        }
        
        expectation = XCTestExpectation(description: "Get favorites")
        Favorite.getFavorites(context: viewContext) { (favorites) in
            XCTAssertEqual(favorites.first!.spotId, "__SPOT_ID__")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testGivenAnIdIsSaved_WhenIGetAWrongSpotId_ThenItReturnsFalse() {
        Favorite.saveSpotId(context: viewContext, spotId: "__SPOT_ID__") { (success) in
            XCTAssertTrue(success)
        }

        Favorite.getFavorite(context: viewContext, spotId: "__NOT_STORED_SPOT_ID__") { (favorite) in
            XCTAssertNil(favorite)
        }
    }

    func testGivenAnIdIsSaved_WhenIGetThisFavorite_ThenItReturnsTrue() {
        Favorite.saveSpotId(context: viewContext, spotId: "__SPOT_ID__") { (success) in
            XCTAssertTrue(success)
        }

        Favorite.getFavorite(context: viewContext, spotId: "__SPOT_ID__") { (favorite) in
            XCTAssertEqual(favorite!.spotId, "__SPOT_ID__")
        }
    }
    
    func testGivenAnIdIsSaved_WhenITestIfItIsFavorite_ThenItReturnsTrue() {
        Favorite.saveSpotId(context: viewContext, spotId: "__SPOT_ID__") { (success) in
            XCTAssertTrue(success)
        }
        
        Favorite.isFavorite(context: viewContext, spotId: "__SPOT_ID__") { (isFavorite) in
            XCTAssertTrue(isFavorite)
        }

    }

    func testGivenAnIdIsSaved_WhenITestAWrongIdIfItIsFavorite_ThenItReturnsFalse() {
        Favorite.saveSpotId(context: viewContext, spotId: "__SPOT_ID__") { (success) in
            XCTAssertTrue(success)
        }

        Favorite.isFavorite(context: viewContext, spotId: "__NOT_STORED_SPOT_ID__") { (success) in
            XCTAssertFalse(success)
        }
    }

    func testGivenAnIdIsSaved_WhenIDeleteThisFavorite_ThenItReturnsTrue() {
        Favorite.saveSpotId(context: viewContext, spotId: "__SPOT_ID__") { (success) in
            XCTAssertTrue(success)
        }

        Favorite.remove(context: viewContext, spotId: "__SPOT_ID__") { (success) in
            XCTAssertTrue(success)
        }
    }

    func testGivenNothingIsSaved_WhenIDeleteAFavorite_ThenItReturnsFalse() {
        Favorite.getFavorites(context: viewContext) { (favorites) in
            XCTAssertEqual(favorites.count, 0)
        }

        Favorite.remove(context: viewContext, spotId: "__SPOT_ID__") { (success) in
            XCTAssertFalse(success)
        }
    }

    func testASpotIsInFavorite_WhenSaveThisSpotAgain_ThenItReturnsFalse() {
        Favorite.saveSpotId(context: viewContext, spotId: "__SPOT_ID__") { (success) in
            XCTAssertTrue(success)
        }

        Favorite.saveSpotId(context: viewContext, spotId: "__SPOT_ID__") { (success) in
            XCTAssertFalse(success)
        }
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
