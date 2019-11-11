//
//  MapView.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/06.
//  Copyright © 2019 naodroid. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    let loc: CLLocation?
    let pin: CLLocationCoordinate2D?
    let onTap: ((CLLocationCoordinate2D) -> Void)?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView(frame: .zero)
        context.coordinator.addGesture(map: map)
        map.isZoomEnabled = true
        return map
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        
        let coordinator = context.coordinator
        if let loc = self.loc, loc != coordinator.lastCenterLocation {
            let coordinate = loc.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            view.setRegion(region, animated: true)
        }
        coordinator.lastCenterLocation = self.loc
        //
        if let loc = self.pin, loc != coordinator.lastPinLocation {
            for a in view.annotations {
                view.removeAnnotation(a)
            }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = loc
            view.addAnnotation(annotation)
        }
        coordinator.lastPinLocation = self.pin
    }
    class Coordinator: NSObject {
        var parent: MapView
        var lastCenterLocation: CLLocation? = nil
        var lastPinLocation: CLLocationCoordinate2D? = nil
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        func addGesture(map: MKMapView) {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapMap(_:)))
            map.addGestureRecognizer(gesture)
        }
        @objc func didTapMap(_ sender: UITapGestureRecognizer) {
            guard let map = sender.view as? MKMapView else {
                return
            }
            let point = sender.location(in: map)
            let pos = map.convert(point, toCoordinateFrom: map)
            self.parent.onTap?(pos)
        }
    }
}
extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
    }
}
