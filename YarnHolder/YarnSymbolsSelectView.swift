//
//  YarnSymbolsSelectView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/08/06.
//

import Foundation
import SwiftUI
import SwiftData
import Flow

struct YarnSymbolsSelectView: View {
    @Binding var selectSymbol: Int
    @Binding var selectColor: String
    var body: some View {
        List{
            Section{
                HFlow(spacing: 8, justified: true){
                    ForEach(selectColors, id: \.self){ colorName in
                        ZStack {
                            Circle()
                                .foregroundColor(Color(colorName))
                                .frame(width: 44, height: 44)
                            if selectColor == colorName {
                                Circle()
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .frame(width: 18, height: 18)
                            }
                        }
                        .onTapGesture {
                            selectColor = colorName
                        }
                    }
                }
            }
//            Section{
//                HStack {
//                    Text("KEY_COLOR")
//                    Spacer()
//                    ColorPicker("", selection: $selectColor, supportsOpacity: false)
//                        .labelsHidden()
//                        .scaleEffect(CGSize(width: 999, height: 999))
//                        .frame(width: 150, height: 44)
//                        .cornerRadius(8)
//                        .clipped()
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.black.opacity(0.3), lineWidth: 0.5)
//                        )
//                }
//
//            }
            Section{
                ScrollView() {
                    HFlow(justified: true) {
                        ForEach(yarnSymbols, id: \.self) { symbol in
                            ZStack {
                                Circle()
                                    .opacity(selectSymbol == symbol.id ? 0.2 : 0)
                                    .foregroundColor(Color(selectColor))
                                    .frame(width: 44, height: 44)
                                createImageView(for: symbol)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24,height: 24)
                                    .foregroundColor(selectSymbol == symbol.id ? Color(selectColor) : .secondary)
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                createImageView(for: getYarnSymbol(by:selectSymbol))
                    .foregroundColor(Color(selectColor))
                    .font(.title)
                    .padding()
            }
        }
    }
}

#Preview{
    @Previewable @State var selectSymbol: Int = 0
    @Previewable @State var selectColor: String = selectColors.randomElement()!
    NavigationStack{
        YarnSymbolsSelectView(selectSymbol: $selectSymbol, selectColor: $selectColor)
    }
}
