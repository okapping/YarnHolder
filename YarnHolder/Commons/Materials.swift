//
//  Materials.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/03/15.
//
//enum Material: String, CaseIterable {
//    case none
//    case wool
//    case alpaca
//    case cashmere
//    case mohair
//    case silk
//    case cotton
//    case jute
//    case linen
//    case acrylic
//    case nylon
//    case polyester
//    case rayon
//    case other
//    
//    
//    var name: String {
//        switch self {
//        case .none: return "未設定"
//        case .wool: return "ウール"
//        case .alpaca: return "アルパカ"
//        case .cashmere: return "カシミア"
//        case .mohair: return "モヘア"
//        case .silk: return "シルク"
//        case .cotton: return "コットン（綿）"
//        case .jute: return "ジュート（黄麻）"
//        case .linen: return "リネン（亜麻）"
//        case .acrylic: return "アクリル"
//        case .nylon: return "ナイロン"
//        case .polyester: return "ポリエステル"
//        case .rayon: return "レーヨン"
//        case .other: return "その他"
//        }
//    }
//}

import Foundation

struct Material {
    let id: Int
    let nameId: String
    let name: String
}

let otherMaterial = Material(id: 99, nameId: "other", name: "KEY_OTHER")
// 毛糸の素材のマスターデータ
let Materials: [Material] = [
    Material(id: 0, nameId: "None", name: "KEY_UNSET"),
    Material(id: 1, nameId: "Wool", name: "KEY_WOOL"),
    Material(id: 2, nameId: "Alpaca", name: "KEY_ALPACA"),
    Material(id: 3, nameId: "Cashmere", name: "KEY_CASHMERE"),
    Material(id: 4, nameId: "mohair", name: "KEY_MOHIR"),
    Material(id: 5, nameId: "silk", name: "KEY_SILK"),
    Material(id: 6, nameId: "cotton", name: "KEY_COTTON"),
    Material(id: 7, nameId: "jute", name: "KEY_JUTE"),
    Material(id: 8, nameId: "linen", name: "KEY_LINEN"),
    Material(id: 9, nameId: "acrylic", name: "KEY_ACRYLIC"),
    Material(id: 10, nameId: "nylon", name: "KEY_NYLON"),
    Material(id: 11, nameId: "polyester", name: "KEY_POLYESTER"),
    Material(id: 12, nameId: "rayon", name: "KEY_RAYON"),
    Material(id: 13, nameId: "paper", name: "KEY_PAPER"),
    otherMaterial
]

func getYarnMaterial(by id: Int) -> Material {
    return Materials.first { $0.id == id } ?? otherMaterial
}
