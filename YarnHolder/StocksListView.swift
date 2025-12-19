//
//  StocksListView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/10/17.
//

import SwiftUI
import SwiftData

enum StocksSortOrder: String, CaseIterable {
//    case brightnessAsc  // 明度昇順
//    case brightnessDesc // 明度降順
    case hue        // 色相順
//    case saturationAsc  // 彩度昇順
//    case saturationDesc // 彩度降順

    case lightness // 輝度順
    
    var value: String {
        switch self {
        case .hue:
            return "KEY_SORT_HUE"
        case .lightness:
            return "KEY_SORT_BRIGHTNESS"
        }
    }
}

enum OrderDirection: String, CaseIterable {
    case asc
    case desc
    
    var value: String {
        switch self {
        case .asc:
            return "KEY_SORT_ASCENDING"
        case .desc:
            return "KEY_SORT_DESCENDING"
        }
    }
}


struct StocksListView: View {
    @AppStorage("appColorTheme") var appColorTheme = 10
    @AppStorage("stocksListOrder") var stocksListOrder: StocksSortOrder = .hue
    @AppStorage("stocksListOrderDirection") var stocksListOrderDirection: OrderDirection = .asc
    @AppStorage("weightUnit") var weightUnit = "g"
    @AppStorage("lengthUnit") var lengthUnit = "m"

    @Query var stocks: [YarnStock]

    public func sortedYarns(/*from stocks: [YarnStock]*/) -> [YarnStock] {
        
        switch stocksListOrder {
        case .hue:
            switch stocksListOrderDirection {
            case .asc:
                return stocks.sorted(by: {$0.sampleColor.color.hsb.h < $1.sampleColor.color.hsb.h})
            case .desc:
                return stocks.sorted(by: {$0.sampleColor.color.hsb.h > $1.sampleColor.color.hsb.h})
            }
        case .lightness:
            // Lightnessの場合は、通常暗い色が先頭に来てしまうため、逆順でソートする
            switch stocksListOrderDirection {
            case .asc:
                return stocks.sorted(by: {$0.sampleColor.color.lightness > $1.sampleColor.color.lightness})
            case .desc:
                return stocks.sorted(by: {$0.sampleColor.color.lightness < $1.sampleColor.color.lightness})
            }
        }
//        return stocks
    }
    var body: some View {
        List(){
            ForEach(sortedYarns()){ stock in
                NavigationLink{
                    StocksDetailView(stock: stock)
                } label: {
                    HStack {
                        Rectangle()
                            .fill(stock.sampleColor.color) // 色を指定
                            .frame(width: 48, height: 48) // サイズを指定
                            .cornerRadius(10)
                        //                            Divider()
                        VStack(alignment: .leading) {
                            Text(stock.yarnInfo?.name ?? "Error")
                                .fontWeight(.bold)
                            HStack {
                                VStack(alignment: .leading){
                                    Text("KEY_COLOR_CODE_MIN")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(stock.colorCode)
                                }
                                VStack(alignment: .leading){
                                    Text("KEY_LOT_NUMBER_MIN")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(stock.lotNumber)
                                }
                            }
                        }
                        //                            Divider()
                        //                            VStack(alignment: .leading) {
                        //                                Text("KEY_LOT_NUMBER")
                        //                                    .font(.caption)
                        //                                    .foregroundColor(.secondary)
                        //                                Text(yarnStock.lotNumber)
                        //                            }
                        //                            Divider()
                        Spacer()
                        // 画像
                        if let image = stock.images.first {
                            if let uiImage = UIImage(data: image) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                //                    .frame(width: 80, height: 80)
                                    .frame(width: 48, height: 48)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 10)) // 角を丸くした四角形
                            }
                        }
                        VStack{
                            if let wrappedDetails = stock.details {
                                Text("\(wrappedDetails.count)")
                                    .font(.system(.title, design: .rounded))
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 4)
                            } else {
                                Text("0")
                                    .font(.system(.title, design: .rounded))
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 4)
                            }
                            Text("\(String(format: "%.1f", stock.totalWeight)) \(weightUnit)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(String(format: "%.1f", stock.totalLength)) \(lengthUnit)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
//                    .contextMenu(menuItems: {
//                        Button {
//                            feedbackForAddStock.toggle()
//                            duplicateYarnStock(stock: yarnStock)
//                        } label: {
//                            Label("KEY_DUPLICATE", systemImage: "document.on.document")
//                        }
//                        Divider()
//                        Button(role: .destructive) {
//                            deleteYarnStock(yarnStock: yarnStock)
//                        } label: {
//                            Label("KEY_DELETE", systemImage: "trash")
//                        }
//                        .tint(.red)
//                    })
                }

            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                // 編集ボタン
                Menu {
                    Menu {
                        Picker(
                            selection: $stocksListOrder.animation(),
                            label: Label("KEY_SORT_ORDER", systemImage: "list.number")
                        ) {
                            ForEach(StocksSortOrder.allCases, id: \.self) { order in
                                Text(LocalizedStringKey(order.value)).tag(order)
                            }
                        }
                        Picker(
                            selection: $stocksListOrderDirection.animation(),
                            label: Label("KEY_SORT_ORDER", systemImage: "arrow.up.arrow.down")
                        ) {
                            ForEach(OrderDirection.allCases, id: \.self) { order in
                                Text(LocalizedStringKey(order.value)).tag(order)
                            }
                        }
                        
                    } label: {
                        Label("KEY_SORT_ORDER", systemImage: "list.number")
                        Text(LocalizedStringKey(stocksListOrder.value)) +
                        Text(" - ") +
                        Text(LocalizedStringKey(stocksListOrderDirection.value))
                    }
                } label: {
                    Label("KEY_SELECTION", systemImage: "ellipsis.circle")
                }
            }
        }

        .listStyle(.sidebar)
        .navigationTitle("KEY_ALL_STASH")
        .toolbarTitleDisplayMode(.large)

//        Text("StocksListView")
    }
}


#Preview {
    StocksListView()
        // .modelContainer(previewYarn)
}
