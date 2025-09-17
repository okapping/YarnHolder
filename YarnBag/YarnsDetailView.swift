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
//    @AppStorage("defaultYarnInfoTab") var defaultYarnInfoTab = 0
    
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

    // Laundry Symbol
    @State private var showPopoverId = 0
    @State private var showPopoverFlg = false

//    // delete yarn
//    @State private var showYarnDeleteSheet = false
//    @Environment(\.presentationMode) var presentation

    @State var selectedTab: Int = 0
    
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
                    Text("KEY_LABEL_INFO").tag(0)
                    Text("KEY_ADDITIONAL_INFO").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
//                .background(yarnInfo.symbolColor.opacity(0.25))
                .cornerRadius(8)
//                .padding()
                .padding(.horizontal)
                .padding(.bottom)
                .background(.bar)
                TabView(selection: $selectedTab) {
                    // 基本情報
                    YarnsDetailLabelInfoView(yarnInfo: yarnInfo)
                        .tag(0)
                    // 追加情報
                    YarnsDetailAdditionalInfoView(yarnInfo: yarnInfo)
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
                .animation(.easeIn, value: selectedTab)
//            }
            }

        }
//        .tint(yarnInfo.symbolColor)
//        }
        .toolbarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
//        .safeAreaInset(edge: .top) {
//            Picker("", selection: $selectedTab) {
//                Text("KEY_LABEL_INFO").tag(0)
//                Text("KEY_ADDITIONAL_INFO").tag(1)
//            }
//            .padding(.horizontal)
//            .padding(.bottom)
//            .pickerStyle(.segmented)
//            .background(.bar) // Thanks @BenzyKneez
//        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(alignment: .center) {
//                    createImageView(for: getYarnSymbol(by:yarnInfo.symbolId))
//                        .foregroundColor(yarnInfo.symbolColor)
//                        .font(.subheadline)
                    Text(yarnInfo.name)
                        .fontWeight(.bold)
                        .animation(.bouncy)
                    if yarnInfo.archiveFlg {
                        Image(systemName: "archivebox.fill")
//                            .foregroundColor(yarnInfo.symbolColor)
                            .font(.subheadline)
                            .transition(.symbolEffect(.disappear))
                            .foregroundStyle(.cGreen)
                    }
                }
//                .animation(.smooth, value: yarnInfo.archiveFlg)
            }
            ToolbarItem(placement: .topBarTrailing) {
                // 編集ボタン
                Menu {
//                    Menu {
//                        Picker(selection: $defaultYarnInfoTab){
//                            Label("KEY_LABEL_INFO", systemImage: "tag.fill").tag(0)
//                            Label("KEY_ADDITIONAL_INFO", systemImage: "sparkles.square.filled.on.square").tag(1)
//                        } label: {
//                            Label("KEY_DEFAULT_TAB", systemImage: "square.stack.3d.down.forward.fill")
//                        }
//                    } label: {
//                        Label("KEY_DEFAULT_TAB", systemImage: "square.stack.3d.down.forward.fill")
//                    }
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
                        Label("KEY_EDIT_LABEL_INFO", systemImage: "pencil")
                    }
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
//                .tint(yarnInfo.symbolColor)
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
        .onAppear{
//            selectedTab = defaultYarnInfoTab
        }
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
//            yarnInfo.symbolId = inputYarnInfo.symbolId
//            yarnInfo.symbolColorName = inputYarnInfo.symbolColorName
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
//                    createdAt: Date()
                )
                modelContext.insert(newYarnMaterial)
            }

            try? modelContext.save()
        }
    }
}
#Preview {
//    YarnsDetailView(yarnInfo: .constant(YarnInfo(name: "テスト毛糸", memo: "メモメモ", createdAt: Date())))
//    YarnsDetailView(yarnInfo: YarnInfo(name: "テスト毛糸", memo: "メモメモ", createdAt: Date()))
//        .modelContainer(for: YarnInfo.self, inMemory: true)
}
