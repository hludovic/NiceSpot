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

    static func getSpots(context: NSManagedObjectContext, completion: @escaping ([Spot]) -> Void ) {
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

struct SpotLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
