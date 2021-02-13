//
//  CommentTests.swift
//  NiceSpotTests
//
//  Created by Ludovic HENRY on 11/02/2021.
//

import XCTest
@testable import NiceSpot

class CommentTests: XCTestCase {
    let spotId = "8EBDDD40-AA09-45C3-3C05-0BF506BEE974"
    
    override func setUp() {
        super.setUp()
        removeComment()
    }
    
    // MARK: - Delete
    
    func testGiventThereAreAComment_WhenDeleteThisComment_ThenSuccess() {
        //Given
        var expectation = XCTestExpectation(description: "Posting Comment")
        Comment.postComment(spotId: spotId, title: "title", content: "comment", pseudo: "pseudo") { (success) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        Thread.sleep(forTimeInterval: 3)
        
        expectation = XCTestExpectation(description: "Fetching comments")
        Comment.getComments(spotId: spotId) { (result) in
            switch result{
            case .failure(_ ):
                print("Error")
            case .success(let comments):
                XCTAssertEqual(comments.count, 1)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        Thread.sleep(forTimeInterval: 3)
        
        //When
        expectation = XCTestExpectation(description: "Removing Comment")
        Comment.removeComment(spotId: spotId) { (success) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        Thread.sleep(forTimeInterval: 3)
        
        //THEN
        expectation = XCTestExpectation(description: "Fetching comments")
        Comment.getComments(spotId: spotId) { (result) in
            switch result{
            case .failure(_ ):
                print("Error")
            case .success(let comments):
                XCTAssertEqual(comments.count, 0)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGivenThereAreNoComment_WhenRemovingAComment_ThenFailure() {
        //Given
        var expectation = XCTestExpectation(description: "Fetching comments")
        Comment.getComments(spotId: spotId) { (result) in
            switch result{
            case .failure(_ ):
                print("Error")
            case .success(let comments):
                XCTAssertEqual(comments.count, 0)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        Thread.sleep(forTimeInterval: 3)
        
        //When
        expectation = XCTestExpectation(description: "Removing Comment")
        Comment.removeComment(spotId: spotId) { (success) in
            //Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Save
    
    func testGivenThereAreNoComment_WhenIComment_ThenSuccess() {
        //Given
        var expectation = XCTestExpectation(description: "Fetching comments")
        Comment.getComments(spotId: spotId) { (result) in
            switch result{
            case .failure(_ ):
                print("Error")
            case .success(let comments):
                XCTAssertEqual(comments.count, 0)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        //When
        expectation = XCTestExpectation(description: "Posting Comment")
        Comment.postComment(spotId: spotId, title: "title", content: "comment", pseudo: "pseudo") { (success) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        //Then
        Thread.sleep(forTimeInterval: 3)
        expectation = XCTestExpectation(description: "Fetching Comment")
        Comment.getComments(spotId: spotId) { (result) in
            switch result{
            case .failure(_ ):
                print("Error")
            case .success(let comments):
                XCTAssertEqual(comments.count, 1)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGivenThereAreOneComment_WhenICommentAgain_ThenFailure() {
        //Given
        var expectation = XCTestExpectation(description: "Posting Comment")
        Comment.postComment(spotId: spotId, title: "title", content: "comment", pseudo: "pseudo") { (success) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        Thread.sleep(forTimeInterval: 3)
        
        //When
        expectation = XCTestExpectation(description: "Posting Comment Again")
        Comment.postComment(spotId: spotId, title: "new comment", content: "comment", pseudo: "pseudo") { (success) in
            //Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    // MARK: - Edit
    
    func testGivenThereAreOneComment_WhenEditing_ThenSuccess() {
        //Given
        var expectation = XCTestExpectation(description: "Posting Comment")
        Comment.postComment(spotId: spotId, title: "title", content: "comment", pseudo: "pseudo") { (success) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        Thread.sleep(forTimeInterval: 3)
        
        //When
        expectation = XCTestExpectation(description: "Editing Comment")
        Comment.editComment(spotId: spotId, title: "Edited", detail: "Edited", pseudo: "pseudo") { (success) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        Thread.sleep(forTimeInterval: 3)
        
        //Then
        expectation = XCTestExpectation(description: "User Comment")
        Comment.getUserComment(spotId: spotId, userId: "__defaultOwner__") { (comment) in
            XCTAssertNotNil(comment)
            if let comment = comment {
                XCTAssertEqual(comment.title, "Edited")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
    }
    
    func testGivenThereAreNoComment_WhenEditing_ThenFailure() {
        //Given
        var expectation = XCTestExpectation(description: "Fetching comments")
        Comment.getComments(spotId: spotId) { (result) in
            switch result{
            case .failure(_ ):
                print("Error")
            case .success(let comments):
                XCTAssertEqual(comments.count, 0)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        //When
        expectation = XCTestExpectation(description: "Editing Comment")
        Comment.editComment(spotId: spotId, title: "Title", detail: "Detail", pseudo: "pseudo") { (success) in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        Thread.sleep(forTimeInterval: 3)
    }
    
    // MARK: - Test Wrong ID
    
    func testWhenCommentWithAWrongSpotId_ThenItFails() {
        let expectation = XCTestExpectation(description: "Posting Comment")
        Comment.postComment(spotId: "AAA", title: "Title", content: "Content", pseudo: "pseudo") { (success) in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testWhenEditingCommentWithAWrongSpotId_ThenItFails() {
        let expectation = XCTestExpectation(description: "Posting Comment")
        Comment.editComment(spotId: "AAA", title: "a", detail: "b", pseudo: "c") { (success) in
            XCTAssertFalse(success)
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testWhenDeletingCommentWithAWrongSpotId_ThenItFails() {
        let expectation = XCTestExpectation(description: "Posting Comment")
        Comment.removeComment(spotId: "AAA") { (success) in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func removeComment() {
        Thread.sleep(forTimeInterval: 1)
        let expectation = XCTestExpectation(description: "Removing Comment")
        Comment.removeComment(spotId: spotId) { (success) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        Thread.sleep(forTimeInterval: 1)
    }
    
}
