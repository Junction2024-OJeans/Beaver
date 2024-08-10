//
//  ToggleButton.swift
//  Beaver
//
//  Created by 지영 on 8/11/24.
//

import SwiftUI

struct ToggleButton: View {
    @Binding var selectedLevel: DangerLevel?
    let dangerLevel: DangerLevel
    
    var body: some View {
        Button(action: {
            if selectedLevel == dangerLevel {
                selectedLevel = nil  // 현재 선택된 버튼을 다시 누르면 선택 해제
            } else {
                selectedLevel = dangerLevel
            }
        }) {
            VStack {
                Image(selectedLevel == dangerLevel ? "select_\(dangerLevel.rawValue)" : "notselect_\(dangerLevel.rawValue)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 51, height: 51)
                Text(dangerLevel.rawValue)
                    .font(.caption2)
                    .foregroundStyle(.black)
            }
            .frame(width: 58)
        }
    }
}

