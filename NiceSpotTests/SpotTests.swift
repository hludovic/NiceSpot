//
//  SpotTests.swift
//  NiceSpotTests
//
//  Created by Ludovic HENRY on 15/03/2022.
//

import XCTest
import CoreData
@testable import NiceSpot

class SpotTests: XCTestCase {
    var viewContext: NSManagedObjectContext!

    override class func setUp() {
        super.setUp()
    }

    override func setUp() {
        super.setUp()
        self.viewContext = PersistenceController.tests.container.viewContext
    }

    override func tearDown() {
        try! TestableData.clearData(context: viewContext)
        super.tearDown()
    }

    func testOldSpotSaved_WenGetAllSpots_TheNewSpotSavedOnLast() {
        // Given
        TestableData.saveFakeSpots()
        let date = TestableData.getDate(year: 1900, month: 01, day: 1)
        TestableData.saveFakeSpot(date: date, category: "blabla", municipality: "blabla")
        // When
        let spots = try! Spot.getSpots(context: viewContext)
        // Then
        XCTAssertEqual(4, spots.count)
        XCTAssertEqual("NewSpot", spots.last?.title)
    }

    func testSavedAnRecentSpot_WhenGetAllSpots_ThenNewSpotSavedOnFirst() {
        // Given
        TestableData.saveFakeSpots()
        let date = TestableData.getDate(year: 2021, month: 01, day: 1)
        TestableData.saveFakeSpot(date: date, category: "blabla", municipality: "blabla")
        // When
        let spots = try! Spot.getSpots(context: viewContext)
        // Then
        XCTAssertEqual(4, spots.count)
        XCTAssertEqual("NewSpot", spots.first?.title)
    }

    func testSavedAWrongCategorySpot_WhenGetTheSpot_ThenCategoryIsUnknown() {
        // Given
        TestableData.saveFakeSpot(date: Date(), category: "blabla", municipality: "blabla")
        // When
        let spots = try! Spot.getSpots(context: viewContext)
        // then
        XCTAssertEqual(1, spots.count)
        XCTAssertEqual(Spot.Category.unknown, spots.first?.category)
        XCTAssertEqual(Spot.Municipality.unknown, spots.first?.municipality)
    }

    // MARK: - Favorite

    func testSpotsAreSaved_WhenSaveASpotsToFavorite_ThenSpotIsFavorite() {
        TestableData.saveFakeSpots()
        let spots = try! Spot.getSpots(context: viewContext)
        XCTAssertEqual(3, spots.count)
        var isFavorite = try! spots.first!.isFavorite(context: viewContext)
        XCTAssertFalse(isFavorite)
        var favorites = try! Spot.getFavorites(context: viewContext)
        XCTAssertEqual(0, favorites.count)
        // When
        var isSpotSaved = try! spots.first!.saveToFavorite(context: viewContext)
        XCTAssertTrue(isSpotSaved)
        isSpotSaved = try! spots.last!.saveToFavorite(context: viewContext)
        XCTAssertTrue(isSpotSaved)
        // Then
        isFavorite = try! spots.first!.isFavorite(context: viewContext)
        XCTAssertTrue(isFavorite)
        favorites = try! Spot.getFavorites(context: viewContext)
        XCTAssertEqual(2, favorites.count)
    }

    func testSpotsAreSaved_WhenSaveASpotTwiceToFavorite_ThenError() {
        TestableData.saveFakeSpots()
        let spots = try! Spot.getSpots(context: viewContext)
        XCTAssertEqual(3, spots.count)
        let isFavorite = try! spots.first!.isFavorite(context: viewContext)
        XCTAssertFalse(isFavorite)
        var favorites = try! Spot.getFavorites(context: viewContext)
        XCTAssertEqual(0, favorites.count)
        // When
        var isSpotSaved = try! spots.first!.saveToFavorite(context: viewContext)
        XCTAssertTrue(isSpotSaved)
        isSpotSaved = try! spots.first!.saveToFavorite(context: viewContext)
        XCTAssertFalse(isSpotSaved)
        favorites = try! Spot.getFavorites(context: viewContext)
        XCTAssertEqual(1, favorites.count)
    }

