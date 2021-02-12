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
    }
    
    func testDeleteComment() {
        //Given One Comment
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
        
        //When Remove
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
    
    func testDeleteTwice() {
        
        var expectation = XCTestExpectation(description: "Removing Comment")
        Comment.removeComment(spotId: spotId) { (success) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        Thread.sleep(forTimeInterval: 3)
        
        expectation = XCTestExpectation(description: "Removing Comment")
        Comment.removeComment(spotId: spotId) { (success) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        Thread.sleep(forTimeInterval: 3)


        
    }
    
    func testSaveCoomment() {
        //Given No Comments
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

        //When PostComment
        expectation = XCTestExpectation(description: "Posting Comment")
        Comment.postComment(spotId: spotId, title: "title", content: "comment", pseudo: "pseudo") { (success) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)

        //Then
        Thread.sleep(forTimeInterval: 2)
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
        wait(for: [expectation], timeout: 10.0)
        Thread.sleep(forTimeInterval: 2)
    }
    
    
    func testPostCommentTwice() {
        //Given One Comment
        var expectation = XCTestExpectation(description: "Posting Comment")
        Comment.postComment(spotId: spotId, title: "title", content: "comment", pseudo: "pseudo") { (success) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        Thread.sleep(forTimeInterval: 2)

        //When
        expectation = XCTestExpectation(description: "Posting Comment Again")
        Comment.postComment(spotId: spotId, title: "new comment", content: "comment", pseudo: "pseudo") { (success) in
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
        wait(for: [expectation], timeout: 10.0)
        Thread.sleep(forTimeInterval: 1)
    }
    
}
