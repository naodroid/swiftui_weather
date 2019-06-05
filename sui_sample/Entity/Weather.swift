//
//  Weather.swift
//  sui_sample
//
//  Created by nadroid on 2019/06/04.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let forecasts: [Forecast]
}
struct Forecast: Codable {
    let dateLabel: String?
    let image: IconImage?
}
struct IconImage: Codable {
    let width: Double
    let height: Double
    let url: String
    let title: String
}


