//
//  OffsetReader.swift
//  LionLink
//
//  Created by Liam Bean on 11/7/24.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGRect  = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
        
    }
}

extension View{
    @ViewBuilder
    func offsetX(completion: @escaping (CGRect) -> ()) -> some View{
        self
            .frame(maxWidth: .infinity)
            .overlay{
                GeometryReader{
                    let rect = $0.frame(in: .global)
                    Color.clear
                        .preference(key: OffsetKey.self, value: rect)
                        .onPreferenceChange(OffsetKey.self, perform: completion)
                    
                }
            }
    }
}
