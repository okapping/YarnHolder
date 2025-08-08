//
//  YarnsDetailView.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/03/30.
//

import SwiftUI
import SwiftData
import TipKit
import Flow

struct YarnsDetailView: View {
    @Environment(\.modelContext) private var modelContext
    
//    @Binding var yarnInfo: YarnInfo
    var yarnInfo: YarnInfo
//    @State var yarnInfo: YarnInfo
//    @State var inputYarnStock: InputYarnStock = .init()
    @State var inputSwatch: InputSwatch = .init()
    @State var editYarnStock: YarnStock? = nil

    // edit yarn
    @State private var inputYarnInfo: InputYarnInfo = .init()
    @State private var inputYarnMaterials: [InputYarnMaterial] = []
//    @State private var inputYarnStocks: [InputYarnStock] = []
    @State private var showYarnEditSheet = false
    @State private var yarnsEditViewComplete = false

//    // add stock
//    @State private var showStockAddSheet = false
//    @State private var stockEditViewComplete = false
//    
//    // edit stock
//    @State private var showStockEditSheet = false
//    @State private var editYarnStockIndex = 0
//    
//    // edit Tag
//    @State private var showTagSelectSheet = false
//    @State private var tagSelectViewComplete = false
//    @State private var inputTags: [Tag] = []
//    
//    // add swatch
//    @State private var showSwatchAddSheet = false
//    @State private var showSwatchEditSheet = false
//    @State private var swatchEditViewComplete = false
//    @State private var editSwatchIndex = 0
    
    // Laundry Symbol
    @State private var showPopoverId = 0
    @State private var showPopoverFlg = false

//    // delete yarn
//    @State private var showYarnDeleteSheet = false
//    @Environment(\.presentationMode) var presentation

