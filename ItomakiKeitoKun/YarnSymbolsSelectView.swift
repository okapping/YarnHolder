//
//  YarnSymbolsSelectView.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/08/06.
//

import Foundation
import SwiftUI
import SwiftData
import Flow

struct YarnSymbolsSelectView: View {
    @Binding var selectSymbol: Int
    
    var body: some View {
        ScrollView() {
            HFlow(spacing: 8) {
                ForEach(yarnSymbols, id: \.self) { symbol in
                    ZStack {
                        Circle()
                            .opacity(selectSymbol == symbol.id ? 0.2 : 0)
                            .foregroundColor(.blue)
                            .frame(width: 44, height: 44)
                        createImageView(for: symbol)
                        
                            .frame(width: 28,height: 28)
                            .foregroundColor(selectSymbol == symbol.id ? .blue : .gray)
//                        YarnInfoSymbolView(symbol: symbol)
                    }
                    .onTapGesture {
                        selectSymbol = symbol.id
                    }

                }
            }
        }

    }
}

//#Preview{
//    YarnSymbolsSelectView(selectSymbol: .constant(0))
//}
