//
//  WeatherRepository.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/07.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import Combine


enum WeatherError: Error {
    case requestFailed
    case parseError
}
typealias Weather5DayPublisher = AnyPublisher<Weather5Day, Error>

//--------------------------------------------
protocol WeatherRepository {
    func fetch5DayForecast(city: City)  -> Weather5DayPublisher
    func fetch5DayForecast(lat: Double, lon: Double) -> Weather5DayPublisher
    func clear()
}

//--------------------------------------------
// MARK:
/// Implementation
final class WeatherRepositoryImpl: WeatherRepository {

    ///
    private let cancellableBag = CancellableBag()

    ///
    func fetch5DayForecast(city: City) -> Weather5DayPublisher {
        var url = "https://api.openweathermap.org/data/2.5/forecast"
        url += "?id=\(city.id)"
        url += "&appid=\(Constants.apiKey)"
        url += "&units=metrics"
        return httpRequestJson(url: url)
        //fetch from resource
        //return resourceRequestJson(fileName: "5day_sample.json")
    }
    func fetch5DayForecast(lat: Double, lon: Double) -> Weather5DayPublisher {
        var url = "https://api.openweathermap.org/data/2.5/forecast"
        url += String(format: "?lat=%.6f&lon=%.6f",lat, lon)
        url += "&appid=\(Constants.apiKey)"
        url += "&units=metrics"

        return httpRequestJson(url: url)
        //fetch from resource
        //return resourceRequestJson(fileName: "5day_sample.json")
    }

    func clear() {
        self.cancellableBag.cancel()
    }


}








