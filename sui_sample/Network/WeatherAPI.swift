//
//  WeatherAPI.swift
//  sui_sample
//
//  Created by nadroid on 2019/06/04.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import Combine


struct WeatherAPI {
    private init() {
    }
    static func fetch(areaId: String) -> WeatherPublisher {
        let url = "http://weather.livedoor.com/forecast/webservice/json/v1?city=\(areaId)"
        return httpRequestJson(url: url)
    }
}




