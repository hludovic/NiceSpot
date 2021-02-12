//
//  DetailContentTests.swift
//  NiceSpotTests
//
//  Created by Ludovic HENRY on 06/02/2021.
//

import XCTest
@testable import NiceSpot

class DetailContentTests: XCTestCase {
    let context = PersistenceController.shared.container.viewContext
    var content: DetailContent!
    var spots: [Spot] = []
    
    override func setUp() {
        super.setUp()
        PersistenceHelper.clearSpots(context: context) { (_) in
            PersistenceHelper.saveFakeSpots(context: self.context)
            self.spots = PersistenceHelper.getFakeSpots(context: self.context)
            self.content = DetailContent(spot: self.spots.first!)

        }
        
    }
    
    func testExemple() {

        //GIVEN
        XCTAssertEqual(spots.count, 3)
        
        content.refreshComments()
        
        let expectation = XCTestExpectation(description: "Fetching spots")
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 5) {
            //THEN
            XCTAssertEqual(self.content.comments.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)

        
        
    }
    
}
