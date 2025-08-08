//
//  LaundrySymbols.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/07/24.
//

import Foundation

struct LaundrySymbol: Identifiable, Hashable {
    let id: Int
    let name: String
    let detail: String
    let groupId: Int
}

let laundryGroupNames: [String] = [
    "KEY_HOME_WASHING",
    "KEY_BLEACHING",
    "KEY_TUMBLE_DRYING",
    "KEY_AIR_DRYING",
    "KEY_IRONING",
    "KEY_CLEANING"
]

// 洗濯表示のマスターデータ
let LaundrySymbols: [LaundrySymbol] = [
    LaundrySymbol(id: 1, name: "01_wash_30", detail: "液温は30°Cを限度とし、洗濯機で洗濯ができる", groupId: 0),
    LaundrySymbol(id: 2, name: "02_wash_30_weak", detail: "液温は30°Cを限度とし、洗濯機で弱い洗濯ができる", groupId: 0),
    LaundrySymbol(id: 3, name: "03_wash_30_delicate", detail: "液温は30°Cを限度とし、洗濯機で非常に弱い洗濯ができる", groupId: 0),
    LaundrySymbol(id: 4, name: "04_wash_40", detail: "液温は40°Cを限度とし、洗濯機で洗濯ができる", groupId: 0),
    LaundrySymbol(id: 5, name: "05_wash_40_weak", detail: "液温は40°Cを限度とし、洗濯機で弱い洗濯ができる", groupId: 0),
    LaundrySymbol(id: 6, name: "06_wash_40_delicate", detail: "液温は40°Cを限度とし、洗濯機で非常に弱い洗濯ができる", groupId: 0),
    LaundrySymbol(id: 7, name: "07_wash_50", detail: "液温は50°Cを限度とし、洗濯機で洗濯ができる", groupId: 0),
    LaundrySymbol(id: 8, name: "08_wash_50_weak", detail: "液温は50°Cを限度とし、洗濯機で弱い洗濯ができる", groupId: 0),
    LaundrySymbol(id: 9, name: "09_wash_60", detail: "液温は60°Cを限度とし、洗濯機で洗濯ができる", groupId: 0),
    LaundrySymbol(id: 10, name: "10_wash_60_weak", detail: "液温は60°Cを限度とし、洗濯機で弱い洗濯ができる", groupId: 0),
    LaundrySymbol(id: 11, name: "11_wash_70", detail: "液温は70°Cを限度とし、洗濯機で洗濯ができる", groupId: 0),
    LaundrySymbol(id: 12, name: "12_wash_95", detail: "液温は95°Cを限度とし、洗濯機で洗濯ができる", groupId: 0),
    LaundrySymbol(id: 13, name: "13_hand_wash", detail: "液温は40°Cを限度とし、手洗いができる", groupId: 0),
    LaundrySymbol(id: 14, name: "14_hand_wash_weak", detail: "液温は40°Cを限度とし、弱い手洗いができる", groupId: 0),
    LaundrySymbol(id: 15, name: "15_do_not_wash", detail: "家庭での洗濯禁止", groupId: 0),
    LaundrySymbol(id: 21, name: "21_bleach_when_needed", detail: "塩素系及び酸素系の漂白剤を使用して漂白ができる", groupId: 1),
    LaundrySymbol(id: 22, name: "22_only_non-chlorine_bleach_when_needed", detail: "酸素系漂白剤の使用はできるが、塩素系漂白剤は使用禁止", groupId: 1),
    LaundrySymbol(id: 23, name: "23_ do_not_bleach", detail: "塩素系及び酸素系漂白剤の使用禁止", groupId: 1),
    LaundrySymbol(id: 31, name: "31_tumble_dry_low", detail: "低い温度でのタンブル乾燥ができる（排気温度上限60°C）", groupId: 2),
    LaundrySymbol(id: 32, name: "32_tumble_dry_medium", detail: "タンブル乾燥ができる（排気温度上限80°C）", groupId: 2),
    LaundrySymbol(id: 33, name: "33_do_not_tumble_dry", detail: "タンブル乾燥禁止", groupId: 2),
    LaundrySymbol(id: 41, name: "41_ line_dry", detail: "つり干しがよい", groupId: 3),
    LaundrySymbol(id: 42, name: "42_line_dry_shade", detail: "日陰のつり干しがよい", groupId: 3),
    LaundrySymbol(id: 43, name: "43_drip_dry", detail: "ぬれつり干しがよい", groupId: 3),
    LaundrySymbol(id: 44, name: "44_drip_dry_shade", detail: "日陰のぬれつり干しがよい", groupId: 3),
    LaundrySymbol(id: 45, name: "45_dry_flat", detail: "平干しがよい", groupId: 3),
    LaundrySymbol(id: 46, name: "46_dry_flat_shade", detail: "日陰の平干しがよい", groupId: 3),
    LaundrySymbol(id: 47, name: "47_dry_flat_wet", detail: "ぬれ平干しがよい", groupId: 3),
    LaundrySymbol(id: 48, name: "48_dry_flat_wet_shade", detail: "日陰のぬれ平干しがよい", groupId: 3),
    LaundrySymbol(id: 51, name: "51_iron_low", detail: "底面温度110°Cを限度としてスチームなしでアイロン仕上げができる", groupId: 4),
    LaundrySymbol(id: 52, name: "52_iron_medium", detail: "底面温度150°Cを限度としてアイロン仕上げができる", groupId: 4),
    LaundrySymbol(id: 53, name: "53_iron_high", detail: "底面温度200°Cを限度としてアイロン仕上げができる", groupId: 4),
    LaundrySymbol(id: 54, name: "54_do_not_high_steam", detail: "保留", groupId: 4),
    LaundrySymbol(id: 55, name: "55_do_not_iron", detail: "アイロン仕上げ禁止", groupId: 4),
    LaundrySymbol(id: 61, name: "61_pro_dry_cleaning_p_and_h", detail: "パークロロエチレン及び石油系溶剤によるドライクリーニングができる", groupId: 5),
    LaundrySymbol(id: 62, name: "62_pro_dry_cleaning_p_and_h_mild", detail: "パークロロエチレン及び石油系溶剤による弱いドライクリーニングができる", groupId: 5),
    LaundrySymbol(id: 63, name: "63_pro_dry_cleaning_only_h", detail: "石油系溶剤によるドライクリーニングができる", groupId: 5),
    LaundrySymbol(id: 64, name: "64_pro_dry_cleaning_only_h_mild", detail: "石油系溶剤による弱いドライクリーニングができる", groupId: 5),
    LaundrySymbol(id: 65, name: "61_pro_dry_cleaning_p_and_h", detail: "ドライクリーニング禁止", groupId: 5),
    LaundrySymbol(id: 71, name: "71_pro_wet_cleaning", detail: "ウエットクリーニングができる", groupId: 5),
    LaundrySymbol(id: 72, name: "72_pro_wet_cleaning_mild", detail: "弱い操作によるウエットクリーニングができる", groupId: 5),
    LaundrySymbol(id: 73, name: "73_pro_wet_cleaning_very_mild", detail: "非常に弱い操作によるウエットクリーニングができる", groupId: 5),
    LaundrySymbol(id: 74, name: "74_do_not_pro_wet_cleaning", detail: "ウエットクリーニング禁止", groupId: 5),
]


// グループ化する関数
func groupLaundrySymbols(_ symbols: [LaundrySymbol]) -> [[LaundrySymbol]] {
    var grouped: [[LaundrySymbol]] = []
    var currentGroupId: Int? = nil
    var currentGroup: [LaundrySymbol] = []
    
    for symbol in symbols {
        // 新しいグループを開始する条件
        if currentGroupId != symbol.groupId {
            // 現在のグループがあれば追加
            if !currentGroup.isEmpty {
                grouped.append(currentGroup)
            }
            currentGroupId = symbol.groupId
            currentGroup = [symbol]
        } else {
            // 同じグループの場合、現在のグループに追加
            currentGroup.append(symbol)
        }
    }
    
    // 最後のグループを追加
    if !currentGroup.isEmpty {
        grouped.append(currentGroup)
    }
    
    return grouped
}
let groupedSymbols = groupLaundrySymbols(LaundrySymbols)

func getLaundrySymbol(by id: Int) -> LaundrySymbol? {
    return LaundrySymbols.first { $0.id == id }
}

