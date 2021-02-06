//
//  HomeContentTests.swift
//  NiceSpotTests
//
//  Created by Ludovic HENRY on 06/02/2021.
//

import XCTest
import CoreData
@testable import NiceSpot

class HomeContentTests: XCTestCase {
    var context: NSManagedObjectContext!
    var content: HomeContent!
    
    override func setUp() {
        super.setUp()
        content = HomeContent()
        context = PersistenceController.preview.container.viewContext
        PersistenceHelper.clearSpots(context: context) { (_) in
            PersistenceHelper.saveFakeSpots(context: self.context)
        }
    }

    func testGivenSpotsIsEmpty_WhenLoadSpots_ThenSpotsIsFill() {
        //GIVEN
        XCTAssertEqual(content.spots, [])

        //WHEN
        content.loadSpots(context: context)

        //THEN
        print("\(content.spots.count) ---->")
        XCTAssertEqual(content.spots.count, 3)
    }

    func testGivenSpotsIsEmpty_WhenIRefresh_ThenSpotsIsNotEmpty() {
        //GIVEN
        XCTAssertEqual(content.spots, [])

        //WHEN
        content.refreshSpots(context: context)

        let expectation = XCTestExpectation(description: "Fetching spots")
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 5) {
            //THEN
            XCTAssertEqual(self.content.spots.count, 2)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

}
