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
    let comment = Comment.Item( id: "", title: "Title Test Comment2", detail: "Detail Test Comment",
                                authorID: "", authorPseudo: "Me", creationDate: Date()
    )
    var content: DetailContent!
    
    override func setUp() {
        super.setUp()
        self.viewContext = loadTestableContext()
        removeComment()
        self.content = loadFakeDetailContent()
    }
    
    // MARK: - Save
    
    func testWhenSavingWrongContent_ThenFailure() {
        // Saving Empty Title
        let wrongTitle = Comment.Item(
            id: "", title: "", detail: "Detail Test Comment",
            authorID: "", authorPseudo: "Me", creationDate: Date()
        )
        content.userComment = wrongTitle
        var expectation = XCTestExpectation(description: "Saving Comment")
        content.saveUserComment { (success) in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)

        // Saving Empty Detail
        let wrongDetail = Comment.Item(
            id: "", title: "Title", detail: "",
            authorID: "", authorPseudo: "Me", creationDate: Date()
        )
        content.userComment = wrongDetail
        expectation = XCTestExpectation(description: "Saving Comment")
        content.saveUserComment { (success) in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)

        // Saving Empty Pseudo
        let wrongPseudo = Comment.Item(
            id: "", title: "Title", detail: "Detail",
            authorID: "", authorPseudo: "", creationDate: Date()
        )
        content.userComment = wrongPseudo
        expectation = XCTestExpectation(description: "Saving Comment")
        content.saveUserComment { (success) in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
//         Saving Wrong SpotId
        expectation = XCTestExpectation(description: "Saving Comment")
        let wrongConten = loadWrongSpotIdDetailContent()
        XCTAssertEqual(wrongConten.spot.id, "wrongItem")
        XCTAssertEqual(wrongConten.userComment.title, "Title Test Comment2")
        
        wrongConten.saveUserComment { (success) in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Load
    
    func testGivenAContentIsLoaded_WhenISaveAGoodComment_ThenSuccess() {
        XCTAssertEqual(content.spot.title, "La Plage de l’Anse Rifflet")
        XCTAssertEqual(content.comments.count, 0)
        content.userComment = comment
        
        //When
        let expectation = XCTestExpectation(description: "Saving Comment")
        content.saveUserComment { (success) in
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(content.errorMessage, "")
        XCTAssertEqual(content.userComment.title, "Title Test Comment2")
        XCTAssertEqual(content.comments.count, 1)
    }
    
    func testWhenLoadsWrongSpotId_ThenFailure() {
        let wrongConten = loadWrongSpotIdDetailContent()
        XCTAssertEqual(wrongConten.spot.id, "wrongItem")
        
        let expectation = XCTestExpectation(description: "Loading Comment")
        wrongConten.loadUserComment { (success) in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(wrongConten.errorMessage, "ERROR LOADING COMMENT")
    }
    
    func testGivenACommentIsPosted_WhenILoadTisComments_ThenSuccess() {
        //Given
        XCTAssertEqual(content.spot.title, "La Plage de l’Anse Rifflet")
        XCTAssertEqual(content.comments.count, 0)
        content.userComment = comment
        var expectation = XCTestExpectation(description: "Saving Comment")
        content.saveUserComment { (success) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        content.userComment.title = ""
        content.userComment.detail = ""
        XCTAssertEqual(content.userComment.title, "")
        
        Thread.sleep(forTimeInterval: 3)

        //When
        expectation = XCTestExpectation(description: "Loading Comment")
        content.loadUserComment { (success) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(content.userComment.title, "Title Test Comment2")
    }
    
    // MARK: - Edit
    
    func testWhenEditWrongSpotId_ThenFailure() {
        let wrongConten = loadWrongSpotIdDetailContent()
        XCTAssertEqual(wrongConten.spot.id, "wrongItem")
        
        let expectation = XCTestExpectation(description: "Editing Comment")
        wrongConten.updateUserComment { (success) in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(wrongConten.errorMessage, "ERROR EDDITING")
    }
    
    func testGivenACommentIsSaved_WhenEditing_ThenSuccess() {
        //Given
        XCTAssertEqual(content.comments.count, 0)
        content.userComment = comment
        var expectation = XCTestExpectation(description: "Saving Comment")
        content.saveUserComment { (success) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        Thread.sleep(forTimeInterval: 3)
        
        //When
        let editedComment = Comment.Item(
            id: "", title: "Title Test Comment2", detail: "Detail Test Comment",
            authorID: "", authorPseudo: "Me", creationDate: Date()
        )
        content.userComment = editedComment
        expectation = XCTestExpectation(description: "Updating Comment")
        content.updateUserComment { (success) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Favorite Button
    
    func testGivenSpotNotFavorite_WhenPressFavorite_ThenSpotFavorite() {
        XCTAssertTrue(content.spot.isFavorite(context: viewContext))
        
        content.pressFavoriteButton(context: viewContext)
        
        XCTAssertFalse(content.spot.isFavorite(context: viewContext))        
    }

}



private extension DetailContentTests {
    
    func loadFakeDetailContent() -> DetailContent {
        FakeData.saveFakeSpots(context: viewContext)
        let spot = FakeData.getFakeSpot(context: viewContext, title: "La Plage de l’Anse Rifflet")
        let content = DetailContent(spot: spot)
        if !content.spot.isFavorite(context: viewContext) {
            content.pressFavoriteButton(context: viewContext)
        }
        return content
    }
    
    func loadWrongSpotIdDetailContent() -> DetailContent {
        FakeData.saveFakeSpots(context: viewContext)
        let spot = FakeData.getFakeSpot(context: viewContext, title: "Wrong Item")
        let content = DetailContent(spot: spot)
        content.userComment = comment
        return content
    }
    
    func removeComment() {
        Thread.sleep(forTimeInterval: 1)
        let expectation = XCTestExpectation(description: "Removing Comment")
        Comment.removeComment(spotId: FakeData.testableSpotId) { (success) in
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
