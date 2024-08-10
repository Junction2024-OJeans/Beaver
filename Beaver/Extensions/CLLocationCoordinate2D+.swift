//
//  CLLocationCoordinate2D+.swift
//  Beaver
//
//  Created by Hyun Lee on 8/11/24.
//

import Foundation
import CoreLocation


extension CLLocationCoordinate2D{
    static func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}

extension CLLocationCoordinate2D: Equatable{
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        if lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude{
            return true
        }else{
            return false
        }
    }
}
