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
        clearSpots(context: context) { (_) in
            self.loadFakeSpots()
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

        let exp = expectation(description: "Fetching spots")
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 5) {
            //THEN
            XCTAssertEqual(self.content.spots.count, 2)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
    }

}

extension HomeContentTests {

    func clearSpots(context: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Spot.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            completion(true)
        } catch {
            completion(false)
        }
        ImageManager.imageCache.removeAllObjects()
    }
    
    func loadFakeSpots() {
        for i in 0..<3 {
            let newItem = Spot(context: context)
            newItem.category = Spot.Category.beach.rawValue
            newItem.detail = """
                La plage de l’Anse Rifflet se situe au nord de la belle Basse Terre. A une poignée de kilomètres de la bourgade de Deshaies, il faut tourner à gauche, dans une descente (panneau) pour y accéder.
                
                Elle se trouve juste à côté de la très belle plage de la Perle. Les lieux ne sont pas connus du tourisme de masse. Ceux-ci préfèrent aller sur la jolie mais bien plus fréquentée plage de Grande Anse.

                La plage de l’Anse Rifflet appelle au farniente et à la contemplation. Impossible de rater vos photos de cette plage, les lieux sont tout droit sortis d’une carte postale.
                """
            newItem.id = "E621E\(i)F8-C36C-495A-93FC-0C247A3E6E5F"
            newItem.latitude = 16.336675
            newItem.longitude = -61.785863
            newItem.municipality = Spot.Municipality.deshaies.rawValue
            newItem.imageName = "rifflet"
            newItem.title = "La plage de l’Anse Rifflet"
        }
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
