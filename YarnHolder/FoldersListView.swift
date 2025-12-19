//
//  FoldersListView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/08/12.
//

import SwiftUI
import SwiftData

struct FoldersListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @Query var folders: [Folder]
    @Query var tags: [Tag]
    @Query var yarns: [YarnInfo]

//    @Binding var selectedFolder: Folder?
//    @Binding var selectedYarn: YarnInfo?

    @State private var showSettingsSheet = false

    // フォルダ関連
    @State private var showFolderAddSheet = false
    @State private var showFolderEditSheet = false
    @State private var inputFolder: InputFolder = .init()
    @State private var foldersEditViewComplete = false

    @State private var tmpEditFolder: Folder? = nil
    @State private var tmpDeleteFolder: Folder? = nil
    @State private var showFolderDeleteSheet = false
    
    // タグ
    @State private var showTagAddSheet = false
    @State private var showTagEditSheet = false
    @State private var inputTag: InputTag = .init()
    @State private var tagEditViewComplete = false
    @State private var tmpEditTag: Tag? = nil

//
//    @State private var tmpEditFolder: Folder? = nil
//    @State private var tmpDeleteFolder: Folder? = nil
//    @State private var showFolderDeleteSheet = false

    // 新規毛糸作成
    @State private var inputYarnInfo: InputYarnInfo = .init()
    @State private var inputYarnMaterials: [InputYarnMaterial] = [.init()]

    var countAllStocks: Int {
        var cnt: Int = 0
        for yarn in yarns {
            if let wrappedStocks = yarn.stocks {
                cnt = cnt + wrappedStocks.count
            }
        }
        return cnt
    }
    var body: some View {
        List(/*selection: $selectedFolder*/) {
            Section {
                //                    NavigationLink("KEY_ALL_YARNS", value: Optional<Folder>.none)
                //                        .tag(Optional.nilAsFolder)
                NavigationLink {
//                    YarnsListView(/*folder: selectedFolder, selectedYarn: $selectedYarn*/)
                    YarnsListView()
                } label: {
                    HStack{
                        Label("KEY_ALL_YARNS", image: "yarn")
                        Spacer()
                        Text("\(yarns.count)")
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: .rounded))

                    }
                }
                NavigationLink{
                    StocksListView()
                } label: {
                    HStack{
                        Label("KEY_ALL_STASH", systemImage: "basket")
                        Spacer()
                        Text("\(countAllStocks)")
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: .rounded))
                        
                    }
                }
            }
            // ****************************************************
            // フォルダ一覧
            Section(
                header:
                    HStack{
                        ListTitleView(title: "KEY_FOLDER")
                        Spacer()
                        Button{
                            showFolderAddSheet = true
                        } label: {
                            //                            ListTitleButtonView(title: "KEY_ADD")
                            Label("KEY_ADD", systemImage: "folder.badge.plus")
                                .fontWeight(.bold)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .buttonBorderShape(.capsule)
                        .sensoryFeedback(.success, trigger: showFolderAddSheet)
                    }
            ) {
                ForEach(folders.sorted(by: { $0.orderIndex < $1.orderIndex })) { folder in
                    //                        Label(folder.name, systemImage: "folder")
                    //                            .tag(Optional(folder))
                    NavigationLink{
                        YarnsListView(folder: folder)
                    } label:{
                        //                        NavigationLink(value: folder){
                        HStack{
                            Label(
                                title: {
                                    Text(folder.name)
                                },icon: {
                                    Image(systemName: "folder")
                                    //                                        .font(.headline)
                                        .foregroundColor(folder.color)
                                }
                            )
                            //                            Label(folder.name, systemImage: "folder")
                            Spacer()
                            if let wrappedYarns = folder.yarns{
                                Text("\(wrappedYarns.count)")
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                        }
                        //                        Label(folder.name, systemImage: "folder")
                    }
                    .padding(.vertical, 4)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        // スワイプ＞削除
                        Button(/*role: .destructive*/) {
                            tmpDeleteFolder = folder
                            showFolderDeleteSheet = true
                            
                        } label: {
                            Label("KEY_DELETE", systemImage: "trash.fill")
                        }
                        .tint(.red)
                        // スワイプ＞更新
                        Button {
                            tmpEditFolder = folder
                            inputFolder.name = folder.name
                            inputFolder.colorName = folder.colorName
                            showFolderEditSheet = true
                        } label: {
                            Label("KEY_EDIT", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                    
                }
                .onMove(perform: moveFolder)
            }
            // ****************************************************
            // タグ一覧
            Section(
                header:
                    HStack{
                        ListTitleView(title: "KEY_TAG")
                        Spacer()
                        Button{
                            showTagAddSheet = true
                        } label: {
                            //                            ListTitleButtonView(title: "KEY_ADD")
                            Label("KEY_ADD", systemImage: "plus")
                                .fontWeight(.bold)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .buttonBorderShape(.capsule)
                        .sensoryFeedback(.success, trigger: showTagAddSheet)
                    }
            ) {
                ForEach(tags.sorted(by: { $0.orderIndex < $1.orderIndex })) { tag in
                    NavigationLink{
                        YarnsListView(tag: tag)
                    } label:{
                        HStack{
                            TaglabelView(tag: tag)
//                            Label(
//                                title: {
//                                    Text(tag.name)
//                                },icon: {
//                                    Image(systemName: "number")
//                                        .foregroundColor(tag.color)
//                                }
//                            )
                            Spacer()
                            if let wrappedYarns = tag.yarns{
                                Text("\(wrappedYarns.count)")
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(.secondary)

                            }
                        }
                    }
                    .padding(.vertical, 4)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
//                        // スワイプ＞削除
                        Button(role: .destructive) {
                            deleteTag(deleteTag: tag)
                            
                        } label: {
                            Label("KEY_DELETE", systemImage: "trash.fill")
                        }
                        .tint(.red)
//                        // スワイプ＞更新
                        Button {
                            tmpEditTag = tag
                            inputTag.name = tag.name
                            inputTag.color = tag.color.color
                            showTagEditSheet = true
                        } label: {
                            Label("KEY_EDIT", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                    
                }
                .onMove(perform: moveTag)
            }
        }
        .navigationTitle("KEY_STASH")
//        .toolbarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItemGroup(placement: .topBarLeading) {
//                Button {
//                    showSettingsSheet = true
//                } label: {
//                    Label("KEY_SETTINGS", systemImage: "gearshape")
//                }
//            }
//            ToolbarItemGroup(placement: .bottomBar) {
//                
//                Spacer()
//                Button {
//                    showFolderAddSheet = true
//                } label: {
//                    Label("フォルダ作成", systemImage: "folder.badge.plus")
//                }
//            }

//        }
        // フォルダ作成画面シート
        .sheet(isPresented: $showFolderAddSheet, onDismiss: {
            // フォルダ作成処理
            addFolder()
        }, content: {
            FoldersEditView(
                inputFolder: $inputFolder,
                inputComplete: $foldersEditViewComplete,
                isEntry: true
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
        // フォルダ削除確認用
        .actionSheet(isPresented: $showFolderDeleteSheet){
            ActionSheet(
                title: Text("KEY_DELETE_FOLDER_CONFIRM"),
                //                message: Text("削除後は戻せません。削除してもよろしいですか？"),
                buttons:[
                    .destructive(Text("KEY_DELETE")){
                        deleteFolder()
                    },
                    .cancel()
                ]
            )
        }
        // タグ作成画面シート
        .sheet(isPresented: $showTagAddSheet, onDismiss: {
            // タグ作成処理
            addTag()
        }, content: {
            TagsEditView(
                inputTag: $inputTag,
                inputComplete: $tagEditViewComplete,
                isEntry: true
            )
        })
        // タグ編集画面シート
        .sheet(isPresented: $showTagEditSheet, onDismiss: {
            // タグ作成処理
            editTag()
        }, content: {
            TagsEditView(
                inputTag: $inputTag,
                inputComplete: $tagEditViewComplete,
                isEntry: false
            )
        })

        // 設定画面シート
        .sheet(isPresented: $showSettingsSheet, onDismiss: {
        }, content: {
            SettingsView()
                .preferredColorScheme(colorScheme == .dark ? .dark : .light)
        })

    }
    private func addFolder() {
        defer {
            inputFolder = .init()
            foldersEditViewComplete = false
        }
        //
        if !foldersEditViewComplete {
            return
        }
        
        withAnimation {
            let newFolder = Folder(
                orderIndex: folders.count,
                name: inputFolder.name,
                colorName: inputFolder.colorName
            )
            modelContext.insert(newFolder)
        }
    }
    private func editFolder() {
        defer {
            inputFolder = .init()
            foldersEditViewComplete = false
        }
        //
        if !foldersEditViewComplete {
            return
        }
        
        withAnimation {
//            let colorComponents = ColorComponents.fromColor(inputFolder.color)
            
            if let folder = tmpEditFolder {
                folder.name = inputFolder.name
                folder.colorName = inputFolder.colorName
            }
            try? modelContext.save()
        }
    }
    private func moveFolder(from source: IndexSet, to destination: Int) {
        var updatedFolders = folders.sorted(by: { $0.orderIndex < $1.orderIndex })
        updatedFolders.move(fromOffsets: source, toOffset: destination)
        withAnimation {
            for (index, item) in updatedFolders.enumerated() {
                item.orderIndex = index
            }
            try? modelContext.save()
        }
    }
    private func deleteFolder() {
        withAnimation {
            if let folder = tmpDeleteFolder {
                if let wrappedYarns = folder.yarns{
                    for yarn in wrappedYarns {
                        if let wrappedMaterials = yarn.materials{
                            for material in wrappedMaterials {
                                modelContext.delete(material)
                            }
                        }
                        if let wrappedStocks = yarn.stocks{
                            for stock in wrappedStocks {
                                if let wrappedDetails = stock.details{
                                    for detail in wrappedDetails {
                                        modelContext.delete(detail)
                                    }
                                }
                                try? modelContext.save()
                                modelContext.delete(stock)
                            }
                        }
                        if let wrappedSwatches = yarn.swatches{
                            for swatch in wrappedSwatches {
                                modelContext.delete(swatch)
                            }
                        }
                        try? modelContext.save()
                        modelContext.delete(yarn)
                        try? modelContext.save()
                    }
                }
                try? modelContext.save()
                modelContext.delete(folder)
                try? modelContext.save()
            }
        }
    }
    private func addTag() {
        defer {
            inputTag = .init()
            tagEditViewComplete = false
        }
        //
        if !tagEditViewComplete {
            return
        }
        
        withAnimation {
            let colorComponents = ColorComponents.fromColor(inputTag.color)
            
            let newTag = Tag(
                orderIndex: tags.count,
                name: inputTag.name,
                color: colorComponents
            )
            modelContext.insert(newTag)
        }
    }
    private func editTag() {
        defer {
            inputTag = .init()
            tagEditViewComplete = false
        }
        //
        if !tagEditViewComplete {
            return
        }
        
        withAnimation {
            let colorComponents = ColorComponents.fromColor(inputTag.color)
            
            if let tag = tmpEditTag {
                tag.name = inputTag.name
                tag.color = colorComponents
            }
            try? modelContext.save()
        }
    }
    private func deleteTag(deleteTag: Tag) {
        modelContext.delete(deleteTag)
    }
    private func moveTag(from source: IndexSet, to destination: Int) {
        var updatedTags = tags.sorted(by: { $0.orderIndex < $1.orderIndex })
        updatedTags.move(fromOffsets: source, toOffset: destination)
        withAnimation {
            for (index, item) in updatedTags.enumerated() {
                item.orderIndex = index
            }
            try? modelContext.save()
        }
    }

//
//    private func deleteTag(deleteTag: Tag) {
//        modelContext.delete(deleteTag)
//    }
}
