//
//  LocationManager.swift
//  Beaver
//
//  Created by Hyun Lee on 8/11/24.
//

import Foundation
import CoreLocation


class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject{
    private var manager = CLLocationManager()
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var accuracy: Double = 0
    
    func getLocationPermission(){ //앱 실행 할때 필요
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.startUpdatingLocation()
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
            
        case .restricted:
            print("Location restricted")
            
        case .denied:
            print("Location denied")
            
        case .authorizedAlways:
            print("Location authorizedAlways")
            currentLocation = manager.location?.coordinate
            
        case .authorizedWhenInUse:
            print("Location authorized when in use")
            
            
        @unknown default:
            print("Location service disabled")
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location.coordinate
            accuracy = location.horizontalAccuracy
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get the user location: \(error.localizedDescription)")
    }
}
