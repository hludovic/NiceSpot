//
//  Spot+CoreDataProperties.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 17/01/2021.
//
//

import Foundation
import CoreData


extension Spot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Spot> {
        return NSFetchRequest<Spot>(entityName: "Spot")
    }

    @NSManaged public var category: String
    var categoryStatus: Category {
        set { category = newValue.rawValue }
        get { Category(rawValue: category) ?? .unknown }
    }
    @NSManaged public var detail: String
    @NSManaged public var id: UUID
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var municipality: String
    var spotMunicipality: Municipality {
        get { Municipality(rawValue: municipality) ?? .unknown }
        set { municipality = newValue.rawValue }
    }
    @NSManaged public var pictureData: Data?
    @NSManaged public var pictureName: String
    @NSManaged public var title: String
    

}

extension Spot : Identifiable {

}

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
}

