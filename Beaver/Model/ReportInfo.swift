//
//  ReportInfo.swift
//  Beaver
//
//  Created by Jia Jang on 8/11/24.
//

import Foundation

struct ReportInfo: Identifiable {
    let id: String
    let coordinates: Coordinates
    let dangerLevel: DangerLevel
    
    init(
        id: String = UUID().uuidString,
        coordinates: Coordinates,
        dangerLevel: DangerLevel
    ) {
        self.id = id
        self.coordinates = coordinates
        self.dangerLevel = dangerLevel
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        self.dangerLevel = try container.decode(DangerLevel.self, forKey: .dangerLevel)
    }
}

extension ReportInfo: Equatable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension ReportInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case coordinates
        case dangerLevel
    }
}
