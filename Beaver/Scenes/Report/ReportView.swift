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
        NavigationStack {
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "chevron.left")
                }
            }
            .onAppear {
                showingReportSheet = true
            }
            .sheet(isPresented: $showingReportSheet) {
                Text("Perceived Risk of Pothole")
                    .presentationDetents([
                        .custom(TinyDetent.self),
                        .medium
                    ])
            }
        }
    }
}

struct TinyDetent: CustomPresentationDetent {
    static func height(in context: Context) -> CGFloat? {
        if context.dynamicTypeSize.isAccessibilitySize {
            return 140
        } else {
            return 220
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
