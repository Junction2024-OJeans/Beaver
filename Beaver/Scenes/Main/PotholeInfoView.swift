//
//  PotholeInfoView.swift
//  Beaver
//
//  Created by 지영 on 8/11/24.
//

import SwiftUI
import CoreLocation

struct PotholeInfoView: View {
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
    
    @State private var selectedLevel: DangerLevel?
    
    var body: some View {
        HStack {
            Image("xffx")
                .resizable()
                .frame(width: 171, height: 183)
            VStack(alignment: .leading, spacing: 10) {
                Text("경북 포항시 청암로 77")
                    .font(.title3.bold())
                Text("포항공대 생활관 도로")
                    .font(.callout)
                HStack {
                    ForEach(DangerLevel.allCases, id: \.self) { level in
                        ToggleButton(selectedLevel: $selectedLevel, dangerLevel: level)
                    }
                }
            }
            .frame(width: 206, height: 183)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .frame(width: 377, height: 183)
    }
}

#Preview {
    PotholeInfoView()
}
