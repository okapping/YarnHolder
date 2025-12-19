//
//  LaundrySymbols.swift
//  YarnStocker
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
    LaundrySymbol(id: 1, name: "01_wash_30", detail: "KEY_WASH_30_NORMAL", groupId: 0),
    LaundrySymbol(id: 2, name: "02_wash_30_weak", detail: "KEY_WASH_30_GENTLE", groupId: 0),
    LaundrySymbol(id: 3, name: "03_wash_30_delicate", detail: "KEY_WASH_30_VERY_GENTLE", groupId: 0),
    LaundrySymbol(id: 4, name: "04_wash_40", detail: "KEY_WASH_40_NORMAL", groupId: 0),
    LaundrySymbol(id: 5, name: "05_wash_40_weak", detail: "KEY_WASH_40_GENTLE", groupId: 0),
    LaundrySymbol(id: 6, name: "06_wash_40_delicate", detail: "KEY_WASH_40_VERY_GENTLE", groupId: 0),
    LaundrySymbol(id: 7, name: "07_wash_50", detail: "KEY_WASH_50_NORMAL", groupId: 0),
    LaundrySymbol(id: 8, name: "08_wash_50_weak", detail: "KEY_WASH_50_GENTLE", groupId: 0),
    LaundrySymbol(id: 9, name: "09_wash_60", detail: "KEY_WASH_60_NORMAL", groupId: 0),
    LaundrySymbol(id: 10, name: "10_wash_60_weak", detail: "KEY_WASH_60_GENTLE", groupId: 0),
    LaundrySymbol(id: 11, name: "11_wash_70", detail: "KEY_WASH_70_NORMAL", groupId: 0),
    LaundrySymbol(id: 12, name: "12_wash_95", detail: "KEY_WASH_95_NORMAL", groupId: 0),
    LaundrySymbol(id: 13, name: "13_hand_wash", detail: "KEY_HAND_WASH_40_NORMAL", groupId: 0),
    LaundrySymbol(id: 14, name: "14_hand_wash_weak", detail: "KEY_HAND_WASH_40_GENTLE", groupId: 0),
    LaundrySymbol(id: 15, name: "15_do_not_wash", detail: "KEY_NO_HOME_WASH", groupId: 0),
    LaundrySymbol(id: 21, name: "21_bleach_when_needed", detail: "KEY_BLEACH_CHLORINE_OXYGEN", groupId: 1),
    LaundrySymbol(id: 22, name: "22_only_non-chlorine_bleach_when_needed", detail: "KEY_BLEACH_OXYGEN_ONLY", groupId: 1),
    LaundrySymbol(id: 23, name: "23_ do_not_bleach", detail: "KEY_NO_BLEACH", groupId: 1),
    LaundrySymbol(id: 31, name: "31_tumble_dry_low", detail: "KEY_TUMBLE_DRY_LOW", groupId: 2),
    LaundrySymbol(id: 32, name: "32_tumble_dry_medium", detail: "KEY_TUMBLE_DRY_NORMAL", groupId: 2),
    LaundrySymbol(id: 33, name: "33_do_not_tumble_dry", detail: "KEY_NO_TUMBLE_DRY", groupId: 2),
    LaundrySymbol(id: 41, name: "41_ line_dry", detail: "KEY_HANG_DRY", groupId: 3),
    LaundrySymbol(id: 42, name: "42_line_dry_shade", detail: "KEY_HANG_DRY_SHADE", groupId: 3),
    LaundrySymbol(id: 43, name: "43_drip_dry", detail: "KEY_HANG_DRY_WET", groupId: 3),
    LaundrySymbol(id: 44, name: "44_drip_dry_shade", detail: "KEY_HANG_DRY_WET_SHADE", groupId: 3),
    LaundrySymbol(id: 45, name: "45_dry_flat", detail: "KEY_LAY_FLAT_DRY", groupId: 3),
    LaundrySymbol(id: 46, name: "46_dry_flat_shade", detail: "KEY_LAY_FLAT_DRY_SHADE", groupId: 3),
    LaundrySymbol(id: 47, name: "47_dry_flat_wet", detail: "KEY_LAY_FLAT_DRY_WET", groupId: 3),
    LaundrySymbol(id: 48, name: "48_dry_flat_wet_shade", detail: "KEY_LAY_FLAT_DRY_WET_SHADE", groupId: 3),
    LaundrySymbol(id: 51, name: "51_iron_low", detail: "KEY_IRON_110", groupId: 4),
    LaundrySymbol(id: 52, name: "52_iron_medium", detail: "KEY_IRON_150", groupId: 4),
    LaundrySymbol(id: 53, name: "53_iron_high", detail: "KEY_IRON_200", groupId: 4),
    LaundrySymbol(id: 54, name: "55_do_not_iron", detail: "KEY_NO_IRON", groupId: 4),
    LaundrySymbol(id: 61, name: "61_pro_dry_cleaning_p_and_h", detail: "KEY_DRY_CLEAN_PERC_PETROLEUM", groupId: 5),
    LaundrySymbol(id: 62, name: "62_pro_dry_cleaning_p_and_h_mild", detail: "KEY_DRY_CLEAN_PERC_PETROLEUM_GENTLE", groupId: 5),
    LaundrySymbol(id: 63, name: "63_pro_dry_cleaning_only_h", detail: "KEY_DRY_CLEAN_PETROLEUM", groupId: 5),
    LaundrySymbol(id: 64, name: "64_pro_dry_cleaning_only_h_mild", detail: "KEY_DRY_CLEAN_PETROLEUM_GENTLE", groupId: 5),
    LaundrySymbol(id: 65, name: "61_pro_dry_cleaning_p_and_h", detail: "KEY_NO_DRY_CLEAN", groupId: 5),
    LaundrySymbol(id: 71, name: "71_pro_wet_cleaning", detail: "KEY_WET_CLEAN", groupId: 5),
    LaundrySymbol(id: 72, name: "72_pro_wet_cleaning_mild", detail: "KEY_WET_CLEAN_GENTLE", groupId: 5),
    LaundrySymbol(id: 73, name: "73_pro_wet_cleaning_very_mild", detail: "KEY_WET_CLEAN_VERY_GENTLE", groupId: 5),
    LaundrySymbol(id: 74, name: "74_do_not_pro_wet_cleaning", detail: "KEY_NO_WET_CLEAN", groupId: 5),
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

