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
                        Label("KEY_INVENTORY_STATUS_DETAIL", image: "yarn")
//                        Text()
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
                        Label("KEY_LENGTH_UNIT", systemImage: "arrow.left.and.right")
                    }
                    .tint(Color(getColorTheme(by: tmpAppColorTheme).sysName))
                    //                    .pickerStyle(.navigationLink)
                }
                Section {
                    NavigationLink{
                        List{
                            Button {
                                appIcon = ""
                                UIApplication.shared.setAlternateIconName(nil)
                            } label: {
                                HStack {
                                    Image("PreviewAppIconDefault")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 48, height: 48)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.black.opacity(0.3), lineWidth: 0.5)
                                        )
                                    Text("デフォルト")
//                                        .foregroundStyle(.primary)
                                }
                            }
                            .tint(.primary)
//                            .buttonStyle(.plain)
                            Button {
                                appIcon = "Red"
                                UIApplication.shared.setAlternateIconName("AppIconRed")
                            } label: {
                                HStack {
                                    Image("PreviewAppIconRed")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 48, height: 48)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.black.opacity(0.3), lineWidth: 0.5)
                                        )
                                    Text("KEY_COLOR_RED")
                                    //                                        .foregroundStyle(.primary)
                                }
                            }
                            .tint(.primary)
                            Button {
                                appIcon = "Blue"
                                UIApplication.shared.setAlternateIconName("AppIconBlue")
                            } label: {
                                HStack {
                                    Image("PreviewAppIconBlue")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 48, height: 48)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.black.opacity(0.3), lineWidth: 0.5)
                                        )
                                    Text("KEY_COLOR_BLUE")
                                    //                                        .foregroundStyle(.primary)
                                }
                            }
                            .tint(.primary)
//                            .buttonStyle(.plain)
                            Button {
                                appIcon = "Green"
                                UIApplication.shared.setAlternateIconName("AppIconGreen")
                            } label: {
                                HStack {
                                    Image("PreviewAppIconGreen")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 48, height: 48)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.black.opacity(0.3), lineWidth: 0.5)
                                        )
                                    Text("KEY_COLOR_GREEN")
//                                        .foregroundStyle(.primary)
                                }
                            }
                            .tint(.primary)
//                            .buttonStyle(.plain)
                            Button {
                                appIcon = "Yellow"
                                UIApplication.shared.setAlternateIconName("AppIconYellow")
                            } label: {
                                HStack {
                                    Image("PreviewAppIconYellow")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 48, height: 48)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.black.opacity(0.3), lineWidth: 0.5)
                                        )
                                    Text("KEY_COLOR_YELLOW")
//                                        .foregroundStyle(.primary)
                                }
                            }
                            .tint(.primary)
//                            .buttonStyle(.plain)
                        }
                        .navigationTitle(String(localized: "KEY_APP_ICON"))
                    } label: {
                        HStack {
                            Label("KEY_APP_ICON", systemImage: "app")
                            Spacer()
                            let previewImage = appIcon != "" ? "PreviewAppIcon\(appIcon)" : "PreviewAppIconDefault"
                            Image(previewImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 32, height: 32)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black.opacity(0.3), lineWidth: 0.5)
                                )

                        }
                    }
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
//                    NavigationLink {
//                        //
//                    } label: {
//                        Label("KEY_APP_ICON", systemImage: "app")
//                    }
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
                            //                        Label("KEY_LANGUAGE", systemImage: "globe")
                        }
                        Spacer()
//                        let code = locale.language.languageCode?.identifier ?? ""
                        Text("KEY_SYSTEM_LANGUAGE")
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
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        presentationMode.wrappedValue.dismiss()
//                    } label: {
//                        Text("KEY_CLOSE")
//                    }
//                }
//            }

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
//        .modelContainer(previewFolderContainer)
    //        .modelContainer(previewEventsContainer)
}
