//
//  LunchMenuView.swift
//  LionLink
//
//  Created by Liam Bean on 11/5/24.
//

import SwiftUI

struct LunchMenuView: View {
    @State var lines: Int = 1
    var body: some View {
        Button{
            if lines == 1{
                lines = .max
            }
            else{
                lines = 1
            }
        }label:{
            Text("BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah BLah ")
                .lineLimit(lines)
        }
        
            
    }
}

#Preview {
    LunchMenuView()
}
