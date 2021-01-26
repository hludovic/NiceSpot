//
//  NiceSpotError.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 25/01/2021.
//

import Foundation

enum NiceSpotError: Error {
    case failFetchingSpots
    case failLoadingPictureData
    case wrongUrlSessionStatus
}
