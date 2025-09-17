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
    @AppStorage("appColorTheme") var appColorTheme = 10
    @AppStorage("weightUnit") var weightUnit = "g"
    @AppStorage("lengthUnit") var lengthUnit = "m"

    var yarnInfo: YarnInfo
    
    @State var inputYarnStock: InputYarnStock = .init()
    @State var inputYarnStockDetails: [InputYarnStockDetail] = []
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
    
    // ImageView
    @State private var showFullImage = false
    @State private var showImages: [showImageContainer] = []
    
    // frrdback用
    @State private var feedbackForAddStock: Bool = false
    @State private var feedbackForAddSwatch: Bool = false

    
    var body: some View {
        // *******************************************
        List {
            // *******************************************
            // タグ
            Section(
                header:
                    HStack {
                        Image(systemName: "number")
                            .font(.title3)
                        ListTitleView(title: "KEY_TAG")
                        Spacer()
                        Button{
                            inputTags = yarnInfo.tags
                            showTagSelectSheet = true
                        } label: {
//                            ListTitleButtonView(title: "KEY_EDIT", symbol: "square.and.pencil", color: yarnInfo.symbolColor)
                            Label("KEY_EDIT", systemImage: "square.and.pencil")
                                .fontWeight(.bold)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .buttonBorderShape(.capsule)
//                        .tint(yarnInfo.symbolColor)
//                        .tint(Color(getColorTheme(by: appColorTheme).sysName))

                    }
            ){
                HStack {
                    if yarnInfo.tags.isEmpty {
                        Text("KEY_NOT_REGISTERED")
                    }
                    HFlow(spacing: 8) {
                        ForEach(yarnInfo.tags.sorted(by: { $0.orderIndex < $1.orderIndex })) { tag in
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
                        Image(systemName: "basket.fill")
                            .font(.title3)
                        ListTitleView(title: "KEY_STOCK")
                        Spacer()
                        Button{
                            feedbackForAddStock.toggle()
                            addYarnStock()
//                            showStockAddSheet = true
                        } label: {
//                            ListTitleButtonView(title: "KEY_ADD")
                            Label("KEY_ADD", systemImage: "plus")
                                .fontWeight(.bold)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .buttonBorderShape(.capsule)
//                        .tint(yarnInfo.symbolColor)
//                        .tint(Color(getColorTheme(by: appColorTheme).sysName))
                        .sensoryFeedback(.success, trigger: feedbackForAddStock)
                    }
            ) {
                if yarnInfo.stocks.isEmpty {
                    Text("KEY_NOT_REGISTERED")
                }
                ForEach(yarnInfo.stocks.sorted(by: { $0.orderIndex < $1.orderIndex })) {yarnStock in
                    NavigationLink/*(value: yarnStock)*/ {
                        StocksDetailView(stock: yarnStock)
//                        Rectangle()
//                            .fill(yarnStock.sampleColor.color)
                    } label: {
                        HStack {
//                            if let imageData = yarnStock.image {
//                                if let uiImage = UIImage(data: imageData) {
//                                    Image(uiImage: uiImage)
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 48, height: 48)
//                                        .clipped()
//                                        .clipShape(RoundedRectangle(cornerRadius: 10)) // 角を丸くした四角形
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 10) // 縁を追加
//                                                .stroke(Color.secondary, lineWidth: 2) // 縁の色を設定
//                                        )
//                                    
//                                }
//                            }
                            Rectangle()
                                .fill(yarnStock.sampleColor.color) // 色を指定
                                .frame(width: 48, height: 48) // サイズを指定
                                .cornerRadius(10)
//                            Divider()
                            VStack(alignment: .leading) {
                                Text("KEY_COLOR_CODE")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(yarnStock.colorCode)
                                Text("KEY_LOT_NUMBER")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(yarnStock.lotNumber)

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
                            if let image = yarnStock.images.first {
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
//                            Spacer()
//                            Text("\(String(yarnStock.inventory))")
//                                .font(.system(.largeTitle, design: .rounded))
//                                .fontWeight(.bold)
//                                .padding(.horizontal, 4)
                            Text("\(yarnStock.details.count)")
                                .font(.system(.largeTitle, design: .rounded))
                                .fontWeight(.bold)
                                .padding(.horizontal, 4)
                                .frame(width: 48)

//                            Text("玉")
                            //                            VStack(alignment: .leading) {
                            //                                Text("KEY_STOCK_QUANTITY")
                            //                                    .font(.caption)
                            //                                    .foregroundColor(.secondary)
                            //                                Text("\(String(yarnStock.inventory))玉")
                            //                            }
                            //                            Divider()
                            //                            TipView(HashTagPostButtonTip(), arrowEdge: .trailing)
                            //                            Image(systemName: "info.circle")
                        }
                        .contextMenu(menuItems: {
//                            Button {
//                                inputYarnStock = .init(yarnStock: yarnStock)
//                                
//                                editYarnStockIndex = yarnStock.orderIndex
//                                for detail in yarnStock.details.sorted(by: { $0.orderIndex < $1.orderIndex }) {
//                                    let tmpDetail = InputYarnStockDetail(detail: detail, info: yarnInfo)
//                                    inputYarnStockDetails.append(tmpDetail)
//                                }
//                                print(inputYarnStockDetails.count)
//                                showStockEditSheet = true
//
//                            } label: {
//                                Label("KEY_EDIT", systemImage: "pencil")
//                            }
                            Button {
                                feedbackForAddStock.toggle()
                                duplicateYarnStock(stock: yarnStock)
                            } label: {
                                Label("KEY_DUPLICATE", systemImage: "document.on.document")
                            }
                            Divider()
                            Button(role: .destructive) {
                                deleteYarnStock(yarnStock: yarnStock)
                            } label: {
                                Label("KEY_DELETE", systemImage: "trash")
                            }
                            .tint(.red)
                        })
                    }
                }
                .onMove(perform: moveYarnStock)
            }
            // *******************************************
            // スワッチ
            Section(
                header:
                    HStack {
                        Image(systemName: "pencil.and.ruler.fill")
                            .font(.title3)
                        ListTitleView(title: "KEY_SWATCH")
                        Spacer()
                        Button{
                            feedbackForAddSwatch.toggle()
                            showSwatchAddSheet = true
                        } label: {
//                            ListTitleButtonView(title: "KEY_ADD")
                            Label("KEY_ADD", systemImage: "plus")
                                .fontWeight(.bold)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .buttonBorderShape(.capsule)
                        .sensoryFeedback(.success, trigger: feedbackForAddSwatch)
                    }
            ){
                if yarnInfo.swatches.isEmpty {
                    Text("KEY_NOT_REGISTERED")
                }
                ForEach(yarnInfo.swatches.sorted(by: { $0.orderIndex < $1.orderIndex })) { swatch in
                    HStack() {
                        if let imageData = swatch.image {
                            if let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
//                                    .frame(width: 48, height: 48)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 10)) // 角を丸くした四角形
                                    .onTapGesture {
                                        let image = showImageContainer(uiImage: uiImage)
                                        showImages.append(image)
                                        showFullImage = true
                                    }
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 10) // 縁を追加
//                                            .stroke(Color.secondary, lineWidth: 2) // 縁の色を設定
//                                    )
                                
                            }
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color(UIColor.tertiarySystemFill)) // 色を指定
                                    .frame(width: 80, height: 80) // サイズを指定
                                    .cornerRadius(10)
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.secondary.opacity(0.5))
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("KEY_NEEDLE_SIZE")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(swatch.needleName) \(swatch.needleSizeName)")
                            Text("KEY_SWATCH_SIZE")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            HStack {
                                Text("KEY_STITCHES\(swatch.stitches.roundedString())")//\(swatch.stitches.roundedString())
                                Text("KEY_ROWS\(swatch.rows.roundedString())")//\(swatch.rows.roundedString())
                            }
//                            Text("\(swatch.stitches.roundedString())目\(swatch.rows.roundedString())段")
                            Text("KEY_WEIGHT")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(swatch.weight.roundedString()) \(weightUnit)")
                        }

                    }
                    .contextMenu(menuItems: {
                        Button {
                            inputSwatch = .init(swatch: swatch)
//                            inputSwatch.image = swatch.image
//                            inputSwatch.needleType = swatch.needleType
//                            inputSwatch.needleSize = swatch.needleSize
//                            inputSwatch.stitches = swatch.stitches
//                            inputSwatch.rows = swatch.rows
//                            inputSwatch.weight = swatch.weight

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
                        .tint(.red)
                    })
                }
                .onMove(perform: moveSwatch)
            }
            
        }
        // 在庫新規作成シート
//        .sheet(isPresented: $showStockAddSheet, onDismiss: {
//            addYarnStock()
//        }, content: {
//            StocksEditView(
//                yarnInfo: yarnInfo,
//                inputYarnStock: $inputYarnStock,
//                inputYarnStockDetails: $inputYarnStockDetails,
//                inputComplete: $stockEditViewComplete,
//                isEntry: true
//            )
//        })
        // 在庫編集シート
//        .sheet(isPresented: $showStockEditSheet, onDismiss: {
//            if let yarnStock = yarnInfo.stocks.first(where: { $0.orderIndex == editYarnStockIndex }) {
//                updateYarnStock(yarnStock: yarnStock)
//            }
//        }, content: {
//            StocksEditView(
//                yarnInfo: yarnInfo,
//                inputYarnStock: $inputYarnStock,
//                inputYarnStockDetails: $inputYarnStockDetails,
//                inputComplete: $stockEditViewComplete,
//                isEntry: false
//            )
//        })
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
        // スワッチ編集シート
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
        .fullScreenCover(isPresented: $showFullImage, onDismiss: {
            showImages = []
        }, content: {
            FullImagesView(images: $showImages, selectIndex: .constant(0))
        })

    }
    private func addYarnStock() {
        withAnimation{
            let newStock = YarnStock(yarnInfo: yarnInfo)
            modelContext.insert(newStock)
            try? modelContext.save()
        }
    }
    private func duplicateYarnStock(stock: YarnStock) {
        withAnimation{
            let newStock = YarnStock(yarnStock: stock)
            modelContext.insert(newStock)
            try? modelContext.save()
        }
    }
//    private func addYarnStock() {
//        defer {
//            inputYarnStock = .init()
//            stockEditViewComplete = false
//            inputYarnStockDetails = []
//        }
//        if !stockEditViewComplete {
//            return
//        }
//        
//        withAnimation {
//            let newYarnStock = YarnStock(yarnInfo: yarnInfo, input: inputYarnStock)
//            modelContext.insert(newYarnStock)
//            // details
//            for (index, detail) in inputYarnStockDetails.enumerated() {
//                print("newYarnStockDetail weight = \(String(detail.weight))")
//                print("newYarnStockDetail status name = \(detail.status.name)")
//                let newYarnStockDetail = YarnStockDetail(yarnStock: newYarnStock, input: detail, index: index)
//                
//                modelContext.insert(newYarnStockDetail)
//            }
//            
//            // orderIndexの更新
//            renumberStocksIndex(yarnInfo: yarnInfo)
//
//            try? modelContext.save()
//        }
//    }
//    private func updateYarnStock(yarnStock: YarnStock) {
//        defer {
//            inputYarnStock = .init()
//            stockEditViewComplete = false
//            inputYarnStockDetails = []
//        }
//        if !stockEditViewComplete {
//            return
//        }
//        withAnimation {
//            let colorComponents = ColorComponents.fromColor(inputYarnStock.sampleColor)
//            yarnStock.images = inputYarnStock.images
//            yarnStock.sampleColor = colorComponents
//            yarnStock.colorCode = inputYarnStock.colorCode
//            yarnStock.lotNumber = inputYarnStock.lotNumber
//            yarnStock.memo = inputYarnStock.memo
//            try? modelContext.save()
//            // orderIndexの更新
//            renumberStocksIndex(yarnInfo: yarnInfo)
//            // details
//            // 一度全削除してから、再作成・・・？でいいのか、、、？
//            for detail in yarnStock.details {
//                modelContext.delete(detail)
//            }
//            for (index, detail) in inputYarnStockDetails.enumerated() {
//                let newYarnStockDetail = YarnStockDetail(yarnStock: yarnStock, input: detail, index: index)
//                modelContext.insert(newYarnStockDetail)
//            }
//            try? modelContext.save()
//            
//        }
//    }
    private func moveYarnStock(from source: IndexSet, to destination: Int) {
        var updatedStocks = yarnInfo.stocks.sorted(by: { $0.orderIndex < $1.orderIndex })
        updatedStocks.move(fromOffsets: source, toOffset: destination)
        withAnimation {
            for (index, item) in updatedStocks.enumerated() {
                item.orderIndex = index
            }
            try? modelContext.save()
        }
    }
    private func deleteYarnStock(yarnStock: YarnStock) {
        withAnimation {
            for detail in yarnStock.details {
                modelContext.delete(detail)
            }
            try? modelContext.save()
            
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
            stock.orderIndex = index
        }
        try? modelContext.save()
    }
    private func renumberSwatchesIndex(yarnInfo: YarnInfo) {
        // orderIndexでソート
        let sortedSwatches = yarnInfo.swatches.sorted { $0.orderIndex < $1.orderIndex }
        for (index, stock) in sortedSwatches.enumerated() {
            stock.orderIndex = index
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
                orderIndex: yarnInfo.swatches.count,
                image: inputSwatch.image,
                needleType: inputSwatch.needleType,
                needleSize: inputSwatch.needleSize,
                stitches: inputSwatch.stitches ?? 0,
                rows: inputSwatch.rows ?? 0,
                weight: inputSwatch.weight ?? 0

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
            swatch.weight = inputSwatch.weight ?? 0
            try? modelContext.save()
            
            // orderIndexの更新
            renumberSwatchesIndex(yarnInfo: yarnInfo)
            
        }
    }
    private func moveSwatch(from source: IndexSet, to destination: Int) {
        var updatedSwatches = yarnInfo.swatches.sorted(by: { $0.orderIndex < $1.orderIndex })
        updatedSwatches.move(fromOffsets: source, toOffset: destination)
        withAnimation {
            for (index, item) in updatedSwatches.enumerated() {
                item.orderIndex = index
            }
            try? modelContext.save()
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
    @Previewable @State var yarnInfo: YarnInfo = YarnInfo(name: "テスト毛糸", length: 60, weight: 50)

    YarnsDetailAdditionalInfoView(yarnInfo: yarnInfo)
        .modelContainer(previewYarn)
}
