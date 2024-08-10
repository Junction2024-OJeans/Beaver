//
//  PotHoleDataManager.swift
//  Beaver
//
//  Created by Hyun Lee on 8/11/24.
//

import Foundation
import SwiftCSV
import SwiftUI
import CoreLocation

class PotHoleDataManager: ObservableObject {
    var pohangPotHoles = [PotholeData]()
    let hicoPotHoles =  [PotholeData(id: "river-side", coordinates: CLLocationCoordinate2D(latitude: 35.838127, longitude: 129.287374), province: "경상북도", region: "경주시", town: "신평동"), PotholeData(id: "parking-side", coordinates: CLLocationCoordinate2D(latitude: 35.839078, longitude: 129.288206), province: "경상북도", region: "경주시", town: "신평동")]
    
    func loadCSV(){ // 이 친구도 초기화할때 한번 불러 주세요 ㅎ
        do {
             let rawCSV = try CSV<Named>(
                name: "PohangPotholeData",
                extension: "csv",
                bundle: .main,
                delimiter: .character(","),
                encoding: .utf8)
            if let rawCSV = rawCSV{
                var csv = rawCSV.rows
                pohangPotHoles = convertCSVToModel(rows: csv)
            }else{
                print(("Error: CSV row not found"))
            }
        } catch{
            print("Error in parsing CSV: \(error)")
        }
    }
    
    private func convertCSVToModel(rows: [[String:String]]) -> [PotholeData]{
        var potholes = [PotholeData]()
        for row in rows{
            guard let lat = Double(row["latitude"] ?? ""), let long = Double(row["longitude"] ?? "") else {continue}
            guard let id = row["id"], let province = row["regionname_1"], let region = row["regionname_2"], let town = row["regionname_3"] else {
                continue
            }
            var pothole = PotholeData(id: id, coordinates: CLLocationCoordinate2D(latitude: lat, longitude: long), province: province, region: region, town: town)
            potholes.append(pothole)
        }
        return potholes
    }
}