    @State var selectedTab: Int = 1
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
//                HStack(spacing: 0) {
//                    UpperTabView(selectedTab: $selectedTab, title: "KEY_BASIC_INFO", index: 1)
//                    UpperTabView(selectedTab: $selectedTab, title: "KEY_ADDITIONAL_INFO", index: 2)
//                    //                UpperTabView(selectedTab: $selectedTab, title: "その他", index: 3)
//                }
//                .frame(height: 40)
                Picker("", selection: $selectedTab) {
                    Text("KEY_BASIC_INFO").tag(1)
                    Text("KEY_ADDITIONAL_INFO").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                TabView(selection: $selectedTab) {
                    // 基本情報
                    YarnsDetailBasicInfoView(yarnInfo: yarnInfo)
                        .tag(1)
                    // 追加情報
                    YarnsDetailAdditionalInfoView(yarnInfo: yarnInfo)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
                .animation(.easeIn, value: selectedTab)
            }
//            .navigationDestination(for: YarnStock.self){ stock in
//                Rectangle()
//                    .fill(stock.sampleColor.color)
//                
//            }

        }
//        }
        //        .navigationTitle("\(createImageView(for: getYarnSymbol(by:yarnInfo.symbolId))") "\(yarnInfo.name)")
        //        .navigationTitle("\(createImageView(for: getYarnSymbol(by:yarnInfo.symbolId))") "\(yarnInfo.name)")
//        .navigationTitle(Image(systemName:"star") + yarnInfo.name)
//        .navigationTitle(Text("\(Image(systemName: "star"))"))
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//            }
            ToolbarItem(placement: .principal) {
                HStack {
                    createImageView(for: getYarnSymbol(by:yarnInfo.symbolId))
                        .foregroundColor(.cyan)
                        .font(.subheadline)
                    Text(yarnInfo.name)
                        .fontWeight(.bold)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                // 編集ボタン
                Button {
                    inputYarnInfo = InputYarnInfo.init(yarnInfo: yarnInfo)
                    let sortedMaterials = yarnInfo.materials.sorted { $0.orderIndex < $1.orderIndex }
                    for material in sortedMaterials{
                        let input = InputYarnMaterial(
                            orderIndex: material.orderIndex,
                            materialId: material.materialId,
                            percentage: material.percentage
                        )
                        inputYarnMaterials.append(input)
                    }
                    print(inputYarnMaterials.count)
                    showYarnEditSheet = true
                } label: {
                    Text("KEY_EDIT")
                }
            }
            
        }
        // シート
        // 毛糸情報編集シート
        .sheet(isPresented: $showYarnEditSheet, onDismiss: {
            updateYarnInfo(yarnInfo: yarnInfo)
        }, content: {
            YarnsEditView(
                inputYarnInfo: $inputYarnInfo,
                inputYarnMaterials: $inputYarnMaterials,
//                inputYarnStocks: $inputYarnStocks,
                inputComplete: $yarnsEditViewComplete,
                isEntry: false
            )
        })
    }

    private func updateYarnInfo(yarnInfo: YarnInfo) {
        defer {
            inputYarnInfo = .init()
            inputYarnMaterials = []
            yarnsEditViewComplete = false
        }
        if !yarnsEditViewComplete {
            return
        }
        withAnimation {
            yarnInfo.name = inputYarnInfo.name
            yarnInfo.standardGaugeStitches = inputYarnInfo.standardGaugeStitches
            yarnInfo.standardGaugeRows = inputYarnInfo.standardGaugeRows
            yarnInfo.useKnittingNeedlesFrom = inputYarnInfo.useKnittingNeedlesFrom
            yarnInfo.useKnittingNeedlesTo = inputYarnInfo.useKnittingNeedlesTo
            yarnInfo.useCrochetHookFrom = inputYarnInfo.useCrochetHookFrom
            yarnInfo.useCrochetHookTo = inputYarnInfo.useCrochetHookTo
            yarnInfo.length = inputYarnInfo.length
            yarnInfo.weight = inputYarnInfo.weight
            yarnInfo.memo = inputYarnInfo.memo
            yarnInfo.tags = inputYarnInfo.tags
            yarnInfo.laundrySymbols = inputYarnInfo.laundrySymbols
            yarnInfo.images = inputYarnInfo.images
            yarnInfo.symbolId = inputYarnInfo.symbolId
            // 素材情報の削除
            for material in yarnInfo.materials {
                modelContext.delete(material)
            }
            // 新たに素材情報を作成
            for (index, yarnMaterial) in inputYarnMaterials.enumerated() {
                let percentage = yarnMaterial.percentage ?? 0
                let newYarnMaterial = YarnMaterial(
                    yarnInfo: yarnInfo,
                    orderIndex: index,
                    materialId: yarnMaterial.materialId,
                    percentage: percentage,
                    createdAt: Date()
                )
                modelContext.insert(newYarnMaterial)
            }

            try? modelContext.save()
        }
    }

    
//    private func addYarnStock() {
//        defer {
//            inputYarnStock = .init()
//            stockEditViewComplete = false
//        }
//        if !stockEditViewComplete {
//            return
//        }
//
//        withAnimation {
//            let colorComponents = ColorComponents.fromColor(inputYarnStock.sampleColor)
//            
//            let newYarnStock = YarnStock(
//                yarnInfo: yarnInfo,
//                orderIndex: yarnInfo.stocks.count + 1,
//                sampleColor: colorComponents,
//                colorCode: inputYarnStock.colorCode,
//                lotNumber: inputYarnStock.lotNumber,
//                inventory: inputYarnStock.inventory,
//                memo: inputYarnStock.memo
//            )
//            modelContext.insert(newYarnStock)
////            for (index, yarnMaterial) in inputYarnMaterials.enumerated() {
//
//            // orderIndexの更新
//            renumberStocksIndex(yarnInfo: yarnInfo)
//        }
//    }
//    private func updateYarnStock(yarnStock: YarnStock) {
//        defer {
//            inputYarnStock = .init()
//            stockEditViewComplete = false
//        }
//        if !stockEditViewComplete {
//            return
//        }
//        withAnimation {
//            let colorComponents = ColorComponents.fromColor(inputYarnStock.sampleColor)
//            yarnStock.sampleColor = colorComponents
//            yarnStock.colorCode = inputYarnStock.colorCode
//            yarnStock.lotNumber = inputYarnStock.lotNumber
//            yarnStock.inventory = inputYarnStock.inventory
//            yarnStock.memo = inputYarnStock.memo
//            try? modelContext.save()
//
//            // orderIndexの更新
//            renumberStocksIndex(yarnInfo: yarnInfo)
//
//        }
//    }
//    private func deleteYarnStock(yarnStock: YarnStock) {
//        withAnimation {
//            modelContext.delete(yarnStock)
//            try? modelContext.save()
//            
//            // orderIndexの更新
//            renumberStocksIndex(yarnInfo: yarnInfo)
//
//        }
//    }
//    //yarnInfo: YarnInfo
//    private func editTags() {
//        defer {
//            inputTags = []
//            tagSelectViewComplete = false
//        }
//        if !tagSelectViewComplete {
//            return
//        }
//        withAnimation {
//            yarnInfo.tags = inputTags
//            try? modelContext.save()
//        }
//
//    }
    
