//
//  ReportCompleteView.swift
//  Beaver
//
//  Created by Jia Jang on 8/11/24.
//

import SwiftUI

struct ReportCompleteView: View {
    @Environment(\.dismiss) private var dismiss
    @State var coordinates: Coordinates?
    @Binding var shouldPopToRootView: Bool
    
    var body: some View {
        VStack {
            Image("character_hold")
                .resizable()
                .scaledToFit()
                .padding(.top, 40)
            
            Spacer()
            
            VStack {
                Button(action: {
                    shouldPopToRootView = true
                }) {
                    HStack {
                        Spacer()
                        Image("complete_button")
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 60)
        }
        .padding(20)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ReportCompleteView(shouldPopToRootView: .constant(false))
}
