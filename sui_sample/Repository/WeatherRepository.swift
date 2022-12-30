//
//  WeatherRepository.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/07.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import CoreLocation
import WeatherKit

// add aliases for convinience, because these have the same name as WeatherKit
private typealias MyWeather = sui_sample.Weather
private typealias MyForecast = sui_sample.Forecast


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


@available(iOS 16.0, *)
final class WeatherKitRepository: WeatherRepository {
    private lazy var service = WeatherService()
    //
    func fetch5DayForecast(city: City) async throws -> Weather5Day {
        return try await self.fetch5DayForecast(lat: city.coord.lat, lon: city.coord.lon)
    }
    func fetch5DayForecast(lat: Double, lon: Double) async throws -> Weather5Day {
        let loc = CLLocation(latitude: lat, longitude: lon)
        let cal = Calendar.current
        let startDate = Date()
        let endDate = cal.date(byAdding: .day, value: 5, to: startDate)!
        let query = WeatherQuery.daily(startDate: startDate, endDate: endDate)
        let weather = try await service.weather(for: loc, including: query)
        print(weather)
        let lists = weather.forecast.map(MyForecast.init(forecast:))
        return Weather5Day(list: lists)
    }
    
    func clear() {
    }
}

// MARK: Converting initializer
@available(iOS 16.0, *)
private extension MyForecast {
    init(forecast: DayWeather) {
        self.init(
            dt: Int64(forecast.date.timeIntervalSince1970),
            main: Detail(dayWeather: forecast),
            weather: [
                Weather(dayWeather: forecast)
            ]
        )
    }
}

@available(iOS 16.0, *)
private extension Detail {
    init(dayWeather: DayWeather) {
        let high = dayWeather.highTemperature.converted(to: UnitTemperature.celsius).value
        let low = dayWeather.highTemperature.converted(to: UnitTemperature.celsius).value
        self.init(temp: high,
                  tempMin: low,
                  tempMax: high,
                  pressure: nil,
                  seaLevel: nil,
                  grndLevel: nil,
                  humidity: nil,
                  tempKf: nil)
    }
}
@available(iOS 16.0, *)
private extension MyWeather {
    init(dayWeather: DayWeather) {
        self.init(isWeatherKit: true,
                  id: 0,
                  main: dayWeather.condition.description,
                  description: dayWeather.condition.description,
                  icon: dayWeather.symbolName
        )
    }
}
