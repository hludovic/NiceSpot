//
//  Spot.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 25/01/2021.
//

import Foundation
import CoreData

extension Spot {
    // MARK: - Methods
    static func getSpot(spotId: String, context: NSManagedObjectContext, completion: @escaping (Spot?) -> Void) {
        let fetch = NSFetchRequest<Spot>(entityName: "Spot")
        fetch.predicate = NSPredicate(format: "id == %@", spotId)
        guard let result = try? context.fetch(fetch) else { return completion(nil) }
        guard let spot = result.first else { return completion(nil) }
        completion(spot)
    }

    static func allSpots(context: NSManagedObjectContext, completion: @escaping ([Spot]) -> Void ) {
        let request: NSFetchRequest<Spot> = Spot.fetchRequest()
        if let result = try? context.fetch(request) {
            completion(result)
        } else { completion([]) }
    }

    // MARK: - Enum
    enum Category: String {
        case unknown = "Unknown"
        case beach = "Beach"
        case mountain = "Mountain"
        case river = "River"
    }

    enum Municipality: String {
        case unknown = "Unknown"
        case deshaie = "Deshaie"
        case sainterose = "Sainte-Rose"
        case lamentin = "Lamentin"
        case SaintClaude = "Saint-Claude"
    }
}

struct SpotLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