//    private func deleteYarnInfo(yarnInfo: YarnInfo) {
//        // リレーション先を削除してから本体を削除する
//        for material in yarnInfo.materials {
//            modelContext.delete(material)
//        }
//        for stock in yarnInfo.stocks {
//            modelContext.delete(stock)
//        }
//        for tag in yarnInfo.tags {
//            modelContext.delete(tag)
//        }
//        try? modelContext.save()
//        modelContext.delete(yarnInfo)
//        try? modelContext.save()
//        // 前の画面に戻る
//        self.presentation.wrappedValue.dismiss()
//    }
    
//    private func addSwatch() {
//        defer {
//            inputSwatch = .init()
//            swatchEditViewComplete = false
//        }
//        if !swatchEditViewComplete {
//            return
//        }
//        withAnimation {
//            let newSwatch = Swatch(
//                yarnInfo: yarnInfo,
//                orderIndex: yarnInfo.swatches.count + 1,
//                image: inputSwatch.image,
//                needleType: inputSwatch.needleType,
//                needleSize: inputSwatch.needleSize,
//                stitches: inputSwatch.stitches ?? 0,
//                rows: inputSwatch.rows ?? 0
//
//            )
//            modelContext.insert(newSwatch)
//            
//            // orderIndexの更新
//            renumberSwatchesIndex(yarnInfo: yarnInfo)
//        }
//    }
//    private func updateSwatch(swatch: Swatch) {
//        defer {
//            inputSwatch = .init()
//            swatchEditViewComplete = false
//        }
//        if !swatchEditViewComplete {
//            return
//        }
//        withAnimation {
//            swatch.image = inputSwatch.image
//            swatch.needleType = inputSwatch.needleType
//            swatch.needleSize = inputSwatch.needleSize
//            swatch.stitches = inputSwatch.stitches ?? 0
//            swatch.rows = inputSwatch.rows ?? 0
//            try? modelContext.save()
//            
//            // orderIndexの更新
//            renumberSwatchesIndex(yarnInfo: yarnInfo)
//            
//        }
//    }
//
//    private func deleteSwatch(swatch: Swatch) {
//        withAnimation {
//            modelContext.delete(swatch)
//            try? modelContext.save()
//            
//            // orderIndexの更新
//            renumberSwatchesIndex(yarnInfo: yarnInfo)
//            
//        }
//    }


//    private func renumberStocksIndex(yarnInfo: YarnInfo) {
//        // orderIndexでソート
//        let sortedStocks = yarnInfo.stocks.sorted { $0.orderIndex < $1.orderIndex }
//        for (index, stock) in sortedStocks.enumerated() {
//            stock.orderIndex = index + 1
//        }
//        try? modelContext.save()
//    }
//    private func renumberSwatchesIndex(yarnInfo: YarnInfo) {
//        // orderIndexでソート
//        let sortedSwatches = yarnInfo.swatches.sorted { $0.orderIndex < $1.orderIndex }
//        for (index, stock) in sortedSwatches.enumerated() {
//            stock.orderIndex = index + 1
//        }
//        try? modelContext.save()
//    }

}
#Preview {
//    YarnsDetailView(yarnInfo: .constant(YarnInfo(name: "テスト毛糸", memo: "メモメモ", createdAt: Date())))
//    YarnsDetailView(yarnInfo: YarnInfo(name: "テスト毛糸", memo: "メモメモ", createdAt: Date()))
//        .modelContainer(for: YarnInfo.self, inMemory: true)
}
