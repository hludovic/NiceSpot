//
//  HomeContentTests.swift
//  NiceSpotTests
//
//  Created by Ludovic HENRY on 15/02/2021.
//

import XCTest
import CoreData
@testable import NiceSpot

class HomeContentTests: XCTestCase {
    let cloudKitSpotsCount = 10
    var viewContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        self.viewContext = loadTestableContext()
        
    }
    
    func testGivenSpotsAreSaved_WhenLoadSpots_ThenLoaded() {
        FakeData.saveFakeSpots(context: viewContext)
        let content = HomeContent()
        XCTAssertEqual(content.spots.count, 0)
        
        content.loadSpots(context: viewContext)
        
        XCTAssertEqual(content.spots.count, 4)
    }
    
    func testGivenNoSpotsAreSaved_WhenLoadSpots_ThenSpotsEmpty() {
        let content = HomeContent()
        XCTAssertEqual(content.spots.count, 0)
        
        content.loadSpots(context: viewContext)
        
        XCTAssertEqual(content.spots.count, 0)
    }
    
    func testGivenNoSpotsLoaded_WhenRefreshSpots_ThenNewSpotsLoaded() {
        let content = HomeContent()
        XCTAssertEqual(content.spots.count, 0)
        
        let expectation = XCTestExpectation(description: "Refresh Spots")
        content.refreshSpots(context: viewContext) { (refreshed) in
            XCTAssertTrue(refreshed)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
        XCTAssertEqual(content.spots.count, cloudKitSpotsCount)
    }
    
    func loadTestableContext() -> NSManagedObjectContext {
        let persistenceController = PersistenceController(inMemory: true)
        let viewContext = persistenceController.container.viewContext
        return viewContext
    }
    
}
