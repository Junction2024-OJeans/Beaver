//
//  MainView.swift
//  Beaver
//
//  Created by Jia Jang on 8/11/24.
//

import SwiftUI
import MapKit

struct MainView: View {
    @StateObject var locationManager = LocationManager()
    
    @State private var dummyData: [PotholeData] = [
        PotholeData(
            id: "PH001",
            coordinates: CLLocationCoordinate2D(latitude: 36.0190, longitude: 129.3243),
            province: "경상북도",
            region: "포항시",
            town: "남구",
            image: Image(systemName: "circle.fill"),
            myDangerLevel: .medium,
            averageDangerLevel: .medium
        ),
        PotholeData(
            id: "PH002",
            coordinates: CLLocationCoordinate2D(latitude: 36.0185, longitude: 129.3238),
            province: "경상북도",
            region: "포항시",
            town: "남구",
            image: Image(systemName: "circle.fill"),
            myDangerLevel: .high,
            averageDangerLevel: .medium
        ),
        PotholeData(
            id: "PH003",
            coordinates: CLLocationCoordinate2D(latitude: 36.0195, longitude: 129.3250),
            province: "경상북도",
            region: "포항시",
            town: "남구",
            image: Image(systemName: "circle.fill"),
            myDangerLevel: .low,
            averageDangerLevel: .low
        ),
        PotholeData(
            id: "PH004",
            coordinates: CLLocationCoordinate2D(latitude: 36.0180, longitude: 129.3235),
            province: "경상북도",
            region: "포항시",
            town: "남구",
            image: Image(systemName: "circle.fill"),
            myDangerLevel: .medium,
            averageDangerLevel: .high
        ),
        PotholeData(
            id: "PH005",
            coordinates: CLLocationCoordinate2D(latitude: 36.0188, longitude: 129.3248),
            province: "경상북도",
            region: "포항시",
            town: "남구",
            image: Image(systemName: "circle.fill"),
            myDangerLevel: .high,
            averageDangerLevel: .high
        )
    ]
    
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.0190, longitude: 129.3243),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    ))
    
    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(dummyData, id: \.id) { pothole in
                Annotation("", coordinate: pothole.coordinates) {
                    Image(pothole.averageDangerLevel?.rawValue ?? DangerLevel.low.rawValue)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    MainView()
}