    func testTwoSpotsSavedToFavorite_WhenRemoveOneToFavorite_ThenThereIsOneFavorite() {
        TestableData.saveFakeSpots()
        let spots = try! Spot.getSpots(context: viewContext)
        XCTAssertEqual(3, spots.count)
        var favorites = try! Spot.getFavorites(context: viewContext)
        XCTAssertEqual(0, favorites.count)
        
        var isFavorite = try! spots.first!.isFavorite(context: viewContext)
        XCTAssertFalse(isFavorite)
        var isSaved = try! spots.first!.saveToFavorite(context: viewContext)
        XCTAssertTrue(isSaved)
        isFavorite = try! spots.first!.isFavorite(context: viewContext)
        XCTAssertTrue(isFavorite)

        isFavorite = try! spots.last!.isFavorite(context: viewContext)
        XCTAssertFalse(isFavorite)
        isSaved = try! spots.last!.saveToFavorite(context: viewContext)
        XCTAssertTrue(isSaved)
        isFavorite = try! spots.last!.isFavorite(context: viewContext)
        XCTAssertTrue(isFavorite)
        
        favorites = try! Spot.getFavorites(context: viewContext)
        XCTAssertEqual(2, favorites.count)

        // When
        
        let isRemoved = try! spots.first!.removeToFavorite(context: viewContext)
        XCTAssertTrue(isRemoved)
        
        // Then
        
        favorites = try! Spot.getFavorites(context: viewContext)
        XCTAssertEqual(1, favorites.count)
    }

    func testTwoSpotsSavedToFavorite_WhenRemoveTwiceTheSameToFavorite_ThenError() {
        TestableData.saveFakeSpots()
        let spots = try! Spot.getSpots(context: viewContext)
        XCTAssertEqual(3, spots.count)
        var favorites = try! Spot.getFavorites(context: viewContext)
        XCTAssertEqual(0, favorites.count)
        
        var isFavorite = try! spots.first!.isFavorite(context: viewContext)
        XCTAssertFalse(isFavorite)
        var isSaved = try! spots.first!.saveToFavorite(context: viewContext)
        XCTAssertTrue(isSaved)
        isFavorite = try! spots.first!.isFavorite(context: viewContext)
        XCTAssertTrue(isFavorite)

        isFavorite = try! spots.last!.isFavorite(context: viewContext)
        XCTAssertFalse(isFavorite)
        isSaved = try! spots.last!.saveToFavorite(context: viewContext)
        XCTAssertTrue(isSaved)
        isFavorite = try! spots.last!.isFavorite(context: viewContext)
        XCTAssertTrue(isFavorite)
        
        favorites = try! Spot.getFavorites(context: viewContext)
        XCTAssertEqual(2, favorites.count)
        
        // When
        
        var isRemoved = try! spots.first!.removeToFavorite(context: viewContext)
        XCTAssertTrue(isRemoved)
        
        isRemoved = try! spots.first!.removeToFavorite(context: viewContext)
        XCTAssertFalse(isRemoved)

        // Then
        
        favorites = try! Spot.getFavorites(context: viewContext)
        XCTAssertEqual(1, favorites.count)
    }

    func testOldSpotSavedToFavorite_WhenGetFavorites_ThenDisplayFavoritesOrderedByDate() {
        TestableData.saveFakeSpots()
        let date = TestableData.getDate(year: 1900, month: 01, day: 1)
        let spots = try! Spot.getSpots(context: viewContext)
        XCTAssertEqual(3, spots.count)
        
        var isSaved = try! spots[0].saveToFavorite(context: viewContext)
        XCTAssertTrue(isSaved)
        
        isSaved = try! spots[1].saveToFavorite(context: viewContext, date: date)
        XCTAssertTrue(isSaved)
        XCTAssertEqual(spots[1].title, "La Plage de la Caravelle New")
        
        isSaved = try! spots[2].saveToFavorite(context: viewContext)
        XCTAssertTrue(isSaved)

        // When
        
        let favorites = try! Spot.getFavorites(context: viewContext)
        XCTAssertEqual(favorites[0].title, "La Plage de la Caravelle New")
    }

