//
//  ForecastView.swift
//  sui_sample
//
//  Created by nadroid on 2019/06/04.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

//same structore as AreaListView
struct ForecastView: View {
    let area: Area

    var body: some View {
        ForecastViewInner().environmentObject(ForecastViewModel(area: area))
    }
}

private struct ForecastViewInner: View {
    @EnvironmentObject var viewModel: ForecastViewModel

    var body: some View {
        //we can't use let assignment in view-building
        //so assign variables before it.
        //and we can't use complex-if-condition in view-building
        let forecasts: [Forecast] = self.viewModel.weather?.forecasts ?? []
        let hasForecast = forecasts.count > 0
        return VStack {
            if hasForecast {
                List(forecasts, rowContent: {(item) in
                    ForecastRow(forecast: item)
                })
            } else {
                Text("Loading")
            }
        }
        .navigationBarTitle(Text(self.viewModel.area.name), displayMode: .large)
        .onAppear { self.viewModel.fetch() }
        .onDisappear { self.viewModel.cancel() }
    }
}

private struct ForecastRow: View {
    let forecast: Forecast

    var body: some View {
        let url = self.forecast.image?.url ?? ""
        return HStack {
            NetworkImage(url: url, placeHolder: "blank")
            Text(self.forecast.dateLabel ?? "today")
        }
    }
}

extension Forecast: Identifiable {
    var id: String {
        self.dateLabel ?? "today"
    }
}
