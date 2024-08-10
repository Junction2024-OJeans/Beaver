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
    @StateObject var potHoleDataManager = PotHoleDataManager()
    
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: .hico,
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    ))
    
    @State private var selectedPothole: PotholeData?
    @State private var showPotholeInfo = false
    @State private var searchText = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $cameraPosition) {
                ForEach(potHoleDataManager.hicoPotHoles, id: \.id) { pothole in
                    Annotation("", coordinate: pothole.coordinates) {
                        Image(pothole.averageDangerLevel?.rawValue ?? DangerLevel.low.rawValue)
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
            
            // PotholeInfoView
            if showPotholeInfo, let pothole = selectedPothole {
                PotholeInfoView(pothole: pothole)
                    .transition(.move(edge: .bottom))
                    .animation(.spring(), value: showPotholeInfo)
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            potHoleDataManager.loadCSV()
        }
    }
}
