//
//  Config.swift
//  sui_sample
//
//  Created by naodroid　尚嗣 on 2019/06/09.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation

/// read from Config.plist
///
struct Config {
    private init() {
    }
    static var apiKey: String? {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist") else {
            return nil
        }
        let dict = NSDictionary(contentsOfFile: path)
        return dict?["OpenWeatherApiKey"] as? String
    }
}
