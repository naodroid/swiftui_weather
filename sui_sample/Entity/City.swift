//
//  City.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/06.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import SwiftUI

/// open weather city data
/// sample json
/// [{"country": "UA", "id": 707860, "coord": {"lat": 44.549999, "lon": 34.283333}, "name": "Hurzuf"}]


struct City: Codable, Equatable, Identifiable {
    let id: Int64
    let name: String
    let country: String
    let coord: Coord
}
struct Coord: Codable, Equatable {
    let lat: Double
    let lon: Double
}
