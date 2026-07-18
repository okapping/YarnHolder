//
//  ToolListVIew.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/09/29.
//

import SwiftUI

struct ToolsListRowView: View {
    
    var symbol: String
    var color: Color
    var title: String
    var detail: String = ""
    var body: some View {
        HStack(spacing: 0) {
            Label("", systemImage: symbol)
                .foregroundStyle(color)
            VStack(alignment: .leading){
                Text(LocalizedStringKey(title))
                    .font(.headline)
                if detail != "" {
                    Text(LocalizedStringKey(detail))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
struct ToolsListVIew: View {
    @State private var showToolsRulerView = false
    
    var body: some View {
        NavigationSplitView {
            Form{
                Section(){
                    NavigationLink{
                        ToolsSimpleCounterView()
                    } label: {
                        ToolsListRowView(
                            symbol: "plus.forwardslash.minus",
                            color: Color.cPink,
                            title: "KEY_SIMPLE_COUNTER",
                            detail: "KEY_DETAIL_COUNTER"
                        )
                    }
                    NavigationLink{
                        ToolsSizeConversionView()
                    } label: {
                        ToolsListRowView(
                            symbol: "shuffle",
                            color: Color.cGreen,
                            title: "KEY_SIZE_CONVERSION",
                            detail: "KEY_DETAIL_CONVERSION"
                        )
                    }
                    Button {
                        showToolsRulerView = true
                    } label: {
                        ToolsListRowView(
                            symbol: "ruler",
                            color: Color.cBlue,
                            title: "KEY_SIMPLE_RULER",
                            detail: "KEY_DETAIL_RULER"
                        )
                    }
                    .buttonStyle(.plain)
                }
                Section(){
                    NavigationLink{
                        ToolsNeedleSizeTableView()
                    } label:{
                        ToolsListRowView(
                            symbol: "tablecells",
                            color: Color.cTeal,
                            title: "KEY_NEEDLE_SIZE_CHART",
                            detail: ""
                        )
                    }
                    NavigationLink{
                        ToolsHookSizeTableView()
                    } label:{
                        ToolsListRowView(
                            symbol: "tablecells",
                            color: Color.cOrange ,
                            title: "KEY_HOOK_SIZE_CHART",
                            detail: ""
                        )
                    }
                }
                // ***********DEBUG***********
//                                Section{
//                                    NavigationLink{
//                                        DebugView()
//                                    } label: {
//                                        Text("デバック")
//                                    }
//                                }
                // ***********DEBUG***********
            }
            .navigationTitle("KEY_TOOLS")
        } detail: {
            Text("KEY_SELECT_TOOL")
        }
        .fullScreenCover(isPresented: $showToolsRulerView, onDismiss: {
        }, content: {
            ToolsRulerView()
        })
    }
}

#Preview {
    ToolsListVIew()
}
