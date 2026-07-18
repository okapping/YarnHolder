//
//  SettingsView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/07/15.
//

import Foundation
import SwiftUI
import SwiftData



struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.locale) var locale
    
    // 設定用個人設定の定義
    @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
    @AppStorage("appColorTheme") var appColorTheme = 10
    @AppStorage("appIcon") var appIcon = ""
    @AppStorage("weightUnit") var weightUnit = "g"
    @AppStorage("lengthUnit") var lengthUnit = "m"
    
    @AppStorage("unlockFeature") var unlockFeature: Bool = false
    //    @Query private var tags: [Tag]
    @State private var tmpAppColorTheme = 0
    @State private var showTagsSetting = false
    @State private var showVersionAbout = false
    @State private var showPurchaseView = false
    
    @State private var columnVisibility =
    NavigationSplitViewVisibility.doubleColumn
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            Form{
                Section{
                    HStack {
                        Text("KEY_UNLOCK_YARN_LIMIT")
                        Spacer()
                        if unlockFeature {
                            Text("KEY_PURCHASED")
                        } else {
                            Button {
                                showPurchaseView = true
                            } label: {
                                Text("KEY_PURCHASE")
                            }
                        }
                    }
                    .sheet(isPresented: $showPurchaseView) {
                        PurchaseView()
                            .presentationDetents([.height(200)])
                    }
                }
                Section(
                    header: ListTitleView(title: "KEY_ADVANCED_SETTINGS")
                ) {
                    NavigationLink{
                        YarnStockStatusListView()
                    } label: {
                        Label("KEY_INVENTORY_STATUS_DETAIL", image: "yarn.badge.sparkles")
                    }
                    Picker(selection: $weightUnit) {
                        Text("g").tag("g")
                        Text("oz").tag("oz")
                    } label: {
                        Label("KEY_WEIGHT_UNIT", systemImage: "scalemass")
                    }
                    .tint(Color(getColorTheme(by: tmpAppColorTheme).sysName))
                    //                    .pickerStyle(.navigationLink)
                    Picker(selection: $lengthUnit) {
                        Text("m").tag("m")
                        Text("yd").tag("yd")
                    } label: {
                        Label("KEY_LENGTH_UNIT", systemImage: "glowplug")
                    }
                    .tint(Color(getColorTheme(by: tmpAppColorTheme).sysName))
                }
                Section {
                    Picker(selection: $tmpAppColorTheme) {
                        ForEach(colorThemes, id: \.self) { color in
                            HStack {
                                Circle()
                                    .foregroundColor(Color(color.sysName))
                                    .frame(width: 16, height: 16)
                                Text(LocalizedStringKey(color.dispName))
                            }.tag(color.id)
                        }
                    } label: {
                        Label("KEY_THEME_COLOR", systemImage: "paintpalette")
                    }
                    .pickerStyle(.navigationLink)
                    Picker(
                        selection: $appearanceMode,
                        label: Label("KEY_APPEARANCE_MODE", systemImage: "circle.righthalf.filled")
                    ) {
                        Text("KEY_AUTOMATIC").tag(0)
                        Text("KEY_LIGHT").tag(1)
                        Text("KEY_DARK").tag(2)
                    }
                    .tint(Color(getColorTheme(by: tmpAppColorTheme).sysName))
                    HStack {
                        Button {
                            guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } label: {
                            Label(title: {
                                Text("KEY_LANGUAGE")
                                    .foregroundColor(.primary)
                            }, icon: {
                                Image(systemName: "globe")
                            })
                        }
                        Spacer()
                        Text("KEY_SYSTEM_LANGUAGE")
                            .foregroundColor(.secondary)
                    }
                }
                Section() {
                    Link(destination: URL(string: "https://okapping.github.io/YarnHolder/")!){
                        Label("KEY_HELP", systemImage: "questionmark")
                    }
                    ShareLink("KEY_SHARE_APP", item: URL(string: "https://apps.apple.com/jp/app/yarn-holder/id6756721966")!)
                    Link(destination: URL(string: "https://apps.apple.com/jp/app/id6756721966?action=write-review")!){
                        Label("KEY_REVIEW_ON_APP_STORE", systemImage: "star")
                    }
                } footer: {
                    Spacer()
                    Text("Version 1.2.0")
                }
            }
            .navigationTitle("KEY_SETTINGS")
        } detail: {
            Text("")
        }
        .onAppear{
            tmpAppColorTheme = appColorTheme
        }
        .onChange(of: tmpAppColorTheme){
            appColorTheme = tmpAppColorTheme
        }
        
    }
}

#Preview {
    SettingsView()
}
