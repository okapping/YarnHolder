//
//  ContentView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/03/10.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @Query var stockStatus: [YarnStockStatus]
    
    @AppStorage("appColorTheme") var appColorTheme = 10
    
    @State private var selectedYarn: YarnInfo? = nil
    
    @State private var preferredColumn = NavigationSplitViewColumn.content
    @State private var visibility: NavigationSplitViewVisibility = .all
    
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
    
    var body: some View {
        TabView{
            NavigationSplitView(columnVisibility: $visibility) {
                FoldersListView()
                    .tint(Color(getColorTheme(by: appColorTheme).sysName))
            } content: {
            } detail: {
                NavigationStack{
                    VStack {
                        Spacer()
                        Image("yarn")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                            .foregroundColor(Color(UIColor.secondarySystemBackground))
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
            }
            .tint(Color(getColorTheme(by: appColorTheme).sysName))
            .tabItem {
                Label("KEY_STASH", image: "yarn")
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
    }
}

#Preview {
    ContentView()
//         .modelContainer(previewYarn)
}
