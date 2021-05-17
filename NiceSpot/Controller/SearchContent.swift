//
//  SearchContent.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 05/02/2021.
//

import Foundation
import CoreData

class SearchContent: ObservableObject {
    private let context: NSManagedObjectContext
    @Published var spots: [Spot] = []
    @Published var searchText: String = "" {
        didSet {
            perform()
        }
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func perform() {
        guard searchText != "" else {
            spots = []
            return
        }
        Spot.searchSpots(context: context, titleContains: searchText) { [unowned self] (spots) in
            self.spots = spots
        }
    }
}
