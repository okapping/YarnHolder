//
//  YarnsDetailAdditionalInfoView.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/07/29.
//


import SwiftUI
import SwiftData
import TipKit
import Flow

struct YarnsDetailAdditionalInfoView: View {
    @Environment(\.modelContext) private var modelContext

    var yarnInfo: YarnInfo
    
    @State var inputYarnStock: InputYarnStock = .init()
    @State var inputSwatch: InputSwatch = .init()
//    @State var editYarnStock: YarnStock? = nil
    
    // edit yarn
//    @State private var inputYarnInfo: InputYarnInfo = .init()
//    @State private var inputYarnMaterials: [InputYarnMaterial] = []
    //    @State private var inputYarnStocks: [InputYarnStock] = []
//    @State private var showYarnEditSheet = false
//    @State private var yarnsEditViewComplete = false
    
    // add stock
    @State private var showStockAddSheet = false
    @State private var stockEditViewComplete = false
    
    // edit stock
    @State private var showStockEditSheet = false
    @State private var editYarnStockIndex = 0
    
    // edit Tag
    @State private var showTagSelectSheet = false
    @State private var tagSelectViewComplete = false
    @State private var inputTags: [Tag] = []
    
    // add swatch
    @State private var showSwatchAddSheet = false
    @State private var showSwatchEditSheet = false
    @State private var swatchEditViewComplete = false
    @State private var editSwatchIndex = 0

