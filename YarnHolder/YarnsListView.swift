//
//  YarnsListView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/08/11.
//

import SwiftUI
import SwiftData

struct YarnsSearchContainer: Identifiable {
    var id = UUID()
    var name: String = ""
    var tags: [Tag] = []
    
    var isInitialState: Bool {
        return name.isEmpty && tags.isEmpty
    }

}

struct YarnsListView: View {
    @Environment(\.modelContext) private var modelContext

    @AppStorage("appColorTheme") var appColorTheme = 10
    //        .tint(Color(getColorTheme(by: appColorTheme).sysName))
    @AppStorage("showYarnsListOrder") var showYarnsListOrder = 1
    @AppStorage("YarnsListOrderDirection") var YarnsListOrderDirection = 0
    @AppStorage("yarnsListDisplayMode") var yarnsListDisplayMode = 0
    @AppStorage("unlockFeature") var unlockFeature: Bool = false
    
    var folder: Folder? = nil
    var tag: Tag? = nil
//    var yarns: [YarnInfo]
    @Query var yarns: [YarnInfo]
//    @Binding var selectedYarn: YarnInfo?
    
    @State private var showPinList: Bool = true
    @State private var showArchiveList: Bool = false

    @State private var inputYarnInfo: InputYarnInfo = .init()
    @State private var inputYarnMaterials: [InputYarnMaterial] = [.init()]
//    @State private var inputYarnStocks: [InputYarnStock] = []
    @State private var showNewYarnInfoSheet = false
    @State private var yarnsEditViewComplete = false
    
    // folder edit
    @State private var showFolderEditSheet = false
    @State private var foldersEditViewComplete = false
    @State private var inputFolder: InputFolder = .init()

    @State private var showYarnsSearchSheet = false
    @State private var searchData: YarnsSearchContainer = .init()
    
    
//    public var folderAccentColor: Color {
//        if let folder = folder {
//            return folder.color.color
//        } else {
//            return Color.secondary
//        }
//    }
    public var pinYarns : [YarnInfo] {
        return yarns.filter({ $0.pinFlg && !$0.archiveFlg })
    }
    public var notPinYarns : [YarnInfo] {
        return yarns.filter({ !$0.pinFlg && !$0.archiveFlg })
    }
    public var archiveYarns : [YarnInfo] {
        return yarns.filter({ $0.archiveFlg })
    }
    public func sortedYarns(from yarns: [YarnInfo]) -> [YarnInfo] {
        
        let filteredYarns = yarns.filter{ yarn in
            
            // selectedFolderがnilの場合は全件を表示
            var matchesFolder = true
            var matchesTag = true
            if let folder = folder {
                matchesFolder = yarn.folder == folder
            }
            if let tag = tag {
                if let wrappedTags = yarn.tags{
                    matchesTag = wrappedTags.contains(tag)
                }
            }
//            let matchesFolder = folder == nil || yarn.folder == folder
//            let matchesTag = tag == nil || yarn.tags.contains(tag)
            
            // ******************************
            // 検索時↓
            var searchName: Bool = true
            var searchTag: Bool = true
            searchName = searchData.name.isEmpty ||
            yarn.name.contains(searchData.name)
            
            searchTag = searchData.tags == []
            if let wrappedTags = yarn.tags{
                searchTag = searchTag || searchData.tags.allSatisfy { wrappedTags.contains($0) }
            }
//            yarn.tags.contains {searchData.tags.contains($0) }

            return matchesFolder && matchesTag && searchName && searchTag
        }
        // 手動（不使用）
//        if showYarnsListOrder == 0{
//            return filteredYarns.sorted(by: { $0.orderIndex < $1.orderIndex })
//        }
        // 作成日潤
        if showYarnsListOrder == 1 && YarnsListOrderDirection == 0 {
            return filteredYarns.sorted(by: { $0.createdAt < $1.createdAt })
        } else if  showYarnsListOrder == 1 && YarnsListOrderDirection == 1 {
            return filteredYarns.sorted(by: { $0.createdAt > $1.createdAt })
        }
        // 毛糸名順
        else if showYarnsListOrder == 2 && YarnsListOrderDirection == 0 {
            return filteredYarns.sorted(by: { $0.name < $1.name })
        } else if showYarnsListOrder == 2 && YarnsListOrderDirection == 1 {
            return filteredYarns.sorted(by: { $0.name > $1.name })
        }
        // 在庫数順
        else if  showYarnsListOrder == 3 && YarnsListOrderDirection == 0 {
            return filteredYarns.sorted(by: { $0.stocksCount < $1.stocksCount })
        } else if  showYarnsListOrder == 3 && YarnsListOrderDirection == 1 {
            return filteredYarns.sorted(by: { $0.stocksCount > $1.stocksCount })
        }
        // 例外処理
        else {
            return yarns
        }
    }
    
