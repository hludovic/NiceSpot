//
//  HomeContent.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 17/01/2021.
//

import Foundation
import CoreData

class HomeContent: ObservableObject {
    // MARK: Properties
    @Published var showAlert: Bool = false
    @Published private(set) var spots: [Spot] = []
    @Published private(set) var errorMessage: String = "" {
        didSet { showAlert = true }
    }
    @Published private(set) var loadingIndicator: String = ""
    @Published private(set) var usedCategories: [String] = []
    
    // MARK: - Public Methods
    func loadSpots(context: NSManagedObjectContext) {
        Spot.getSpots(context: context) { [unowned self] (result) in
            self.spots = result
            self.getUsedCategories()
        }
        
    }
    
    func refreshSpots (context: NSManagedObjectContext) {
        loadingIndicator = "Syncing..."
        Spot.fetchSpots() { [unowned self] (fetchedSpots) in
            guard fetchedSpots.count != 0 else {
                DispatchQueue.main.async {
                    errorMessage = "ERROR: Not fetched"
                    loadingIndicator = ""
                }
                return
            }
            self.clearSpots(context: context) { [unowned self] (cleared) in
                guard cleared else {
                    DispatchQueue.main.async {
                        self.errorMessage = "ERROR: Not cleared"
                        loadingIndicator = ""
                    }
                    return
                }
                Spot.saveFetchedSpots(context: context, fetchedSpots: fetchedSpots) { [unowned self] (saved) in
                    guard saved else {
                        DispatchQueue.main.async {
                            errorMessage = "ERROR: Not converted"
                            loadingIndicator = ""
                        }
                        return
                    }
                    Spot.getSpots(context: context) { [unowned self] (result) in
                        DispatchQueue.main.async {
                            self.spots = result
                            loadingIndicator = ""
                        }
                    }
                }
            }
        }
    }
    
    func getSpotsBy(category: String) -> [Spot] {
        guard !spots.isEmpty else { return [] }
        var spotList: [Spot] = []
        for spot in spots {
            guard let categoryString = spot.category else { return [] }
            if categoryString == category {
                spotList.append(spot)
            }
        }
        return spotList
    }
    
    
}

// MARK: - Private Methods

private extension HomeContent {
// Dans Spot <--
    func clearSpots(context: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        Spot.removeAllSpots(context: context) { (success) in
            if success {
                ImageManager.imageCache.removeAllObjects()
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func getUsedCategories() {
        usedCategories = []
        for category in Spot.Category.allCases {
            for spot in spots {
                guard let categoryString = spot.category else { return }
                if categoryString == category.rawValue {
                    usedCategories.append(categoryString)
                    break
                }
            }
        }
    }
    
}