    var body: some View {
        // *******************************************
        List {
            // *******************************************
            // タグ
            Section(
                header:
                    HStack {
                        ListTitleView(title: "KEY_TAG")
                        Spacer()
                        Button{
                            inputTags = yarnInfo.tags
                            showTagSelectSheet = true
                        } label: {
                            ListTitleButtonView(title: "KEY_EDIT", symbol: "square.and.pencil")
                        }
                    }
            ){
                HStack {
                    if yarnInfo.tags.isEmpty {
                        Text("KEY_NOT_REGISTERED")
                    }
                    HFlow(spacing: 8) {
                        ForEach(yarnInfo.tags) { tag in
                            TaglabelView(tag: tag)
                        }
                        
                    }
                }
            }
            // *******************************************
            // 在庫
            Section(
                header:
                    HStack {
                        ListTitleView(title: "KEY_STOCK")
                        Spacer()
                        Button{
                            showStockAddSheet = true
                        } label: {
                            ListTitleButtonView(title: "KEY_ADD")
                        }
                    }
            ) {
                if yarnInfo.stocks.isEmpty {
                    Text("KEY_NOT_REGISTERED")
                }
                ForEach(yarnInfo.stocks.sorted(by: { $0.orderIndex < $1.orderIndex })) {yarnStock in
                    NavigationLink/*(value: yarnStock)*/ {
                        Rectangle()
                            .fill(yarnStock.sampleColor.color)
                    } label: {
                        HStack {
                            if let imageData = yarnStock.image {
                                if let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 48, height: 48)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 10)) // 角を丸くした四角形
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10) // 縁を追加
                                                .stroke(Color.secondary, lineWidth: 2) // 縁の色を設定
                                        )
                                    
                                }
                            }
                            Rectangle()
                                .fill(yarnStock.sampleColor.color) // 色を指定
                                .frame(width: 48, height: 48) // サイズを指定
                                .cornerRadius(8)
                            Divider()
                            VStack(alignment: .leading) {
                                Text("KEY_COLOR_CODE")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(yarnStock.colorCode)
                            }
                            Divider()
                            VStack(alignment: .leading) {
                                Text("KEY_LOT_NUMBER")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(yarnStock.lotNumber)
                            }
                            Divider()
                            Text("\(String(yarnStock.inventory))")
                                .font(.title)
//                            Text("玉")
                            //                            VStack(alignment: .leading) {
                            //                                Text("在庫数")
                            //                                    .font(.caption)
                            //                                    .foregroundColor(.gray)
                            //                                Text("\(String(yarnStock.inventory))玉")
                            //                            }
                            //                            Divider()
                            //                            TipView(HashTagPostButtonTip(), arrowEdge: .trailing)
                            //                            Image(systemName: "info.circle")
                            Text(String(yarnStock.orderIndex))
                        }
                        .contextMenu(menuItems: {
                            Menu {
                                Button {
                                    yarnStock.inventory += 1
                                    try? modelContext.save()
                                } label: {
                                    Label("1増やす", systemImage: "plus")
                                }
                                Button {
                                    yarnStock.inventory += 10
                                    try? modelContext.save()
                                } label: {
                                    Label("10増やす", systemImage: "plus")
                                }
                            } label: {
                                Label("在庫を増やす", systemImage: "plus")
                            }
                            Menu {
                                Button {
                                    yarnStock.inventory -= 1
                                    try? modelContext.save()
                                } label: {
                                    Label("1減らす", systemImage: "minus")
                                }
                                .disabled(yarnStock.inventory < 1)
                                Button {
                                    yarnStock.inventory -= 10
                                    try? modelContext.save()
                                } label: {
                                    Label("10減らす", systemImage: "minus")
                                }
                                .disabled(yarnStock.inventory < 10)
                            } label: {
                                Label("在庫を減らす", systemImage: "minus")
                            }
                            Button {
                                //                            var sampleColor: Color = .gray
                                inputYarnStock.image = yarnStock.image
                                inputYarnStock.sampleColor = yarnStock.sampleColor.color
                                inputYarnStock.colorCode = yarnStock.colorCode
                                inputYarnStock.lotNumber = yarnStock.lotNumber
                                inputYarnStock.inventory = yarnStock.inventory
                                inputYarnStock.memo = yarnStock.memo
                                
                                editYarnStockIndex = yarnStock.orderIndex
                                showStockEditSheet = true
                            } label: {
                                Label("KEY_EDIT", systemImage: "pencil")
                            }
                            Divider()
                            Button(role: .destructive) {
                                //                            yarnInfo.stocks.removeAll(where: {$0.orderIndex == yarnStock.orderIndex})
                                //                                modelContext.delete(yarnStock)
                                deleteYarnStock(yarnStock: yarnStock)
                            } label: {
                                Label("KEY_DELETE", systemImage: "trash")
                            }
                            
                        })
                    }
                }
            }
            // *******************************************
            // スワッチ
            Section(
                header:
                    HStack {
                        ListTitleView(title: "KEY_SWATCH")
                        Spacer()
                        Button{
                            showSwatchAddSheet = true
                        } label: {
                            ListTitleButtonView(title: "KEY_ADD")
                        }
                    }
            ){
                //                Button {
                //                    showSwatchAddSheet = true
                //                } label: {
                //                    HStack {
                //                        Image("yarn.badge.plus")
                //                        Text("スワッチ (ゲージ) を登録する")
                //                    }
                //                }
                if yarnInfo.swatches.isEmpty {
                    Text("KEY_NOT_REGISTERED")
                }
                ForEach(yarnInfo.swatches.sorted(by: { $0.orderIndex < $1.orderIndex })) { swatch in
                    HStack {
                        if let imageData = swatch.image {
                            if let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 48, height: 48)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 10)) // 角を丸くした四角形
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10) // 縁を追加
                                            .stroke(Color.secondary, lineWidth: 2) // 縁の色を設定
                                    )
                                
                            }
                        }
                        Text("\(swatch.needleName) \(swatch.needleSizeName) 号")
                        Divider()
                        Text("\(swatch.stitches)目\(swatch.rows)段")
                        Text("\(swatch.orderIndex)")
                        
                    }
                    .contextMenu(menuItems: {
                        Button {
                            inputSwatch.image = swatch.image
                            inputSwatch.needleType = swatch.needleType
                            inputSwatch.needleSize = swatch.needleSize
                            inputSwatch.stitches = swatch.stitches
                            inputSwatch.rows = swatch.rows
                            
                            editSwatchIndex = swatch.orderIndex
                            showSwatchEditSheet = true
                        } label: {
                            Label("KEY_EDIT", systemImage: "pencil")
                        }
                        Divider()
                        Button(role: .destructive) {
                            deleteSwatch(swatch: swatch)
                        } label: {
                            Label("KEY_DELETE", systemImage: "trash")
                        }
                        
                    })
                }
            }
            
        }
        // 在庫新規作成シート
        .sheet(isPresented: $showStockAddSheet, onDismiss: {
            addYarnStock()
        }, content: {
            StocksEditView(
                inputYarnStock: $inputYarnStock,
                inputComplete: $stockEditViewComplete,
                isEntry: true
            )
        })
        // 在庫編集シート
        .sheet(isPresented: $showStockEditSheet, onDismiss: {
            if let yarnStock = yarnInfo.stocks.first(where: { $0.orderIndex == editYarnStockIndex }) {
                updateYarnStock(yarnStock: yarnStock)
            }
        }, content: {
            StocksEditView(
                inputYarnStock: $inputYarnStock,
                inputComplete: $stockEditViewComplete,
                isEntry: false
            )
        })
        // タグ編集シート
        .sheet(isPresented: $showTagSelectSheet, onDismiss: {
            //            if let yarnStock = yarnInfo.stocks.first(where: { $0.orderIndex == editYarnStockIndex }) {
            //                updateYarnStock(yarnStock: yarnStock)
            //            }
            //            editTags(yarnInfo: yarnInfo)
            editTags()
        }, content: {
            NavigationStack {
                TagsSelectView(
                    selectTags: $inputTags,
                    inputComplete: $tagSelectViewComplete
                )
            }
            //            TagsEditView(
            //                selectTags: $yarnInfo.tags
            //            )
        })
        // スワッチ新規作成シート
        .sheet(isPresented: $showSwatchAddSheet, onDismiss: {
            addSwatch()
        }, content: {
            SwatchesEditView(
                inputSwatch: $inputSwatch,
                inputComplete: $swatchEditViewComplete,
                isEntry: true
            )
        })
        // 在庫編集シート
        .sheet(isPresented: $showSwatchEditSheet, onDismiss: {
            if let swatch = yarnInfo.swatches.first(where: { $0.orderIndex == editSwatchIndex }) {
                updateSwatch(swatch: swatch)
            }
        }, content: {
            SwatchesEditView(
                inputSwatch: $inputSwatch,
                inputComplete: $swatchEditViewComplete,
                isEntry: false
            )
        })

    }
    private func addYarnStock() {
        defer {
            inputYarnStock = .init()
            stockEditViewComplete = false
        }
        if !stockEditViewComplete {
            return
        }
        
        withAnimation {
            let colorComponents = ColorComponents.fromColor(inputYarnStock.sampleColor)
            
            let newYarnStock = YarnStock(
                yarnInfo: yarnInfo,
                orderIndex: yarnInfo.stocks.count + 1,
                image: inputYarnStock.image,
                sampleColor: colorComponents,
                colorCode: inputYarnStock.colorCode,
                lotNumber: inputYarnStock.lotNumber,
                inventory: inputYarnStock.inventory,
                memo: inputYarnStock.memo
            )
            modelContext.insert(newYarnStock)
            //            for (index, yarnMaterial) in inputYarnMaterials.enumerated() {
            
            // orderIndexの更新
            renumberStocksIndex(yarnInfo: yarnInfo)
        }
    }
    private func updateYarnStock(yarnStock: YarnStock) {
        defer {
            inputYarnStock = .init()
            stockEditViewComplete = false
        }
        if !stockEditViewComplete {
            return
        }
        withAnimation {
            let colorComponents = ColorComponents.fromColor(inputYarnStock.sampleColor)
            yarnStock.image = inputYarnStock.image
            yarnStock.sampleColor = colorComponents
            yarnStock.colorCode = inputYarnStock.colorCode
            yarnStock.lotNumber = inputYarnStock.lotNumber
            yarnStock.inventory = inputYarnStock.inventory
            yarnStock.memo = inputYarnStock.memo
            try? modelContext.save()
            
            // orderIndexの更新
            renumberStocksIndex(yarnInfo: yarnInfo)
            
        }
    }
    private func deleteYarnStock(yarnStock: YarnStock) {
        withAnimation {
            modelContext.delete(yarnStock)
            try? modelContext.save()
            
            // orderIndexの更新
            renumberStocksIndex(yarnInfo: yarnInfo)
            
        }
    }
    //yarnInfo: YarnInfo
    private func editTags() {
        defer {
            inputTags = []
            tagSelectViewComplete = false
        }
        if !tagSelectViewComplete {
            return
        }
        withAnimation {
            yarnInfo.tags = inputTags
            try? modelContext.save()
        }
        
    }
    private func renumberStocksIndex(yarnInfo: YarnInfo) {
        // orderIndexでソート
        let sortedStocks = yarnInfo.stocks.sorted { $0.orderIndex < $1.orderIndex }
        for (index, stock) in sortedStocks.enumerated() {
            stock.orderIndex = index + 1
        }
        try? modelContext.save()
    }
    private func renumberSwatchesIndex(yarnInfo: YarnInfo) {
        // orderIndexでソート
        let sortedSwatches = yarnInfo.swatches.sorted { $0.orderIndex < $1.orderIndex }
        for (index, stock) in sortedSwatches.enumerated() {
            stock.orderIndex = index + 1
        }
        try? modelContext.save()
    }
    
    private func addSwatch() {
        defer {
            inputSwatch = .init()
            swatchEditViewComplete = false
        }
        if !swatchEditViewComplete {
            return
        }
        withAnimation {
            let newSwatch = Swatch(
                yarnInfo: yarnInfo,
                orderIndex: yarnInfo.swatches.count + 1,
                image: inputSwatch.image,
                needleType: inputSwatch.needleType,
                needleSize: inputSwatch.needleSize,
                stitches: inputSwatch.stitches ?? 0,
                rows: inputSwatch.rows ?? 0
                
            )
            modelContext.insert(newSwatch)
            
            // orderIndexの更新
            renumberSwatchesIndex(yarnInfo: yarnInfo)
        }
    }
    private func updateSwatch(swatch: Swatch) {
        defer {
            inputSwatch = .init()
            swatchEditViewComplete = false
        }
        if !swatchEditViewComplete {
            return
        }
        withAnimation {
            swatch.image = inputSwatch.image
            swatch.needleType = inputSwatch.needleType
            swatch.needleSize = inputSwatch.needleSize
            swatch.stitches = inputSwatch.stitches ?? 0
            swatch.rows = inputSwatch.rows ?? 0
            try? modelContext.save()
            
            // orderIndexの更新
            renumberSwatchesIndex(yarnInfo: yarnInfo)
            
        }
    }
    
    private func deleteSwatch(swatch: Swatch) {
        withAnimation {
            modelContext.delete(swatch)
            try? modelContext.save()
            
            // orderIndexの更新
            renumberSwatchesIndex(yarnInfo: yarnInfo)
            
        }
    }
}

#Preview{
    YarnsDetailAdditionalInfoView(yarnInfo: .init())
}
