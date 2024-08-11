//
//  MainView.swift
//  Beaver
//
//  Created by Jia Jang on 8/11/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct MainView: View {
    @StateObject var locationManager = LocationManager()
    @StateObject var warningManager = WarningManager()
    @StateObject var potHoleDataManager = PotHoleDataManager()
    
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D.hico,
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    ))
    
    @State private var selectedPothole: PotholeData?
    @State private var showPotholeInfo = false
    @State private var searchText = ""
    @State var coordinates: Coordinates?
    
    @State private var isShowingImageA = true

    
    var body: some View {
        NavigationStack {
            ZStack{
                Map(position: $cameraPosition) {
                    Annotation("", coordinate: locationManager.currentLocation ?? .hico) {
                        Image("current")
                    }
                    
                    ForEach(potHoleDataManager.hicoPotHoles, id: \.id) { pothole in
                        Annotation("", coordinate: pothole.coordinates) {
                            Image(pothole.averageDangerLevel?.rawValue ?? DangerLevel.high.rawValue)
                                .resizable()
                                .scaledToFit()
                                .onTapGesture {
                                    selectedPothole = pothole
                                    showPotholeInfo = true
                                }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
                if warningManager.showAlert{
                    VStack{
                        if warningManager.distanceToPotHole > 30 {
                            Image("alert_before")
                                .resizable()
                                .scaledToFit()
                                .frame(width:361)
                                .padding(.top, 28)
                        }else if warningManager.distanceToPotHole <= 30 && warningManager.distanceToPotHole > 20{
                            Image("alert300")
                                .resizable()
                                .scaledToFit()
                                .frame(width:361)
                                .padding(.top, 28)
                        }else if warningManager.distanceToPotHole <= 20 && warningManager.distanceToPotHole > 10{
                            ZStack(alignment: .top) {
                                Image("alert100_red")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:361)
                                    .padding(.top, 28)
                                    .opacity(isShowingImageA ? 1 : 0)
                                
                                Image("alert100")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:361)
                                    .padding(.top, 28)
                                    .opacity(isShowingImageA ? 0 : 1)
                            }
                            .onAppear {
                                withAnimation(Animation.easeOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                    isShowingImageA.toggle()
                                }
                            }
                        }
                        Spacer()
                        Button{
                            warningManager.alertMode = false
                            warningManager.showAlert = false
                        }label:{
                            Image("cancelButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width:364)
                            
                        }
                    }
                }else{
                    VStack{
                        SearchBarView(searchText: $searchText)
                            .padding(.top, 24)
                        buttonStack
                        if showPotholeInfo, let pothole = selectedPothole {
                            PotholeInfoView(pothole: pothole)
                                .transition(.move(edge: .bottom))
                                .animation(.spring(), value: showPotholeInfo)
                                .padding(.bottom, 20)
                        }
                    }
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
                warningManager.setupAudio()
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
                        warningManager.alertMode = true
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