    // MARK: - Search

    func testSpotsSaved_WhenSearchAWordThatExistInTitles_ThenReturnSpots() {
        // Given
        XCTAssertEqual(0, try! Spot.getSpots(context: viewContext).count)
        TestableData.saveFakeSpots()
        XCTAssertEqual(3, try! Spot.getSpots(context: viewContext).count)
        // When
        let result = try! Spot.searchSpots(context: viewContext, titleContains: "plage")
        // Then
        XCTAssertEqual(result.count, 2)
        let title1 = result.first!.title
        XCTAssertTrue(title1.localizedCaseInsensitiveContains("plage"))
    }

    func testSpotsSaved_WhenSearchAWordThatNOTExistInTitles_ThenReturnError() {
        // Given
        XCTAssertEqual(0, try! Spot.getSpots(context: viewContext).count)
        TestableData.saveFakeSpots()
        XCTAssertEqual(3, try! Spot.getSpots(context: viewContext).count)
        // When
        let result = try! Spot.searchSpots(context: viewContext, titleContains: "route")
        // Then
        XCTAssertEqual(result.count, 0)
    }

    func testSpotsSaved_WhenSearchEmptyWord_ThenReturnError() {
        // Given
        XCTAssertEqual(0, try! Spot.getSpots(context: viewContext).count)
        TestableData.saveFakeSpots()
        XCTAssertEqual(3, try! Spot.getSpots(context: viewContext).count)
        // When
        XCTAssertThrowsError(try Spot.searchSpots(context: viewContext, titleContains: " ")) { error in
            XCTAssertEqual(error as? SpotError, SpotError.searchSpotWrongName)
        }
        
        XCTAssertThrowsError(try Spot.searchSpots(context: viewContext, titleContains: "")) { error in
            XCTAssertEqual(error as? SpotError, SpotError.searchSpotWrongName)
        }
    }

    func testNoSpotsSaved_WhenSearchWord_ThenReturnError() {
        // Given
        XCTAssertEqual(0, try! Spot.getSpots(context: viewContext).count)
        // When
        let result = try! Spot.searchSpots(context: viewContext, titleContains: "plage")
        // Then
        XCTAssertEqual(result.count, 0)
    }

    // MARK: - Save

    func testSpotsAreSaved_WhenSaveItAgain_ThenItIsMerged() {
        TestableData.saveFakeSpots()
        XCTAssertEqual(3, try! Spot.getSpots(context: viewContext).count)
    }

    // MARK: - Cloudkit

//    func testRefreshSpots() {
//        let expectation = XCTestExpectation(description: "Get Spots")
//        var spots: [Spot] = []
//        Spot.getSpots(context: viewContext) { result in
//            switch result {
//            case .failure(let error):
//                XCTFail("\(error.localizedDescription)")
//            case .success(let spotsResult):
//                spots = spotsResult
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 10.0)
//        XCTAssertEqual(0, spots.count)
//        // When
//        let expectation2 = XCTestExpectation(description: "Refresh Spots")
//        Spot.refreshSpots(context: viewContext) { result in
//            switch result {
//            case .failure(let error):
//                XCTFail("\(error.localizedDescription) ❌")
//            case .success(let success):
//                XCTAssertTrue(success)
//            }
//            expectation2.fulfill()
//        }
//        wait(for: [expectation2], timeout: 10.0)
//        // Then
//        let expectation3 = XCTestExpectation(description: "Get Spots")
//        spots = []
//        Spot.getSpots(context: viewContext) { result in
//            switch result {
//            case .failure(let error):
//                XCTFail("\(error.localizedDescription)")
//            case .success(let spotsResult):
//                spots = spotsResult
//            }
//            expectation3.fulfill()
//        }
//        wait(for: [expectation3], timeout: 10.0)
//        XCTAssertEqual(9, spots.count)
//    }
    
}
