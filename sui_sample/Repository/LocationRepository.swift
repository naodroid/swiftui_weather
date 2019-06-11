//
//  LocationRepository.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/06.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

enum LocationError: Error {
    case serviceNotAvailable
    case permissionDenied
}

protocol LocationRepository {
    var location: AnyPublisher<CLLocation, Never> { get }
    var error: AnyPublisher<LocationError, Never> { get }
    func startMeasuring()
    func cancel()
}

/// impl
final class LocationRepositoryImpl: NSObject, LocationRepository, CLLocationManagerDelegate {
    //data
    @WithPassthrough var location: AnyPublisher<CLLocation, Never>
    @WithPassthrough var error: AnyPublisher<LocationError, Never>

    //other
    private var locationManager: CLLocationManager?

    //
    func startMeasuring() {
        if self.locationManager != nil {
            return
        }
        if !CLLocationManager.locationServicesEnabled() {
            self.$error.set(LocationError.serviceNotAvailable)
            return
        }

        let mn = CLLocationManager()
        self.locationManager = mn
        mn.delegate = self
        mn.startUpdatingLocation()
    }

    func cancel() {
        self.locationManager?.stopUpdatingLocation()
        self.locationManager = nil
    }
    // MARK:  Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self.locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            self.$error.set(LocationError.permissionDenied)
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        self.$location.set(location)
    }
}



