//
//  ButtonView.swift
//  Beaver
//
//  Created by Hyun Lee on 8/11/24.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .padding(.leading, 20)
                .foregroundStyle(.brown)
            TextField(text: $searchText){
                Text("Search here")
                    .foregroundStyle(.brown1)
            }
        }
        .frame(width: 345, height: 44)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 1000))
//        .padding(EdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 22))
    }
}

//#Preview {
//    SearchBarView()
//}
