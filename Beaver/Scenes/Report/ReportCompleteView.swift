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
    
    var body: some View {
        VStack {
            Image("character_hold")
                .resizable()
                .scaledToFit()
                .padding(.top, 40)
            
            Spacer()
            
            VStack {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Spacer()
                        Text("Complete")
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .padding(20)
                .background(Color.accentColor)
                .cornerRadius(10)
            }
            .padding(.horizontal, 60)
        }
        .padding(20)
    }
}

#Preview {
    ReportCompleteView()
}
