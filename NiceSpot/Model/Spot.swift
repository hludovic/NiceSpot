//
//  Spot.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 25/01/2021.
//

import Foundation
import CoreData

// MARK: - Static Methods
extension Spot {

    static func getSpot(spotId: String, context: NSManagedObjectContext, completion: @escaping (Spot?) -> Void) {
        let fetch = NSFetchRequest<Spot>(entityName: "Spot")
        fetch.predicate = NSPredicate(format: "id == %@", spotId)
        guard let result = try? context.fetch(fetch) else { return completion(nil) }
        guard let spot = result.first else { return completion(nil) }
        completion(spot)
    }

    static func getSpots(context: NSManagedObjectContext, completion: @escaping ([Spot]) -> Void ) {
        let request: NSFetchRequest<Spot> = Spot.fetchRequest()
        if let result = try? context.fetch(request) {
            completion(result)
        } else { completion([]) }
    }

    static func saveFetchedSpots(context: NSManagedObjectContext, fetchedSpots: [Fetched], completion: @escaping (Bool) -> Void) {
        for fetchedSpot in fetchedSpots {
            let spot = Spot(context: context)
            spot.id = fetchedSpot.recordID.recordName
            spot.title = fetchedSpot.title
            spot.detail = fetchedSpot.detail
            spot.category = fetchedSpot.category
            spot.municipality = fetchedSpot.municipality
            spot.imageName = fetchedSpot.pictureName
            spot.latitude = fetchedSpot.location.coordinate.latitude
            spot.longitude = fetchedSpot.location.coordinate.longitude
            do {
                try context.save()
            } catch {
                completion(false)
            }
        }
        completion(true)
    }

    static func fetchSpots(completion: @escaping ([Fetched]?) -> Void) {
        let publicDB: CKDatabase = CKContainer(identifier: "iCloud.fr.hludovic.container1").publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let querry = CKQuery(recordType: "SpotCK", predicate: predicate)
        querry.sortDescriptors = [sort]
        let operation = CKQueryOperation(query: querry)
        operation.desiredKeys = ["title", "detail", "category", "location", "municipality", "pictureName"]
        var newSpotsCK: [Fetched] = []
        operation.recordFetchedBlock = { record in
            guard
                let title = record["title"] as? String,
                let detail = record["detail"] as? String,
                let category = record["category"] as? String,
                let location = record["location"] as? CLLocation,
                let pictureName = record["pictureName"] as? String,
                let municipality = record["municipality"] as? String
            else { return completion(nil) }
            let spotFetched = Fetched(recordID: record.recordID, title: title, detail: detail, category: category, location: location, pictureName: pictureName, municipality: municipality)
            newSpotsCK.append(spotFetched)
        }
        operation.queryCompletionBlock = { (cursor, error) in
            guard error == nil else { return completion(nil) }
            completion(newSpotsCK)
        }
        publicDB.add(operation)
    }

}

// MARK: - Enum
extension Spot {

    enum Category: String {
        case unknown = "Unknown"
        case beach = "Beach"
        case mountain = "Mountain"
        case river = "River"
    }

    enum Municipality: String, CaseIterable {
        case basseTerre = "Basse-Terre"
        case anseBertrand = "Anse-Bertrand"
        case baieMahault = "Baie-Mahault"
        case baillif = "Baillif"
        case bouillante = "Bouillante"
        case capesterreBelleEau = "Capesterre-Belle-Eau"
        case capesterreDeMarieGalante = "Capesterre-de-Marie-Galante"
        case deshaies = "Deshaies"
        case gourbeyre = "Gourbeyre"
        case goyave = "Goyave"
        case grandBourg = "Grand-Bourg"
        case desirade = "La Désirade"
        case lamentin = "Lamentin"
        case leGosier = "Le Gosier"
        case leMoule = "Le Moule"
        case lesAbymes = "Les Abymes"
        case morneALEau = "Morne-à-l'Eau"
        case petitBourg = "Petit-Bourg"
        case petitCanal = "Petit-Canal"
        case pointeNoire = "Pointe-Noire"
        case pointeAPitre = "Pointe-à-Pitre"
        case portLouis = "Port-Louis"
        case saintClaude = "Saint-Claude"
        case saintFrancois = "Saint-François"
        case saintLouis = "Saint-Louis"
        case sainteAnne = "Sainte-Anne"
        case sainteRose = "Sainte-Rose"
        case terreDeBas = "Terre-de-Bas"
        case terreDeHaut = "Terre-de-Haut"
        case troisRivieres = "Trois-Rivières"
        case vieuxFort = "Vieux-Fort"
        case vieuxHabitants = "Vieux-Habitants"
    }

}

// MARK: - Nested Struct
extension Spot {
    
    struct Fetched {
        let recordID: CKRecord.ID
        let title: String
        let detail: String
        let category: String
        let location: CLLocation
        var pictureName: String
        var municipality: String
    }
    
    struct Location: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }

}


