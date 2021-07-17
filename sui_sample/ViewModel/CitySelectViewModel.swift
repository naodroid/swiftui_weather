//
//  CitySelectViewModel.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/06.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

enum CitySelectTab: Int {
    case cityList
    case map
}

@MainActor
final class CitySelectViewModel: ObservableObject {
    //repositories
    private let listRepository: CityListRepository
    private let locationRepository: LocationRepository
    
    //view state
    @Published
    private(set) var selectedTab: CitySelectTab = .cityList
    
    @Published
    private(set) var cities: [City] = []
    
    @Published
    private(set) var locating = false
    
    @Published
    private(set) var location: CLLocation?  = nil
    
    @Published
    private(set) var pin: CLLocationCoordinate2D? = nil
    
    private let cancellableBag = CancellableBag()
    
    /// creation
    init(listRepository: CityListRepository, locationRepository: LocationRepository) {
        self.listRepository = listRepository
        self.locationRepository = locationRepository
    }
    
    // MARK: exponed methods
    /// setup, call at onAppear
    func setup() {
        async {
            await self.listRepository.setup()
            for try await list in self.listRepository.cityList {
                self.cities = list.cities
            }
        }
    }
    /// call at onDisappear
    func cancel() {
        async {
            await self.listRepository.cancel()
        }
        self.locating = false
        self.locationRepository.cancel()
        self.cancellableBag.cancel()
    }
    
    /// filter cities with keywoard
    func filter(by keyword: String) {
        async {
            await self.listRepository.filter(by: keyword)
        }
    }
    
    func changeTab(to tab: CitySelectTab) {
        self.selectedTab = tab
    }
    
    //
    func fetchLocation() {
        async {
            self.locating = true
            do {
                let loc = try await self.locationRepository.fetchCurrentLocation()
                self.location = loc
                self.pin = loc.coordinate
            } catch {
                //TODO: error handling
            }
            self.locating = false
        }
    }
    
    func setPin(pos: CLLocationCoordinate2D) {
        self.pin = pos
    }
}

