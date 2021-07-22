//
//  Weather5DayViewModel.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/07.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import SwiftUI

enum WeatherSearchType {
    case city(City)
    case location(lat: Double, lon: Double)
}

struct DailyWeather: Identifiable {
    var id: String {
        return date
    }
    let date: String  //"MM/DD"
    fileprivate(set) var hourlyList: [HourlyWeather] = []
}
struct HourlyWeather {
    let hhmm: String
    let forecasts: Forecast
}
private func convert(_ base: Weather5Day) -> [DailyWeather] {
    //grouped by day
    var result: [DailyWeather] = []
    var lastDateText = ""
    let formatter = DateFormatter()
    formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: nil)!
    let hourFormatter = DateFormatter()
    hourFormatter.dateFormat = "HH:mm"
    
    for w in base.list {
        let date = Date(timeIntervalSince1970: TimeInterval(w.dt))
        let txt = formatter.string(from: date)
        if txt != lastDateText {
            lastDateText = txt
            result.append(DailyWeather(date: txt))
        }
        let hhmm = hourFormatter.string(from: date)
        result[result.count - 1].hourlyList
            .append(HourlyWeather(hhmm: hhmm, forecasts: w))
    }
    return result
}



//----------------------------------
// MARK:  Main Code
/// view model for 5day  forecast
@MainActor
class Weather5DayViewModel: ObservableObject {
    //public
    let searchType: WeatherSearchType
    @Published
    fileprivate(set) var loading: Bool = false
    @Published
    fileprivate(set) var dailyList : [DailyWeather] = []
    //private
    private let repository: WeatherRepository
    private var task: Task<Void, Never>?
    
    //
    init(searchType: WeatherSearchType, repository: WeatherRepository) {
        self.searchType = searchType
        self.repository = repository
    }
    deinit {
        self.task?.cancel()
    }
    //
    func fetch() {
        if !self.dailyList.isEmpty || self.loading {
            return
        }
        self.loading = true
        
        self.task = Task<Void, Never> {
            do {
                let result: Weather5Day
                switch self.searchType {
                case .city(let city):
                    result = try await self.repository.fetch5DayForecast(city: city)
                case .location(let lat, let lon):
                    result = try await self.repository.fetch5DayForecast(lat: lat, lon: lon)
                }
                self.dailyList = convert(result)
            } catch {
                //TODO: Error notification
            }
            self.loading = false
        }
    }
    func cancel() {
        self.loading = false
        self.task?.cancel()
    }
}
