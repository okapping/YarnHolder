//
//  ContentView.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/03/10.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @Query var yarns: [YarnInfo]
    
    @State private var inputYarnInfo: InputYarnInfo = .init()
    @State private var inputYarnMaterials: [InputYarnMaterial] = [.init()]
    @State private var inputYarnStocks: [InputYarnStock] = []
    @State private var showNewYarnInfoSheet = false
    @State private var yarnsEditViewComplete = false
    
    @State private var showSettingsSheet = false

    @State private var selectedYarn: YarnInfo? = nil
    var body: some View {
        NavigationSplitView {
            List(yarns, id: \.self, selection: $selectedYarn){ yarn in
//                ForEach(yarns) { yarn in
//                    NavigationLink {
//                        YarnsDetailView(
//                            yarnInfo: yarn
//                        )
//                    } label: {// createImageView(for: getYarnSymbol(by: inputYarnInfo.symbolId))
                        HStack {
//                            Label(yarn.name, image: "yarn")
//                            Label(yarn.name, image: "yarn")
                            createImageView(for: getYarnSymbol(by: yarn.symbolId))
                                .frame(width: 24, height: 24)
                                .foregroundColor(.primary)
//                            Image("yarn")
                            Text(yarn.name)
                            Spacer()
                            ForEach(Array(yarn.stocks.sorted(by: { $0.orderIndex < $1.orderIndex }).enumerated()), id: \.element.id) { index, stock in
//                            ForEach(yarn.stocks.sorted(by: { $0.orderIndex < $1.orderIndex })){ stock in
                                if index < 3 {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(stock.sampleColor.color)
                                            .frame(width: 30, height: 30)
                                        Text("\(stock.inventory)")
                                            .fontWeight(.bold)
                                            .foregroundColor(stock.sampleColor.color.isLight ? .black : .white)
                                    }.padding(-6)
                                    
                                }
                            }
                            if yarn.stocks.count > 3 {
                                Image(systemName: "ellipsis")
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                    .fontWeight(.bold)
                            }

                        }
//                    }
//                }
//                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItemGroup {
                    EditButton()
//                    Button(action: addYarnInfo) {
//                        Label("Add Item", systemImage: "plus")
//                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        showSettingsSheet = true
                    } label: {
                        Label("KEY_SETTINGS", systemImage: "gearshape")
                    }
                    Spacer()
                    Button {
                        showNewYarnInfoSheet = true
                    } label: {
                        Label("KEY_ADD_YARN", image: "yarn.badge.plus")
//                        Label(
//                            title: {Text("KEY_ADD_YARN")},
//                            icon: {Image("yarn.badge.plus")}
//                        )
                    }
                }
            }
//        } detail: {
//            Text("Select an item")
            .navigationTitle("KEY_YARN_LIST")
            // 新規作成シート
            .sheet(isPresented: $showNewYarnInfoSheet, onDismiss: {
                //                inputEventsModel.folder = selectedFolder
                addYarnInfo()
            }, content: {
                YarnsEditView(
                    inputYarnInfo: $inputYarnInfo,
                    inputYarnMaterials: $inputYarnMaterials,
                    inputComplete: $yarnsEditViewComplete,
                    isEntry: true
                )
            })
            // 設定画面シート
            .sheet(isPresented: $showSettingsSheet, onDismiss: {
            }, content: {
                SettingsView()
                    .preferredColorScheme(colorScheme == .dark ? .dark : .light)
            })

        } detail: {
            if let yarn = selectedYarn {
                YarnsDetailView(yarnInfo: yarn)
            } else {
                ZStack {
                    Image("yarn")
                        .resizable()
                        .scaledToFit()
                        .frame(width: .infinity)
                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                    HStack {
                        Text("KEY_LET'S_CHOOSE_SOME_YARN")
                        Image(systemName: "music.quarternote.3")
                    }
                    .font(.largeTitle)
                    .fontWeight(.heavy)

                }
                .padding()
            }
            
//            if let yarn = selectedYarn {
//                YarnsDetailView(yarnInfo: yarn)
//            } else {
//                Text("未選択")
//            }
            
        }
    }

    private func addYarnInfo() {
        defer {
            inputYarnInfo = InputYarnInfo()
            inputYarnMaterials = [.init()]
            yarnsEditViewComplete = false
        }
        //
        if inputYarnInfo.name.isEmpty || !yarnsEditViewComplete {
            return
        }

        withAnimation {
            let newYarnInfo = YarnInfo(inputYarnInfo: inputYarnInfo)
            modelContext.insert(newYarnInfo)
            for (index, yarnMaterial) in inputYarnMaterials.enumerated() {
                //            let newYarnMaterial = YarnMaterial(yarnInfo: newYarnInfo, inputYarnMaterial: yarnMaterial)
                let percentage = yarnMaterial.percentage ?? 0
                let newYarnMaterial = YarnMaterial(
                    yarnInfo: newYarnInfo,
                    orderIndex: index,
                    materialId: yarnMaterial.materialId,
                    percentage: percentage,
                    createdAt: Date()
                )
                modelContext.insert(newYarnMaterial)
            }
        }

    }

//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(yarns[index])
//            }
//        }
//    }
}

#Preview {
    ContentView()
    //        .modelContainer(for: YarnInfo.self, inMemory: true)
        .modelContainer(previewYarn)
}
