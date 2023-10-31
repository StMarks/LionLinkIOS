//
//  HourBlock.swift
//  LionLink
//
//  Created by James Sabet on 10/23/23.
//

import SwiftUI

struct HourBlock: View {
    var hour: Int
    var body: some View {
        VStack {
            Divider()
            Text("\(hour):00")
            Spacer()
            // Here you can add events using ZStack for overlapping
        }
        .frame(height: 60) // Or adjust based on your design preference
    }
}
