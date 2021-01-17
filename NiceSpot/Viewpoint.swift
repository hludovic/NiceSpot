//
//  Viewpoint.swift
//  Guadeloupe
//
//  Created by Ludovic HENRY on 08/11/2020.
//

import SwiftUI

struct Viewpoint: Hashable, Codable, Identifiable {
    var id: Int
    var category: String
    var title: String
    var description: String
    var longitude: Double
    var latitude: Double
    var municipality: Municipality
    var image: String
    var isActive: Bool
    
    enum Municipality: String, CaseIterable, Codable, Hashable {
        case deshaie = "Deshaie"
        case sainterose = "Sainte-Rose"
        case lamentin = "Lamentin"
    }
}
