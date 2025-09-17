//
//  FoldersListView.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/08/12.
//

import SwiftUI
import SwiftData


extension Optional where Wrapped == Folder {
    static var nilAsFolder: Wrapped? {
        nil
    }
}

struct FoldersListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @Query var folders: [Folder]
    @Query var yarns: [YarnInfo]

    @Binding var selectedFolder: Folder?
    @Binding var selectedYarn: YarnInfo?

    @State private var showSettingsSheet = false

    // フォルダ関連
    @State private var showFolderAddSheet = false
    @State private var showFolderEditSheet = false
    @State private var inputFolder: InputFolder = .init()
    @State private var foldersEditViewComplete = false

    @State private var tmpEditFolder: Folder? = nil
    @State private var tmpDeleteFolder: Folder? = nil
    @State private var showFolderDeleteSheet = false
    // 新規毛糸作成
    @State private var inputYarnInfo: InputYarnInfo = .init()
    @State private var inputYarnMaterials: [InputYarnMaterial] = [.init()]

//    var countAllYarns: Int {
//        var cnt: Int = 0
//        for item in folders {
//            cnt = cnt + item.yarns.count
//        }
//        return cnt
//    }
    var body: some View {
        List(selection: $selectedFolder) {
            Section {
                //                    Button {
                //                        selectedFolder = nil
                //                    } label: {
                //                        Label("ボタン", systemImage: "folder.fill")
                //                    }
                //                    NavigationLink("KEY_ALL_YARNS", value: Optional<Folder>.none)
                //                        .tag(Optional.nilAsFolder)
                NavigationLink {
                    YarnsListView(folder: selectedFolder, selectedYarn: $selectedYarn)
                } label: {
                    HStack{
                        Label("KEY_ALL_YARNS", image: "yarn")
                        Spacer()
//                        Text("\(folders.reduce(0) { $0 + $1.yarns.count })")
                        Text("\(yarns.count)")
                        //                                .font(.caption)
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: .rounded))

                    }
                }
                //                    Label("KEY_ALL_YARNS", image: "yarn")
                //                        .tag(Optional.nilAsFolder)
                //                        .tag(Optional<Folder>.none)
                //                    .tag(Folder?(nil))
                //                        .onTapGesture {
                //                            selectedFolder = nil // 全ての毛糸が選択されたときにnilを設定
                //                        }
                
            }
            Section(
                header: ListTitleView(title: "KEY_FOLDER")
            ) {
                //                    Label("KEY_ALL_YARNS", image: "yarn")
                //                        .tag(Optional.nilAsFolder)
                ForEach(folders.sorted(by: { $0.orderIndex < $1.orderIndex })) { folder in
                    //                        Label(folder.name, systemImage: "folder")
                    //                            .tag(Optional(folder))
                    NavigationLink(value: folder){
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
                            Text("\(folder.yarns.count)")
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.secondary)
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
        }
//        .navigationTitle("KEY_FOLDER")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    showSettingsSheet = true
                } label: {
                    Label("KEY_SETTINGS", systemImage: "gearshape")
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                
                Spacer()
                Button {
                    showFolderAddSheet = true
                } label: {
                    Label("フォルダ作成", systemImage: "folder.badge.plus")
                }
            }

        }
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
                for yarn in folder.yarns {
                    for material in yarn.materials {
                        modelContext.delete(material)
                    }
                    for stock in yarn.stocks {
                        for detail in stock.details {
                            modelContext.delete(detail)
                        }
                        try? modelContext.save()
                        modelContext.delete(stock)
                    }
                    for swatch in yarn.swatches {
                        modelContext.delete(swatch)
                    }
                    try? modelContext.save()
                    modelContext.delete(yarn)
                    try? modelContext.save()

                }
                try? modelContext.save()
                modelContext.delete(folder)
                try? modelContext.save()
            }
        }
    }
//
//    private func deleteTag(deleteTag: Tag) {
//        modelContext.delete(deleteTag)
//    }
}
