//
//  DetailContentTests.swift
//  NiceSpotTests
//
//  Created by Ludovic HENRY on 13/02/2021.
//

import XCTest
import CoreData
@testable import NiceSpot

class DetailContentTests: XCTestCase {
    var viewContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        self.viewContext = loadTestableContext()
        removeComment()
    }

    func testSavingPost() {
        FakeData.saveFakeSpots(context: viewContext)
        let spot = FakeData.getFakeSpot(context: viewContext)
        let content = DetailContent(spot: spot)
        XCTAssertEqual(content.spot.title, "La Plage de l’Anse Rifflet")
        XCTAssertEqual(content.comments.count, 0)
        
        let comment = Comment.Item(
            id: "",
            title: "Title Test Comment2",
            detail: "Detail Test Comment",
            authorID: "", authorPseudo: "Me",
            creationDate: Date()
        )
        content.userComment = comment

        let expectation = XCTestExpectation(description: " Saving Comment ")
        content.saveUserComment { (success) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
//        Thread.sleep(forTimeInterval: 5)
        print("\(content.errorMessage) -- >")
        
    }
    
    func removeComment() {
        Thread.sleep(forTimeInterval: 1)
        let expectation = XCTestExpectation(description: "Removing Comment")
        Comment.removeComment(spotId: "B11FDB9F-A933-DA3C-0855-FCDF5AEC017E") { (success) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        Thread.sleep(forTimeInterval: 1)
    }

    
    func loadTestableContext() -> NSManagedObjectContext {
        let persistenceController = PersistenceController(inMemory: true)
        let viewContext = persistenceController.container.viewContext
        return viewContext
    }

}
