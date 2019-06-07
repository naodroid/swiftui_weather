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
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let sea_level: Double
    let grnd_level: Double
    let humidity: Double
    let temp_kf: Double
}
struct Weather: Codable {
    let id: Int64
    let main: String
    let description: String
    let icon: String
}
struct Wind: Codable {
    let speed: Double
    let degree: Double
}

