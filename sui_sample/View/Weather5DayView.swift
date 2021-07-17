//
//  Weather5DayView.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/07.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import SwiftUI

/// show 5day weatehr from open weather
struct Weather5DayFragment: View {
    let searchType: WeatherSearchType
    
    init(city: City) {
        self.searchType = WeatherSearchType.city(city)
    }
    init(lat: Double, lon: Double) {
        self.searchType = WeatherSearchType.location(lat: lat, lon: lon)
    }
    
    var body: some View {
        let repository = WeatherRepositoryImpl()
        let viewModel = Weather5DayViewModel(searchType: searchType,
                                             repository: repository)
        return Weather5DayView().environmentObject(viewModel)
            .onAppear { viewModel.fetch() }
        //in navigation, onDisappear won't be called.
        //Because [NavigationButton] keeps this view
            .onDisappear { viewModel.cancel() }
    }
}

private struct Weather5DayView: View {
    @EnvironmentObject var viewModel: Weather5DayViewModel
    @EnvironmentObject var theme: ColorTheme
    
    private var forecasts: [DailyWeather] { self.viewModel.dailyList }
    private var hasForecast: Bool { self.forecasts.count > 0 }
    
    var navigationTitle: String {
        switch self.viewModel.searchType {
        case .city(let city): return city.name
        case .location(let lat, let lon): return String.init(format: "%.3f,%.3f", lat, lon)
        }
    }
    
    var body: some View {
        VStack {
            if hasForecast {
                List(self.forecasts, rowContent: {(item) in
                    DailyWeatherRow(item: item)
                })
            } else {
                Text("Loading")
            }
        }
        .navigationBarTitle(Text(self.navigationTitle), displayMode: .large)
    }
}

private struct DailyWeatherRow: View {
    let item: DailyWeather
    @EnvironmentObject var theme: ColorTheme
    
    var list: [HourlyWeather] {
        return item.hourlyList
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.date)
                .padding(
                    EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0)
                )
            ScrollView(
                Axis.Set.horizontal,
                showsIndicators: false) {
                HStack {
                    ForEach(self.list) { (item) in
                        VStack {
                            AsyncImage(url: URL(string: "https://openweathermap.org/img/w/\(item.forecasts.weather[0].icon).png"))
                            Text(item.hhmm)
                                .font(.footnote)
                        }
                        .frame(width: CGFloat(60))
                    }
                }
            }
        }
        .padding(.all, 4)
        .frame(height: 120)
        .background(self.theme.background)
        .shadow(radius: 3)
        .padding(.all, 4)
    }
}
extension HourlyWeather: Identifiable {
    var id: String {
        return self.hhmm
    }
}

extension Forecast: Identifiable {
    var id: Int64 {
        self.dt
    }
}
