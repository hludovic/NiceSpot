//
//  CDSpot.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 09/01/2021.
//

import CloudKit
import CoreLocation.CLLocation
import CoreData


//extension SpotCD {
//
//    static func create (id: UUID, title: String, information: String, location: CLLocation, category: Spot.Category, context: NSManagedObjectContext) {
//        let newSpot = SpotCD(context: context)
//        newSpot.id = id
//        newSpot.title = title
//        newSpot.information = information
//        newSpot.category = category.rawValue
//        newSpot.latitude = location.coordinate.latitude
//        newSpot.longitude = location.coordinate.longitude
//        //TODO: Save context
//    }
//    
//    static func remove (id: UUID, context: NSManagedObjectContext) -> Bool {
//        true
//    }
//    
//    static func savePicture(id: UUID, picture: Data) {
//        //TODO: Add a picture une the spot
//    }
//    
//}
