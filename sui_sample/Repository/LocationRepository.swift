//
//  LocationRepository.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/06.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationError: Error {
    case serviceNotAvailable
    case permissionDenied
    case canceled
}

protocol LocationRepository {
    func fetchCurrentLocation() async throws -> CLLocation
    func cancel()
}

/// impl
typealias LocationContinuation = CheckedContinuation<CLLocation, Error>

final class LocationRepositoryImpl: NSObject, LocationRepository, CLLocationManagerDelegate, ObservableObject {
    //other
    private var locationManager: CLLocationManager?
    private var continuation: LocationContinuation?
    //
    func fetchCurrentLocation() async throws -> CLLocation {
        let mn = self.locationManager ?? CLLocationManager()
        self.locationManager = mn
        mn.delegate = self
        if let c = self.continuation {
            c.resume(throwing: LocationError.canceled)
            self.continuation = nil
        }
        return try await withCheckedThrowingContinuation { (continuation:  LocationContinuation) in
            self.continuation = continuation
            mn.requestLocation()
        }
    }
    
    func cancel() {
        self.locationManager?.stopUpdatingLocation()
        self.locationManager = nil
        if let c = self.continuation {
            c.resume(throwing: LocationError.canceled)
            self.continuation = nil
        }
    }
    // MARK:  Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            //If using a LocationButton, this code will not run.
            self.locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            self.continuation?.resume(throwing: LocationError.permissionDenied)
            self.continuation = nil
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
        self.continuation?.resume(returning: location)
        self.continuation = nil
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.continuation?.resume(throwing: error)
        self.continuation = nil
    }
}



