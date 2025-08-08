//
//  SettingsView.swift
//  ItomakiKeitoKun
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
//    @AppStorage("isMakimonoIcon") var isMakimonoIcon = false
    @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
//    @AppStorage("appColorScheme") var appColorScheme = 0
//    @AppStorage("showListIcon") var showListIcon = true
//    @AppStorage("showListImage") var showListImage = true
//    @AppStorage("showListTags") var showListTags = true
//    @AppStorage("showListCountDays") var showListCountDays = true
    
//    @Query private var tags: [Tag]
    @State private var showTagsSetting = false
    @State private var showVersionAbout = false
    
    var body: some View {
        NavigationStack {
            Form{
                Section(/*header: Text("フォルダアイコン")*/) {
                    NavigationLink {
                        //
                    } label: {
                        Label("KEY_THEME_COLOR", systemImage: "paintpalette")
                    }
                    NavigationLink {
                        //
                    } label: {
                        Label("KEY_APP_ICON", systemImage: "app")
                    }
                    NavigationLink {
                        //
                    } label: {
                        Label("KEY_NOTIFICATIONS", systemImage: "bell.badge")
                    }
                    Picker(
                        selection: $appearanceMode,
                        label: Label("KEY_APPEARANCE_MODE", systemImage: "circle.righthalf.filled")
                    ) {
                        Text("KEY_AUTOMATIC").tag(0)
                        Text("KEY_LIGHT").tag(1)
                        Text("KEY_DARK").tag(2)
                    }
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
                            //                        Label("KEY_LANGUAGE", systemImage: "globe")
                        }
                        Spacer()
                        let code = locale.language.languageCode?.identifier ?? ""
                        Text(code == "en" ? "English" : "日本語")
                            .foregroundColor(.secondary)
                    }

                }
                Section() {
                    NavigationLink {
                        //
                    } label: {
                        Label("KEY_HELP", systemImage: "questionmark")
                    }
                    NavigationLink {
                        //
                    } label: {
                        Label("KEY_FEEDBACK", systemImage: "info.bubble")
                    }
                    NavigationLink {
                        //
                    } label: {
                        Label("KEY_SHARE_APP", systemImage: "arrowshape.turn.up.right")
                    }
                    NavigationLink {
                        //
                    } label: {
                        Label("KEY_REVIEW_ON_APP_STORE", systemImage: "star")
                    }
                }
            }
            .navigationTitle("KEY_SETTINGS")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("KEY_CLOSE")
                    }
                }
            }

        }
    }
}

#Preview {
    SettingsView()
//        .modelContainer(previewFolderContainer)
    //        .modelContainer(previewEventsContainer)
}
