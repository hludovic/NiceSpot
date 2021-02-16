//
//  HomeContent.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 17/01/2021.
//

import Foundation
import CoreData

class HomeContent: ObservableObject {
    // MARK: - Properties
    
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
    
    func refreshSpots (context: NSManagedObjectContext, success: @escaping (Bool) -> Void) {
        loadingIndicator = "Syncing..."
        Spot.refreshSpots(context: context) { [unowned self] (refreshed) in
            guard refreshed else {
                DispatchQueue.main.async {
                    loadingIndicator = ""
                    errorMessage = "Error: Not refreshed"
                }
                return success(false)
            }
            Spot.getSpots(context: context) { [unowned self] (spots) in
                DispatchQueue.main.async {
                    self.spots = spots
                    self.getUsedCategories()
                    loadingIndicator = ""
                }
                return success(true)
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

// MARK: - Private Method

private extension HomeContent {
    
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
