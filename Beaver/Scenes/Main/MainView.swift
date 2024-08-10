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
    @StateObject var warningManager = WarningManager()
    @StateObject var potHoleDataManager = PotHoleDataManager()
    
    @State var searchText = ""
    @State var coordinates: Coordinates?
    
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
        NavigationStack {
            ZStack{
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
                VStack{
                    SearchBarView(searchText: $searchText)
                        .padding(.top, 24)
                    buttonStack
                }
            }
            .toolbar(.hidden)
            .navigationDestination(for: String.self){ destination in
                if destination == "report"{
                    ReportView(coordinates: $coordinates)
                }
            }
            .onAppear {
                print("auth")
                Task{
                    await warningManager.checkNotificationPermission()
                }
                locationManager.getLocationPermission()
                potHoleDataManager.loadCSV()
            }
            .onChange(of: locationManager.currentLocation){
                if let currentLocation = locationManager.currentLocation{
                    for potholeCoordinate in potHoleDataManager.hicoPotHoles {
                        warningManager.distanceToPotHole = CLLocationCoordinate2D.distance(from: currentLocation, to: potholeCoordinate.coordinates)
                        print("distance: \(warningManager.distanceToPotHole)")
                        if warningManager.showAlert{
                            if warningManager.distanceToPotHole <= 30 && warningManager.distanceToPotHole > 20{
                                warningManager.playWarningAudio(warningType: .threeHundred)
                                Task{
                                    await warningManager.notifyUser(title: "Beaver", content: WarningType.threeHundred.backgroundWarningContent)
                                }
                            }else if warningManager.distanceToPotHole <= 20 && warningManager.distanceToPotHole > 10{
                                warningManager.playWarningAudio(warningType: .hundred)
                                Task{
                                    await warningManager.notifyUser(title: "Beaver", content: WarningType.hundred.backgroundWarningContent)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension MainView{
    var buttonStack: some View{
        VStack(alignment: .trailing){
            HStack{
                Spacer()
                VStack{
                    NavigationLink(value: "report"){
                        Image("icon_report")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65)
                    }
                    Button{
                        warningManager.showAlert.toggle()
                    }label:{
                        Image("icon_start")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65)
                    }
                    Spacer()
                    Button{
                        //다시 현재 위치로
                    }label:{
                        Image("icon_currentLocation")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65)
                    }
                }.padding(.trailing, 24)
            }
        }
    }
}

#Preview {
    MainView()
}
