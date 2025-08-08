//
//  TestView.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/07/30.
//
import Foundation
import SwiftUI
import SwiftData
import Flow

struct TestView: View {
    @Binding var selectSymbols: [Int]
    @State private var displayGroupId: Int = 0

//    var groupedSymbols = Dictionary(grouping: LaundrySymbols, by: { $0.groupId })
//    var groupedSymbols: [[LaundrySymbol]] = {
//        var tempNestList: [[LaundrySymbol]] = []
//        var tmpList: [LaundrySymbol] = []
//        var tmpGroupId = 0
//        for symbol in LaundrySymbols {
//            if symbol.groupId != tmpGroupId {
//                tempNestList.append(tmpList)
//                tmpList = []
//                tmpGroupId = symbol.groupId
//            }
//            tmpList.append(symbol)
//        }
//        return tempNestList
//    }

    var body: some View {
//        Text("\(groupedSymbols.count)")
        ScrollView() {
            HFlow(itemSpacing: 8, rowSpacing: 20) {
                ForEach(groupedSymbols, id: \.self) { group in
//                    Text("\(index)")
                    ForEach(Array(group.enumerated()), id: \.element.id) { index, lsym in
////                        ForEach(Array(groupedSymbols[index].enumerated()), id: \.element.id) { index, lsym in
                        if index == 0 {
                            LineBreak()
                            HStack {
                                Text(laundryGroupNames[lsym.groupId])
                                    .font(.title3)
                            }
                            LineBreak()
                        }
                        ZStack {
                            Rectangle()
                                .fill(selectSymbols.contains(lsym.id) ? .gray : Color.gray.opacity(0.2)) // 背景色を設定
                                .frame(width: 65, height: 60) // サイズを指定
                                .cornerRadius(20)
                            Image(lsym.name)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(selectSymbols.contains(lsym.id) ? .primary : .gray)
                            
                        }
                        .startInNewLine(index == 0)
                        // .startInNewLine()
                        //                    .padding(12)
                        //                    .background(
                        //                        RoundedRectangle(cornerRadius: 20) // 角を丸くした長方形
                        //                            .fill(selectSymbols.contains(lsym.id) ? .gray : Color.gray.opacity(0.2)) // 背景色を設定
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
        }

    }
}


struct ColorCheckView: View {
    var body: some View {
        ScrollView {
            VStack {
                cell(text: "primary", color: .primary)
                cell(text: "secondary", color: .secondary)
                cell(text: "accentColor", color: .accentColor)
            }
            VStack {
                cell(text: "systemRed", color: Color(UIColor.systemRed))
                cell(text: "systemGreen", color: Color(UIColor.systemGreen))
                cell(text: "systemBlue", color: Color(UIColor.systemBlue))
            }
            VStack {
                cell(text: "systemCyan", color: Color(UIColor.systemCyan))
                cell(text: "systemMint", color: Color(UIColor.systemMint))
                cell(text: "systemPink", color: Color(UIColor.systemPink))
                cell(text: "systemTeal", color: Color(UIColor.systemTeal))
                cell(text: "systemBrown", color: Color(UIColor.systemBrown))
                cell(text: "systemIndigo", color: Color(UIColor.systemIndigo))
                cell(text: "systemOrange", color: Color(UIColor.systemOrange))
                cell(text: "systemPurple", color: Color(UIColor.systemPurple))
                cell(text: "systemYellow", color: Color(UIColor.systemYellow))
            }
            VStack {
                cell(text: "systemGray", color: Color(UIColor.systemGray))
                cell(text: "systemGray2", color: Color(UIColor.systemGray2))
                cell(text: "systemGray3", color: Color(UIColor.systemGray3))
                cell(text: "systemGray4", color: Color(UIColor.systemGray4))
                cell(text: "systemGray5", color: Color(UIColor.systemGray5))
                cell(text: "systemGray6", color: Color(UIColor.systemGray6))
            }
            VStack {
                cell(text: "systemFill", color: Color(UIColor.systemFill))
                cell(text: "secondarySystemFill", color: Color(UIColor.secondarySystemFill))
                cell(text: "tertiarySystemFill", color: Color(UIColor.tertiarySystemFill))
                cell(text: "quaternarySystemFill", color: Color(UIColor.quaternarySystemFill))
            }
            VStack {
                cell(text: "systemBackground", color: Color(UIColor.systemBackground))
                cell(text: "secondarySystemBackground", color: Color(UIColor.secondarySystemBackground))
                cell(text: "tertiarySystemBackground", color: Color(UIColor.tertiarySystemBackground))
            }
            VStack {
                cell(text: "systemGroupedBackground", color: Color(UIColor.systemGroupedBackground))
                cell(text: "secondarySystemGroupedBackground", color: Color(UIColor.secondarySystemGroupedBackground))
                cell(text: "tertiarySystemGroupedBackground", color: Color(UIColor.tertiarySystemGroupedBackground))
            }
        }
    }
    
    func cell(text: String, color: Color) -> some View {
        return VStack {
            HStack {
                Text(text)
                    .frame(width:200, height: 35)
                Rectangle()
                    .foregroundColor(color)
                    .frame(width: 150, height: 35)
            }
        }
    }
}

struct ListCheckView: View {
    private let rows = Array(0...10)
    @State private var selections = Set<Int>()

    var body: some View {
        
        List(rows, id: \.self, selection: $selections) { row in
            Text("Row: \(row)")
        }
        .environment(\.editMode, .constant(.active))
    }
}

struct TextColorCheck: View {
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.blue)
            Text("テスト文字")
                .font(.title)
                .fontWeight(.bold)
                .blendMode(.difference)
        }
    }
}
struct ItemNameSampleView: View {
    //    @Environment(\.modelContext) private var modelContext
    //    @Query private var items: [Item]
    var name: String
    var body: some View {
        Text(name)
    }
}

struct ItemSampleView: View {
    //    @Environment(\.modelContext) private var modelContext
    //    @Query private var items: [Item]
    var item: Item
    var body: some View {
        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
        ItemNameSampleView(name: item.name)
    }
}
struct NavigationSplitViewSample: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        NavigationSplitView {
            List (items){ item in
//                ForEach(items) { item in
                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        ItemSampleView(item: item)
                    } label: {
                        HStack {
                            Text(item.name)
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                        }
                        
                    }
//                }
//                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }
    
    private func addItem() {
        withAnimation {
            let newName = "テスト \(1 + items.count)"
            let newItem = Item(name: newName, timestamp: Date())
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    NavigationSplitViewSample()
        .modelContainer(for: Item.self, inMemory: true)
}
@Model
final class Item {
    var name: String
    var timestamp: Date
    
    init(name: String, timestamp: Date) {
        self.name = name
        self.timestamp = timestamp
    }
}

//
//#Preview{
////    TestView(selectSymbols: .constant([]))
////    ColorCheckView()
////    ListCheckView()
//    TextColorCheck()
//}
