//
//  WeatherRepository.swift
//  sui_sample
//
//  Created by nadroid on 2019/06/04.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

//
class ForecastViewModel: BindableObject {
    //override
    let didChange = PassthroughSubject<ForecastViewModel, Never>()
    //public
    let area: Area
    fileprivate(set) var loading: Bool = false
    fileprivate(set) var weather: Weather? = nil
    //private
    private var cancellable: Cancellable?
    
    //
    init(area: Area) {
        self.area = area
    }
    //
    func fetch() {
        if self.weather != nil || self.loading {
            return
        }
        self.loading = true
        self.notifyUpdate()
        
        self.cancellable = WeatherAPI.fetch(areaId: self.area.id)
            .eraseToAnyPublisher()
            .sink(receiveValue: {[weak self] (w) in
                guard let s = self else { return }
                s.loading = false
                s.weather = w
                s.notifyUpdate()
            })
    }
    func cancel() {
        self.loading = false
        self.cancellable?.cancel()
        self.cancellable = nil
    }
}

