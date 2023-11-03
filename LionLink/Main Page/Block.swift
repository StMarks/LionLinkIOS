//
//  Block.swift
//  LionLink
//
//  Created by Kaien on 11/1/23.
//

import SwiftUI

struct Block: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case startTime
        case endTime
        case teacher
        case title
        case location
        case color
    }
    
    var id = UUID()
    var startTime: String
    var endTime: String
    var teacher: String
    var title: String
    var location: String
    var color: String
}
