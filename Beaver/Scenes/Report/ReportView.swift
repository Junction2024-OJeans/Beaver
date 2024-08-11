//
//  ReportView.swift
//  Beaver
//
//  Created by Jia Jang on 8/11/24.
//

import SwiftUI
import MapKit

struct ReportView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var locationManager = LocationManager()
    @State private var centerCoordinate: CLLocationCoordinate2D = .init()
    @State private var position: MapCameraPosition
    @State private var showingReportSheet = false
    @State private var showingAlert = false
    @State private var selectedDangerLevel = 0
    @State private var isAbleClosed = false
    @State private var dangerLevel: DangerLevel
    @State private var navigateToCompleteView: Bool = false
    @Binding var coordinates: Coordinates?
    
    init(coordinates: Binding<Coordinates?>) {
        self._coordinates = coordinates
        self._dangerLevel = State(initialValue: .low)
        
        if let coordinates = coordinates.wrappedValue {
            self._position = State(initialValue: .camera(.init(centerCoordinate: .init(coordinates), distance: 1000)))
        } else {
            let rect = MKMapRect(origin: .init(.hico), size: .init(width: 2000, height: 2000))
            let region = MKCoordinateRegion(rect)
            self._position = State(initialValue: .region(region))
        }
    }
    
    var body: some View {
        ZStack {
            if let userLocation = locationManager.currentLocation {
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: userLocation,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )))
                .onAppear {
                    centerCoordinate = userLocation
                }
                .onChange(of: locationManager.currentLocation) { newLocation in
                    if let newLocation = newLocation {
                        centerCoordinate = newLocation
                    }
                }
            } else {
                Text("Loading location...")
            }
            
            Image(systemName: "mappin.and.ellipse")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
        }
        .navigationTitle(Text("Report potholes"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToCompleteView) {
            ReportCompleteView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
            }
        }
        .onAppear {
            showingReportSheet = true
            locationManager.getLocationPermission()
        }
        .sheet(isPresented: $showingReportSheet) {
            bottomSmallSheet
        }
    }
    
    private func saveDangerLevel() {
        let selectedLevel: DangerLevel
        switch selectedDangerLevel {
        case 0:
            selectedLevel = .low
        case 1:
            selectedLevel = .medium
        case 2:
            selectedLevel = .high
        default:
            selectedLevel = .low
        }
        
        let reportInfo = ReportInfo(
            coordinates: coordinates ?? Coordinates(latitude: 0, longitude: 0),
            dangerLevel: selectedLevel
        )
        
        do {
            try FirebaseDataManager.shared.updateData(reportInfo, type: .report, id: reportInfo.id)
            print("업데이트 성공")
        } catch {
            print("업데이트 실패: \(error.localizedDescription)")
        }
    }
}

struct TinyDetent: CustomPresentationDetent {
    static func height(in context: Context) -> CGFloat? {
        if context.dynamicTypeSize.isAccessibilitySize {
            return 140
        } else {
            return 200
        }
    }
}

private extension ReportView {
    var bottomSmallSheet: some View {
        VStack(alignment: .leading) {
            Text("Perceived Risk of Pothole")
                .padding(.vertical, 15)
                .bold()
            
            Picker("Danger Level", selection: $selectedDangerLevel) {
                Text("\(DangerLevel.low)").tag(0)
                Text("\(DangerLevel.medium)").tag(1)
                Text("\(DangerLevel.high)").tag(2)
            }
            .pickerStyle(.segmented)
            
            Spacer()
            
            Button(action: {
                coordinates = .init(
                    latitude: centerCoordinate.latitude,
                    longitude: centerCoordinate.longitude
                )
                
                saveDangerLevel()
                
                navigateToCompleteView = true
            }) {
                HStack {
                    Spacer()
                    Text("Submit")
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .padding(10)
            .background(Color.accentColor)
            .cornerRadius(8)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Form submitted!"),
                      message: Text("Try another thing"),
                      dismissButton: .default(Text("Done")))
            }
        }
        .interactiveDismissDisabled(!isAbleClosed)
        .presentationDetents([
            .custom(TinyDetent.self),
            .medium
        ])
        .presentationBackgroundInteraction(
            .enabled(upThrough: .medium)
        )
        .padding(20)
    }
}

struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
}

extension CLLocationCoordinate2D {
    init(_ coordinates: Coordinates) {
        self.init(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude
        )
    }
    
    static let hico = CLLocationCoordinate2D(
        latitude: 35.83862279759551,
        longitude: 129.2879123861327
    )
}


#Preview {
    ReportView(coordinates: .constant(Coordinates(latitude: 0, longitude: 0)))
}
