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
    @Published private(set) var errorMessage: String = ""
    @Published private(set) var loadingIndicator: String = ""

    // MARK: - Public Methods
    func loadSpots(context: NSManagedObjectContext) {
        let request: NSFetchRequest<Spot> = Spot.fetchRequest()
        if let result = try? context.fetch(request) {
            self.spots = result
        } else { self.spots = [] }
    }

    func refreshSpots (context: NSManagedObjectContext) {
        loadingIndicator = "Syncing..."
        Spot.fetchSpots { [unowned self] (result) in
            switch result {
            case .success(let fetchedSpots):
                self.clearSpots(context: context) { [unowned self] (cleared) in
                    if cleared {
                        Spot.saveFetchedSpots(context: context, fetchedSpots: fetchedSpots) { [unowned self] (saved) in
                            if saved {
                                Spot.getSpots(context: context) { [unowned self] (result) in
                                    DispatchQueue.main.async {
                                        self.spots = result
                                        loadingIndicator = ""
                                    }
                                }
                            } else {
                                self.errorMessage = "ERROR: Not converted"
                                loadingIndicator = ""
                            }
                        }
                    } else {
                        self.errorMessage = "ERROR: Not cleared"
                        showAlert = true
                        loadingIndicator = ""
                    }
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "ERROR: Not fetched \(error.localizedDescription)"
                    showAlert = true
                    loadingIndicator = ""
                }
            }
        }
    }

}

// MARK: - Private Methods
private extension HomeContent {

    func clearSpots(context: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Spot.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            completion(true)
        } catch {
            completion(false)
        }
        NiceSpotApp.imageCache.removeAllObjects()
    }

}
