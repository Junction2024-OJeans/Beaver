//
//  PotholeInfoView.swift
//  Beaver
//
//  Created by 지영 on 8/11/24.
//

import SwiftUI
import CoreLocation

struct PotholeInfoView: View {
    let pothole: PotholeData
    
    @State private var selectedLevel: DangerLevel?
    
    var body: some View {
        HStack {
            Image("xffx")
                .resizable()
                .frame(width: 171, height: 183)
            VStack(alignment: .leading, spacing: 10) {
                Text("\(pothole.province) \(pothole.region)")
                    .font(.title3.bold())
                Text(pothole.town)
                    .font(.callout)
                HStack {
                    ForEach(DangerLevel.allCases, id: \.self) { level in
                        ToggleButton(selectedLevel: $selectedLevel, dangerLevel: level)
                    }
                }
            }
            .frame(width: 206, height: 180)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .frame(width: 377, height: 183)
    }
}

//#Preview {
//    PotholeInfoView()
//}
