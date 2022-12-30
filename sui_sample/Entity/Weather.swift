//
//  Weather.swift
//  sui_sample
//
//  Created by nadroid on 2019/06/04.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation

// for open weather
struct Weather5Day: Codable {
    let list: [Forecast]
}
struct Forecast: Codable {
    let dt: Int64
    let main: Detail
    let weather: [Weather] //this is array, but containts 1 element.
}
struct Detail: Codable {
    let temp: Double
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Double?
    let seaLevel: Double?
    let grndLevel: Double?
    let humidity: Double?
    let tempKf: Double?
}
struct Weather: Codable {
    let isWeatherKit: Bool
    let id: Int64
    let main: String
    let description: String
    let icon: String
    
    init(isWeatherKit: Bool,
         id: Int64,
         main: String,
         description: String,
         icon: String) {
        self.isWeatherKit = isWeatherKit
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isWeatherKit = false
        self.id = try container.decode(Int64.self, forKey: .id)
        self.main = try container.decode(String.self, forKey: .main)
        self.description = try container.decode(String.self, forKey: .description)
        self.icon = try container.decode(String.self, forKey: .icon)
    }
}
struct Wind: Codable {
    let speed: Double
    let degree: Double
}

