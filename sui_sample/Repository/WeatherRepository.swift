//
//  WeatherRepository.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/07.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation

enum WeatherError: Error {
    case requestFailed
    case parseError
}

//--------------------------------------------
protocol WeatherRepository {
    func fetch5DayForecast(city: City) async throws -> Weather5Day
    func fetch5DayForecast(lat: Double, lon: Double) async throws -> Weather5Day
    func clear()
}

//--------------------------------------------
// MARK:
/// Implementation
final class WeatherRepositoryImpl: WeatherRepository {
    ///
    func fetch5DayForecast(city: City) async throws -> Weather5Day {
        guard let key = Config.apiKey else {
            //fetch from resource, forced
            print("Use Local resource.")
            print("If you want to use Network-API, please rename Copfig-sample.plist to Copfig.plist, and write your api key.")
            return try await resourceRequestJson(fileName: "5day_sample.json")
        }
        var url = "https://api.openweathermap.org/data/2.5/forecast"
        url += "?id=\(city.id)"
        url += "&appid=\(key)"
        url += "&units=metrics"
        return try await httpRequestJson(url: url, keyStrategy: .convertFromSnakeCase)
        //fetch from resource
        //return resourceRequestJson(fileName: "5day_sample.json")
    }
    func fetch5DayForecast(lat: Double, lon: Double) async throws -> Weather5Day {
        guard let key = Config.apiKey else {
            //fetch from resource, forced
            print("Use Local resource.")
            print("If you want to use Network-API, please rename Copfig-sample.plist to Copfig.plist, and write your api key.")
            return try await resourceRequestJson(fileName: "5day_sample.json")
        }
        var url = "https://api.openweathermap.org/data/2.5/forecast"
        url += String(format: "?lat=%.6f&lon=%.6f",lat, lon)
        url += "&appid=\(key)"
        url += "&units=metrics"
        
        return try await httpRequestJson(url: url, keyStrategy: .convertFromSnakeCase)
        //fetch from resource
        //return resourceRequestJson(fileName: "5day_sample.json")
    }
    
    func clear() {
    }
}








