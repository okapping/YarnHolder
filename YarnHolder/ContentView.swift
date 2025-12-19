//
//  ContentView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/03/10.
//

import SwiftUI
import SwiftData


//extension Optional where Wrapped == Folder {
//    static var nilAsFolder: Wrapped? {
//        nil
//    }
//}


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @Query var stockStatus: [YarnStockStatus]
    
    @AppStorage("appColorTheme") var appColorTheme = 10
    
//    @Query var yarns: [YarnInfo]
//    @Query var folders: [Folder]

//    @State private var inputYarnInfo: InputYarnInfo = .init()
//    @State private var inputYarnMaterials: [InputYarnMaterial] = [.init()]
//    @State private var inputYarnStocks: [InputYarnStock] = []
//    @State private var showNewYarnInfoSheet = false
//    @State private var yarnsEditViewComplete = false
    
//    @State private var showSettingsSheet = false

//    @State private var selectedFolder: Folder? = nil
    @State private var selectedYarn: YarnInfo? = nil

    @State private var preferredColumn = NavigationSplitViewColumn.content
    @State private var visibility: NavigationSplitViewVisibility = .all
//    public var dynamicAccentColor: Color {
//        if let yarn = selectedYarn {
//            return yarn.symbolColor
//        }
//        if let folder = selectedFolder {
//            return folder.color
//        } else {
//            return Color.secondary
//        }
//    }

    @Query var stockStatuses: [YarnStockStatus]
    public func FirstLaunch() {
        
        // 初期在庫ステータスを設定する
        // 最初のcloudkitの読み込み時間として、10秒後に処理を行う。
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            if stockStatuses.isEmpty {
                let statuses = [String(localized: "KEY_NEW"),String(localized: "KEY_UNWOUND"),String(localized: "KEY_RESTORED"),String(localized: "KEY_UNAVAILABLE")]
                //            let statuses = ["KEY_NEW","KEY_UNWOUND","KEY_RESTORED","KEY_UNAVAILABLE"]
                // yarn stock status
                for i in 0..<statuses.count {
                    //                let localName = LocalizedStringKey(statuses[i])
                    let newStatus = YarnStockStatus(
                        orderIndex: i,
                        name: statuses[i],
                        isDefault: i == 0
                    )
                    modelContext.insert(newStatus)
                }
            }
        }
    }
    // フォルダ関連
//    @State private var showFolderAddSheet = false
//    @State private var inputFolder: InputFolder = .init()
//    @State private var foldersEditViewComplete = false
    
    var body: some View {
        TabView{
            NavigationSplitView(columnVisibility: $visibility) {
                //            NavigationSplitView(/*preferredCompactColumn: $preferredColumn*/) {
                FoldersListView()
                //            FoldersListView(/*selectedFolder: $selectedFolder, selectedYarn: $selectedYarn*/)
            } content: {
                //            Text("No selected")
                //            YarnsListView(folder: selectedFolder/*, selectedYarn: $selectedYarn*/)
                ////                .tint(dynamicAccentColor)
                //                .tint(Color(getColorTheme(by: appColorTheme).sysName))
            } detail: {
                NavigationStack{
                    VStack {
                        Spacer()
                        //                    GeometryReader { geometry in
                        Image("yarn")
                            .resizable()
                            .scaledToFit()
                        //                            .frame(width: geometry.size.width) // 親ビューの幅に合わせる
                            .frame(width: 300)
                            .foregroundColor(Color(UIColor.secondarySystemBackground))
                        //                    }
                        Spacer()
                        HStack {
                            Text("KEY_LET'S_CHOOSE_SOME_YARN")
                            Image(systemName: "music.quarternote.3")
                        }
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        Spacer()
                    }
                    .padding()
                }
                //            if let yarn = selectedYarn {
                //                YarnsDetailView(yarnInfo: yarn)
                //            } else {
                //                ZStack {
                //                    GeometryReader { geometry in
                //                        Image("yarn")
                //                            .resizable()
                //                            .scaledToFit()
                //                            .frame(width: geometry.size.width) // 親ビューの幅に合わせる
                //                            .foregroundColor(Color(UIColor.secondarySystemBackground))
                //                    }
                //                    HStack {
                //                        Text("KEY_LET'S_CHOOSE_SOME_YARN")
                //                        Image(systemName: "music.quarternote.3")
                //                    }
                //                    .font(.largeTitle)
                //                    .fontWeight(.heavy)
                //
                //                }
                //                .padding()
                //            }
                
            }
            .tint(Color(getColorTheme(by: appColorTheme).sysName))
            .tabItem {
                Label("KEY_STASH", image: "yarn")
//                Image("yarn")
//                Text("KEY_STASH")
            }
            ToolsListVIew()
                .tint(Color(getColorTheme(by: appColorTheme).sysName))
                .tabItem {
                    Label("KEY_TOOLS", systemImage: "wrench.and.screwdriver")
                }
            SettingsView()
                .tint(Color(getColorTheme(by: appColorTheme).sysName))
                .tabItem {
                    Label("KEY_SETTINGS", systemImage: "gearshape")
                }

        }
        .tint(Color(getColorTheme(by: appColorTheme).sysName))
        .onAppear{
            FirstLaunch()
        }
    }
    init() {
//        if stockStatus.count == 0 {
//            print("make stock status")
//            let statusNew = YarnStockStatus(
//                orderIndex: stockStatus.count,
//                name: "新品"
//            )
//            modelContext.insert(statusNew)
//            let statusOld = YarnStockStatus(
//                orderIndex: stockStatus.count,
//                name: "使い古し"
//            )
//            modelContext.insert(statusOld)
//        }
//        let navBarAppearance = UINavigationBarAppearance()
//        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.red, .font: UIFont(name: "ArialRoundedMTBold", size: 35)!]
//        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.red, .font: UIFont(name: "ArialRoundedMTBold", size: 20)!]
//        navBarAppearance.setBackIndicatorImage(UIImage(systemName: "arrow.turn.up.left"), transitionMaskImage: UIImage(systemName: "arrow.turn.up.left"))
//
//        UINavigationBar.appearance().standardAppearance = navBarAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
//        UINavigationBar.appearance().compactAppearance = navBarAppearance
//        
    }
}

#Preview {
    ContentView()
//            .modelContainer(for: YarnInfo.self, inMemory: true)
        // .modelContainer(previewYarn)
}
