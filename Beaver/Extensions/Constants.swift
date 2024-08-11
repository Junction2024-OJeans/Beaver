//
//  Constants.swift
//  Beaver
//
//  Created by 지영 on 8/11/24.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    
    static let hico = CLLocationCoordinate2D(
        latitude: 35.83826064721534,
        longitude: 129.28788538371916
    )
    
}

extension MKCoordinateRegion {
    
    static let cameraBoundary = MKCoordinateRegion(
        center: .hico,
        latitudinalMeters: 4000,
        longitudinalMeters: 4000
    )
    
}

extension MapCameraPosition {
    
    static let defaultPosition: Self = .camera(.init(centerCoordinate: .hico, distance: 1500))
    
}
