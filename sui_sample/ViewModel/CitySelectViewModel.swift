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

final class CitySelectViewModel: BindableObject {
    //override
    let didChange = PassthroughSubject<CitySelectViewModel, Never>()

    //repositories
    private let listRepository: CityListRepository
    private let locationRepository: LocationRepository

    //view state
    private(set) var selectedTab: CitySelectTab = .cityList {
        didSet {
            self.notifyUpdate()
        }
    }

    private(set) var cities: [City] = [] {
        didSet {
            self.notifyUpdate()
        }
    }
    private(set) var location: CLLocation?  = nil {
        didSet {
            self.notifyUpdate()
        }
    }
    private(set) var pin: CLLocationCoordinate2D? = nil {
        didSet {
            self.notifyUpdate()
        }
    }



    private let cancellableBag = CancellableBag()

    /// creation
    init(listRepository: CityListRepository, locationRepository: LocationRepository) {
        self.listRepository = listRepository
        self.locationRepository = locationRepository
    }

    // MARK: exponed methods
    /// setup, call at onAppear
    func setup() {
        self.listRepository.setup()

        self.listRepository
            .cityList
            .map { $0.cities }
            .onMainThread()
            .receive(subscriber: Subscribers.Assign(object: self, keyPath: \.cities))

    }
    /// call at onDisappear
    func cancel() {
        self.listRepository.cancel()
        self.locationRepository.cancel()
        self.cancellableBag.cancel()
    }

    /// filter cities with keywoard
    func filter(by keyword: String) {
        self.listRepository.filter(by: keyword)
    }

    func changeTab(to tab: CitySelectTab) {
        self.selectedTab = tab
    }

    //
    func startLocating() {
        //measure once
        self.locationRepository.location
            .sink(receiveCompletion: { (e) in
                print("ERROR:\(e)")
            }) {[weak self] (loc) in
                guard let s = self else { return }
                s.location = loc
                s.pin = loc.coordinate
                s.locationRepository.cancel()
            }
            .cancel(by: self.cancellableBag)

        self.locationRepository.startMeasuring()
    }

    func setPin(pos: CLLocationCoordinate2D) {
        self.pin = pos
    }
}

