//
//  SearchContentTests.swift
//  NiceSpotTests
//
//  Created by Ludovic HENRY on 15/02/2021.
//

import XCTest
import CoreData
@testable import NiceSpot

class SearchContentTests: XCTestCase {
    var viewContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        self.viewContext = loadTestableContext()

    }

    func testGivenSpotsAreLoaded_WhenSearchWordInSpots_ThenSuccess() {
        FakeData.saveFakeSpots(context: viewContext)
        let content = SearchContent(context: viewContext)
        content.searchText = "Plage"

        content.perform()

        XCTAssertEqual(content.spots.count, 2)
    }

    func testGivenSpotsAreLoaded_WhenSearchNothing_ThenNoResult() {
        FakeData.saveFakeSpots(context: viewContext)
        let content = SearchContent(context: viewContext)
        content.searchText = ""

        content.perform()

        XCTAssertEqual(content.spots.count, 0)
    }

    func testGivenNoSpotsAreLoaded_WhenSearchAWord_ThenNoResult() {
        let content = SearchContent(context: viewContext)
        content.searchText = "Plage"

        content.perform()

        XCTAssertEqual(content.spots.count, 0)
    }

    func loadTestableContext() -> NSManagedObjectContext {
        let persistenceController = PersistenceController(inMemory: true)
        let viewContext = persistenceController.container.viewContext
        return viewContext
    }

}
