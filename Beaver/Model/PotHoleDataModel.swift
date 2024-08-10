//
//  PotHoleDataModel.swift
//  Beaver
//
//  Created by Jia Jang on 8/11/24.
//

import Foundation
import SwiftUI
import CoreLocation

struct PotholeData: Identifiable, Hashable {
    var id: String
    var coordinates: CLLocationCoordinate2D
    var province: String //"regionname_1"
    var region: String //"regionname_2"
    var town: String //"regionname_3"
    var image: Image?
    var myDangerLevel: DangerLevel?
    var averageDangerLevel: DangerLevel?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum DangerLevel: String{
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

