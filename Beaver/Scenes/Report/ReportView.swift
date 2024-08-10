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
    @State private var centerCoordinate: CLLocationCoordinate2D = .init()
    @State private var position: MapCameraPosition
    @State private var showingReportSheet = false
    @State private var showingAlert = false
    @State private var selectedDangerLevel = 0
    @State private var isAbleClosed = false
    @Binding var coordinates: Coordinates?
    
    init(coordinates: Binding<Coordinates?>) {
        if let coordinates = coordinates.wrappedValue {
            self.position = .camera(.init(centerCoordinate: .init(coordinates), distance: 1000))
        } else {
            let rect = MKMapRect(origin: .init(.hico), size: .init(width: 2000, height: 2000))
            let region = MKCoordinateRegion(rect)
            self.position = .region(region)
        }
        
        self._coordinates = coordinates
    }
    
    var body: some View {
//        NavigationStack {
            ZStack {
                Map(position: $position)
                    .onMapCameraChange { context in
                        centerCoordinate = context.camera.centerCoordinate
                    }
                
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                
                bottomSubmitButton
                    .padding(.bottom, 250)
            }
            .navigationTitle(Text("Report potholes"))
            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        print("dismiss")
                        dismiss()
                    }label:{
                        Image(systemName: "chevron.left")
                    }
                }
            }
            .onAppear {
                showingReportSheet = true
            }
            .sheet(isPresented: $showingReportSheet) {
                VStack(alignment: .leading) {
                    Text("Perceived Risk of Pothole")
                        .padding(.vertical, 15)
                        .bold()
                    
                    Picker("위험 수준", selection: $selectedDangerLevel) {
                        Text("\(DangerLevel.low)").tag(0)
                        Text("\(DangerLevel.medium)").tag(1)
                        Text("\(DangerLevel.high)").tag(2)
                    }
                    .pickerStyle(.segmented)
                    
                    Spacer()
                    
                    Button(action: {
                        // TODO: saveDangerLevel()
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
                .padding(20)
            }
//        }
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
    var bottomSubmitButton: some View {
        VStack {
            Spacer()
            Button("Select the location") {
                coordinates = .init(
                    latitude: centerCoordinate.latitude,
                    longitude: centerCoordinate.longitude
                )
                
                dismiss()
            }
            .frame(maxWidth: .infinity, maxHeight: 48)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .bold()
            .zIndex(2)
        }
        .padding(.horizontal)
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
