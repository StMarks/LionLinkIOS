//
//  File.swift
//  LionLink
//
//  Created by Kaien on 11/1/23.
//

import SwiftUI

struct JSONInfo: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case scheduleDayLimit
        case user
        case schedule
    }
    var id = UUID()
    var scheduleDayLimit: Int
    var user: Account
    var schedule: [Block]
}
