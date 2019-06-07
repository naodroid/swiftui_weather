//
//  Weather5DayViewModel.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/07.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

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
class Weather5DayViewModel: BindableObject {
    //override
    let didChange = PassthroughSubject<Weather5DayViewModel, Never>()
    //public
    let searchType: WeatherSearchType
    fileprivate(set) var loading: Bool = false
    fileprivate(set) var dailyList : [DailyWeather] = []
    //private
    private var cancellable: Cancellable?
    private let repository: WeatherRepository

    //
    init(searchType: WeatherSearchType, repository: WeatherRepository) {
        self.searchType = searchType
        self.repository = repository
    }
    deinit {
        self.cancellable?.cancel()
    }
    //
    func fetch() {
        if !self.dailyList.isEmpty || self.loading {
            return
        }
        self.loading = true
        self.notifyUpdate()

        let api: Weather5DayPublisher
        switch self.searchType {
        case .city(let city):
            api = self.repository.fetch5DayForecast(city: city)
        case .location(let lat, let lon):
            api = self.repository.fetch5DayForecast(lat: lat, lon: lon)
        }

        self.cancellable = api
            .map(convert)
            .onMainThread()
            .sink(receiveCompletion: {[weak self] (_) in
                guard let s = self else { print("RET!!");return }
                s.loading = false
                s.notifyUpdate()
            }, receiveValue: {[weak self] (w) in
                guard let s = self else { print("RET!!");return }
                s.loading = false
                s.dailyList = w
                s.notifyUpdate()
            })
    }
    func cancel() {
        self.loading = false
        self.cancellable?.cancel()
        self.cancellable = nil
    }
}
