//
//  PotHoleDataModel.swift
//  Beaver
//
//  Created by Jia Jang on 8/11/24.
//

import Foundation
import SwiftUI
import CoreLocation

struct PotholeData: Identifiable {
    var id: String
    var coordinates: CLLocationCoordinate2D
    var province: String //"regionname_1"
    var region: String //"regionname_2"
    var town: String //"regionname_3"
    var image: Image?
    var myDangerLevel: DangerLevel?
    var averageDangerLevel: DangerLevel?
}

enum DangerLevel: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