    public var orderName: String {
        if showYarnsListOrder == 1 {
            return "KEY_SORT_BY_DATE"
        } else if  showYarnsListOrder == 2 {
            return "KEY_SORT_BY_NAME"
        } else {
            return "KEY_SORT_BY_STOCK"
        }
    }
    public var sortName: String {
        if YarnsListOrderDirection == 0 {
            return "KEY_SORT_ASCENDING"
        } else {
            return "KEY_SORT_DESCENDING"
        }
    }
    public var titleName: String {
        if let folder = folder {
            return folder.name
        }
        if let tag = tag {
            return tag.name
        }
        return String(localized: "KEY_ALL_YARNS")
    }
    

    var body: some View {
//        NavigationStack{
            List(/*selection: $selectedYarn*/){
                // *************************************************************
                // ピン
                if sortedYarns(from: pinYarns).count > 0 {
                    Section(
                        isExpanded: $showPinList
                        
                    ) {
                        ForEach(sortedYarns(from: pinYarns)/*, id: \.id*/) { yarn in
                            NavigationLink{
                                YarnsDetailView(yarnInfo: yarn)
                            } label:{
                                YarnsListDetailView(yarn: yarn, folder: folder)
                            }
                            
                            //                            YarnsListDetailView(yarn: yarn)
                        }
//                        .listRowSeparatorTint(Color(getColorTheme(by: appColorTheme).sysName))
                    } header: {
                        HStack {
                            ListTitleView(title: "KEY_PIN")
                            Spacer()
                            Text("\(sortedYarns(from: pinYarns).count)")
//                                .font(.caption)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                        
                    }
                }
                // *************************************************************
                // 通常毛糸
                Section(
                    header:
                        HStack{
//                            ListTitleView(title: "")
                            if !unlockFeature {
                                Text("KEY_TOTAL_COUNT\(String(yarns.count))")
                            }
                            Spacer()
                            Button{
                                inputYarnInfo.folder = folder
                                if let tag = tag{
                                    inputYarnInfo.tags.append(tag)
                                }
                                showNewYarnInfoSheet = true
                            } label: {
                                //                            ListTitleButtonView(title: "KEY_ADD")
                                Label("KEY_ADD", image: "yarn.badge.plus")
                                    .fontWeight(.bold)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                            .buttonBorderShape(.capsule)
                            .sensoryFeedback(.success, trigger: showNewYarnInfoSheet)
                            .disabled(!unlockFeature && yarns.count >= 5)
                        }
                ) {
                    ForEach(sortedYarns(from: notPinYarns)/*, id: \.id*/) { yarn in
                        NavigationLink{
                            YarnsDetailView(yarnInfo: yarn)
                        } label:{
                            YarnsListDetailView(yarn: yarn, folder: folder)
                        }
//                        YarnsListDetailView(yarn: yarn)
                    }
//                    .listRowSeparatorTint(Color(getColorTheme(by: appColorTheme).sysName))
//                    .onMove(perform: moveYarnInfo)
//                    .moveDisabled(showYarnsListOrder != 0)
                }
                // *************************************************************
                // アーカイブ
                if sortedYarns(from: archiveYarns).count > 0 {
                    Section(
                        isExpanded: $showArchiveList
                        
                    ) {
                        ForEach(sortedYarns(from: archiveYarns)/*, id: \.id*/) { yarn in
                            NavigationLink{
                                YarnsDetailView(yarnInfo: yarn)
                            } label:{
                                YarnsListDetailView(yarn: yarn, folder: folder)
                            }
                            //                            YarnsListDetailView(yarn: yarn)
                        }
//                        .listRowSeparatorTint(Color(getColorTheme(by: appColorTheme).sysName))
                    } header: {
                        HStack {
                            ListTitleView(title: "KEY_ARCHIVED")
                            Spacer()
                            Text("\(sortedYarns(from: archiveYarns).count)")
                                .font(.body)
//                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                    }
                }
            }
//            .navigationDestination(for: YarnInfo.self){ yarn in
//                YarnsDetailView(yarnInfo: yarn)
//            }
            .animation(.smooth, value: yarnsListDisplayMode)
            .environment(\.defaultMinListRowHeight, 50)
            // 検索保留！
//            .searchable(text: $searchData.name)
//            .searchSuggestions {
//                Section{
//                    ForEach(searchedYarns(from: yarns), id: \.self) { yarn in
//                        NavigationLink(value: yarn){
//                            YarnsListDetailView(yarn: yarn, folder: folder)
//                        }
//
//                    }
//                }
//            }
//            .tint(folderAccentColor)
            .listStyle(.sidebar)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button{
                        showYarnsSearchSheet = true
                    }label: {
                        Image(systemName: searchData.isInitialState ? "magnifyingglass.circle" :"magnifyingglass.circle.fill")
                        .contentTransition(.symbolEffect(.replace.offUp))
//                        .symbolEffect(.wiggle.byLayer, options: .repeat(.periodic(delay: 2.0)), value: !searchData.isInitialState)
                    }
                    
                    // 編集ボタン
                    Menu {
                        Button {
                            inputYarnInfo.folder = folder
                            if let tag = tag{
                                inputYarnInfo.tags.append(tag)
                            }
                            showNewYarnInfoSheet = true
                        } label: {
                            Label("KEY_ADD_YARN", image: "yarn.badge.plus")
                        }
                        .disabled(!unlockFeature && yarns.count >= 5)
                        Menu {
                            Picker(
                                selection: $showYarnsListOrder.animation(),
                                label: Label("KEY_SORT_ORDER", systemImage: "list.number")
                            ) {
//                                Label("手動", systemImage: "gear").tag(0)
                                Label("KEY_SORT_BY_DATE", systemImage: "calendar").tag(1)
                                Label("KEY_SORT_BY_NAME", systemImage: "textformat.characters").tag(2)
                                Label("KEY_SORT_BY_STOCK", systemImage: "basket").tag(3)
                            }
                            Picker(
                                selection: $YarnsListOrderDirection.animation(),
                                label: Label("順序", systemImage: "arrow.up.arrow.down")
                            ) {
                                Label("KEY_SORT_ASCENDING", systemImage: "arrow.up").tag(0)
                                Label("KEY_SORT_DESCENDING", systemImage: "arrow.down").tag(1)
                            }.disabled(showYarnsListOrder == 0)


                        } label: {
                            Label("KEY_SORT_ORDER", systemImage: "list.number")
                            Text(LocalizedStringKey(orderName)) +
                            Text(" - ") +
                            Text(LocalizedStringKey(sortName))

//                            Text("\(LocalizedStringKey(orderName)) - \(LocalizedStringKey(sortName))")
//                            Text("\(String(localized: orderName)) - \(String(localized: sortName))")
                        }
                        Menu {
                            Picker(
                                selection: $yarnsListDisplayMode.animation(),
                                label: Label("KEY_DISPLAY_SETTINGS", systemImage: "list.bullet")
                            ) {
                                Label("KEY_SIMPLE_VIEW", systemImage: "list.bullet").tag(0)
                                Label("KEY_DETAILED_LIST", systemImage: "rectangle.grid.1x2").tag(1)
                            }

                        } label: {
                            Label("KEY_DISPLAY_SETTINGS", systemImage: "list.bullet")
                            Text(yarnsListDisplayMode == 0 ? "KEY_SIMPLE_VIEW" : "KEY_DETAILED_LIST")
                        }
                        if let folder = folder {
                            Button {
                                inputFolder.name = folder.name
                                inputFolder.colorName = folder.colorName
                                showFolderEditSheet = true
                            } label: {
                                Label("KEY_EDIT_FOLDER", systemImage: "folder.badge.gearshape")
                            }
                        }
                    } label: {
                        Label("KEY_SELECTION", systemImage: "ellipsis.circle")
                    }
                }
//                ToolbarItemGroup(placement: .bottomBar) {
//                    Spacer()
//                    Button {
//                        inputYarnInfo.folder = folder
//                        if let tag = tag{
//                            inputYarnInfo.tags.append(tag)
//                        }
//                        showNewYarnInfoSheet = true
//                    } label: {
//                        Label("KEY_ADD_YARN", image: "yarn.badge.plus")
//                    }
//                }
            }
            .navigationTitle(titleName)
            .toolbarTitleDisplayMode(.large)
            // 新規作成シート
            .sheet(isPresented: $showNewYarnInfoSheet, onDismiss: {
                addYarnInfo()
            }, content: {
                YarnsEditView(
                    inputYarnInfo: $inputYarnInfo,
                    inputYarnMaterials: $inputYarnMaterials,
                    inputComplete: $yarnsEditViewComplete,
                    isEntry: true,
                    selectFolder: folder
                )
            })
        // フォルダ編集画面シート
            .sheet(isPresented: $showFolderEditSheet, onDismiss: {
                // フォルダ作成処理
                editFolder()
            }, content: {
                FoldersEditView(
                    inputFolder: $inputFolder,
                    inputComplete: $foldersEditViewComplete,
                    isEntry: false
                )
            })
        // 毛糸検索画面シート
            .sheet(isPresented: $showYarnsSearchSheet, onDismiss: {
            }, content: {
                YarnsSearchView(
                    searchData: $searchData
                )
                .presentationDetents([.medium])
            })

//        }
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
            let newYarnInfo = YarnInfo(inputYarnInfo: inputYarnInfo, index: yarns.count)
//            newYarnInfo.folder = folder
            modelContext.insert(newYarnInfo)
            for (index, yarnMaterial) in inputYarnMaterials.enumerated() {
                //            let newYarnMaterial = YarnMaterial(yarnInfo: newYarnInfo, inputYarnMaterial: yarnMaterial)
                let percentage = yarnMaterial.percentage ?? 0
                let newYarnMaterial = YarnMaterial(
                    yarnInfo: newYarnInfo,
                    orderIndex: index,
                    materialId: yarnMaterial.materialId,
                    percentage: percentage,
//                    createdAt: Date()
                )
                modelContext.insert(newYarnMaterial)
            }
        }
        
    }
    private func moveYarnInfo(from source: IndexSet, to destination: Int) {
        var updatedYarnInfo = yarns.sorted(by: { $0.orderIndex < $1.orderIndex })
        updatedYarnInfo.move(fromOffsets: source, toOffset: destination)
        withAnimation {
            for (index, item) in updatedYarnInfo.enumerated() {
                item.orderIndex = index
            }
            try? modelContext.save()
        }
    }
    private func editFolder() {
        defer {
            inputFolder = .init()
            foldersEditViewComplete = false
        }
        if !foldersEditViewComplete {
            return
        }
        withAnimation {
            if let f = folder {
                f.name = inputFolder.name
                f.colorName = inputFolder.colorName
            }
            try? modelContext.save()
        }
    }

}
 
#Preview{
    @Previewable @State var yarnInfo: [YarnInfo] = [.init()]
    @Previewable @State var selectedYarn: YarnInfo? = nil
//    @Previewable @State var inputYarnMaterials: [InputYarnMaterial] = [.init()]
//    @Previewable @State var inputComplete = false
//    @Previewable @State var isEntry = false

    NavigationStack {
        YarnsListView(/*selectedYarn: $selectedYarn*/)
        // .modelContainer(previewYarn)
    }
//    YarnsListView(yarns: yarnInfo, selectedYarn: $selectedYarn)
}
