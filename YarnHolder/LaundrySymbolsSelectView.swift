//
//  LaundrySymbolsSelectView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/07/24.
//

import Foundation
import SwiftUI
import SwiftData
import Flow

struct LaundrySymbolsSelectView: View {
//    @Environment(\.modelContext) var context
    //    @Query private var tags: [Tag]
    
    @Binding var selectSymbols: [Int]
    @State private var displayGroupId: Int = 0
    
    //    @State private var showAddTagAlert: Bool = false
    //    @State private var showEditTagAlert: Bool = false
    //    @State private var inputTagName = ""
    //    @State private var editTag: Tag? = nil
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            ScrollView() {
                HFlow(itemSpacing: 6, rowSpacing: 20) {
                    ForEach(groupedSymbols, id: \.self) { group in
                        ForEach(Array(group.enumerated()), id: \.element.id) { index, lsym in
                            if index == 0 {
                                LineBreak()
                                VStack {
                                    ListTitleView(title: laundryGroupNames[lsym.groupId])
//                                    Text(laundryGroupNames[lsym.groupId])
//                                        .font(.title3)
//                                        .fontWeight(.bold)
//                                    //                                    .padding(.horizontal, 20)
                                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    //                                    .background(.secondary)
                                    Divider()
                                    
                                }
                                .frame(maxWidth: .infinity)
                                .flexibility(.natural)
                                //                            .background(.secondary)
                                
                                LineBreak()
                            }
                            ZStack {
                                Rectangle()
                                    .fill(selectSymbols.contains(lsym.id) ? Color(UIColor.systemGray4) : Color(UIColor.secondarySystemGroupedBackground)) // 背景色を設定
                                    .frame(width: 65, height: 60) // サイズを指定
                                    .cornerRadius(20)
//                                    .shadow(color: .primary ,radius: selectSymbols.contains(lsym.id) ? 3 : 0)
                                Image(lsym.name)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(selectSymbols.contains(lsym.id) ? .primary : .secondary)
                                if selectSymbols.contains(lsym.id) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                        .offset(x: -25, y: -25)
                                }
//                                Image(systemName: selectSymbols.contains(lsym.id) ? "checkmark.circle.fill" : "circle")
//                                    .font(.title2)
//                                    .foregroundColor(selectSymbols.contains(lsym.id) ? .blue : Color(UIColor.systemGray4))
//                                    .offset(x: -25, y: -25)
                            }
                            // .startInNewLine()
                            //                    .padding(12)
                            //                    .background(
                            //                        RoundedRectangle(cornerRadius: 20) // 角を丸くした長方形
                            //                            .fill(selectSymbols.contains(lsym.id) ? .secondary : Color(UIColor.tertiarySystemFill)) // 背景色を設定
                            //                    )
                            .onTapGesture {
                                if let index = selectSymbols.firstIndex(of: lsym.id) {
                                    selectSymbols.remove(at:index)
                                } else {
                                    selectSymbols.append(lsym.id)
                                }
                            }
                        }
                        
                    }
                }
                .padding(10)
            }
            //        .background(Color.systemGroupedBackground)
        }

//        List {
//            Section {
//                ForEach(LaundrySymbols, id: \.id) { lsym in
//                    HStack {
//                        Image(systemName: selectSymbols.contains(lsym.id) ? "checkmark.circle.fill" : "circle")
//                            .font(.title2)
//                            .foregroundColor(.blue)
//                        Image(lsym.name)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 40, height: 40)
//                            .foregroundColor(.primary)
//                        Text(lsym.detail)
//                        Spacer()
//                    }
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        if let index = selectSymbols.firstIndex(of: lsym.id) {
//                            selectSymbols.remove(at:index)
//                        } else {
//                            selectSymbols.append(lsym.id)
//                        }
//                    }
//
//                }
//            }
//        }
        .navigationTitle("KEY_LAUNDRY_SYMBOL_SELECTION")
    }
    
}

#Preview {
    LaundrySymbolsSelectView(selectSymbols: .constant([]))
//    LaundrySymbolsSelectView()
}
