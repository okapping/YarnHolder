//
//  YarnsDetailView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/03/30.
//

import SwiftUI
import SwiftData
import TipKit
import Flow

struct YarnsDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("yarnInfoPickerEdge") var yarnInfoPickerEdge = 0
    
    @Environment(YarnInfo.self) var yarnInfo
    
    @State var inputSwatch: InputSwatch = .init()
    @State var editYarnStock: YarnStock? = nil
    
    // edit yarn
    @State private var inputYarnInfo: InputYarnInfo = .init()
    @State private var inputYarnMaterials: [InputYarnMaterial] = []
    //    @State private var inputYarnStocks: [InputYarnStock] = []
    @State private var showYarnEditSheet = false
    @State private var yarnsEditViewComplete = false
    
    // Laundry Symbol
    @State private var showPopoverId = 0
    @State private var showPopoverFlg = false
    
    @State var selectedTab: Int = 0
    
    @Namespace private var namespace
    
    private func pickerEdge() -> VerticalEdge {
        switch yarnInfoPickerEdge{
        case 0:
            return .top
        case 1:
            return .bottom
        default:
            return .top
        }
    }
    
    var body: some View {
        NavigationStack {
            switch selectedTab{
            case 0:
                YarnsDetailLabelInfoView()
                    .animation(.default, value: yarnInfoPickerEdge)
            case 1:
                YarnsDetailAdditionalInfoView()
                    .animation(.default, value: yarnInfoPickerEdge)
            case 2:
                YarnsDetailGalleryView()
                    .animation(.default, value: yarnInfoPickerEdge)
            default:
                Text("Error")
                
            }
        }
        .toolbarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .modifier{ content in
            if #available(iOS 26.0, *) {
                content.safeAreaBar(edge: pickerEdge(), spacing: 8) {
                    Picker("", selection: $selectedTab.animation()) {
                        Text("KEY_LABEL_INFO").tag(0)
                        Text("KEY_ADDITIONAL_INFO").tag(1)
                        Text("KEY_GALLERY").tag(2)
                    }
                    .padding()
                    .pickerStyle(.segmented)
                    .background(.clear)
                    .animation(.default, value: yarnInfoPickerEdge)
                    .matchedGeometryEffect(id: "pickerEdge", in: namespace)
                }
            } else {
                content
                    .safeAreaInset(edge: pickerEdge()) {
                        Picker("", selection: $selectedTab.animation()) {
                            Text("KEY_LABEL_INFO").tag(0)
                            Text("KEY_ADDITIONAL_INFO").tag(1)
                            Text("KEY_GALLERY").tag(2)
                        }
                        .padding()
                        .pickerStyle(.segmented)
                        .background(.bar)
                        .animation(.default, value: yarnInfoPickerEdge)
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack() {
                    Text(yarnInfo.name)
                        .fontWeight(.bold)
                    if yarnInfo.archiveFlg {
                        Image(systemName: "archivebox.fill")
                            .font(.subheadline)
                            .foregroundStyle(.cGreen)
                    }
                }
                .geometryGroup()
            }
            ToolbarItem(placement: .topBarTrailing) {
                // 編集ボタン
                Menu {
                    Button {
                        inputYarnInfo = InputYarnInfo.init(yarnInfo: yarnInfo)
                        if let wrappedMaterials = yarnInfo.materials{
                            let sortedMaterials = wrappedMaterials.sorted { $0.orderIndex < $1.orderIndex }
                            for material in sortedMaterials{
                                let input = InputYarnMaterial(
                                    orderIndex: material.orderIndex,
                                    materialId: material.materialId,
                                    percentage: material.percentage
                                )
                                inputYarnMaterials.append(input)
                            }
                        }
                        print(inputYarnMaterials.count)
                        showYarnEditSheet = true
                    } label: {
                        Label("KEY_EDIT_LABEL_INFO", systemImage: "pencil")
                    }
                    Divider()
                    Menu {
                        Picker(selection: $yarnInfoPickerEdge){
                            Label("KEY_TOP", systemImage: "arrow.up.to.line").tag(0)
                            Label("KEY_BOTTOM", systemImage: "arrow.down.to.line").tag(1)
                        } label: {
                            Label("KEY_DEFAULT_TAB", systemImage: "rectangle.expand.vertical")
                        }
                    } label: {
                        Label("KEY_TAB_EDGE", systemImage: "rectangle.expand.vertical")
                        Text(yarnInfoPickerEdge == 0 ? "KEY_TOP" : "KEY_BOTTOM")
                    }
                    Divider()
                    Button {
                        withAnimation{
                            yarnInfo.archiveFlg.toggle()
                            try? modelContext.save()
                        }
                    } label: {
                        Label(yarnInfo.archiveFlg ? "KEY_UNARCHIVE" : "KEY_ARCHIVE", systemImage: "archivebox.fill")
                    }
                } label: {
                    Label("KEY_SELECTION", systemImage: "ellipsis.circle")
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
            yarnInfo.folder = inputYarnInfo.folder
            yarnInfo.laundrySymbols = inputYarnInfo.laundrySymbols
            yarnInfo.images = inputYarnInfo.images
            // 素材情報の削除
            if let wrappedMaterials = yarnInfo.materials{
                for material in wrappedMaterials {
                    modelContext.delete(material)
                }
            }
            // 新たに素材情報を作成
            for (index, yarnMaterial) in inputYarnMaterials.enumerated() {
                let percentage = yarnMaterial.percentage ?? 0
                let newYarnMaterial = YarnMaterial(
                    yarnInfo: yarnInfo,
                    orderIndex: index,
                    materialId: yarnMaterial.materialId,
                    percentage: percentage,
                )
                modelContext.insert(newYarnMaterial)
            }
            
            try? modelContext.save()
        }
    }
}
#Preview {
    //    YarnsDetailView(yarnInfo: .constant(YarnInfo(name: "テスト毛糸", memo: "メモメモ", createdAt: Date())))
    YarnsDetailView()
        .environment(YarnInfo(name: "テスト毛糸", memo: "メモメモ"))
    //        .modelContainer(for: YarnInfo.self, inMemory: true)
}
