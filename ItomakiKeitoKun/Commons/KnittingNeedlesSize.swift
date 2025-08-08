//
//  Untitled.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/03/31.
//

import Foundation

struct KnittingNeedlesSize {
    let id: Int
    let number: String
    let size: Double
}

// 毛糸の素材のマスターデータ
let KnittingNeedlesSizes: [KnittingNeedlesSize] = [
    KnittingNeedlesSize(id: 0, number: "0", size: 2.10),
    KnittingNeedlesSize(id: 1, number: "1", size: 2.40),
    KnittingNeedlesSize(id: 2, number: "2", size: 2.70),
    KnittingNeedlesSize(id: 3, number: "3", size: 3.00),
    KnittingNeedlesSize(id: 4, number: "4", size: 3.30),
    KnittingNeedlesSize(id: 5, number: "5", size: 3.60),
    KnittingNeedlesSize(id: 6, number: "6", size: 3.90),
    KnittingNeedlesSize(id: 7, number: "7", size: 4.20),
    KnittingNeedlesSize(id: 8, number: "8", size: 4.50),
    KnittingNeedlesSize(id: 9, number: "9", size: 4.80),
    KnittingNeedlesSize(id: 10, number: "10", size: 5.10),
    KnittingNeedlesSize(id: 11, number: "11", size: 5.40),
    KnittingNeedlesSize(id: 12, number: "12", size: 5.70),
    KnittingNeedlesSize(id: 13, number: "13", size: 6.00),
    KnittingNeedlesSize(id: 14, number: "14", size: 6.30),
    KnittingNeedlesSize(id: 15, number: "15", size: 6.60),
    KnittingNeedlesSize(id: 16, number: "ジャンボ 7mm", size: 7.00),
    KnittingNeedlesSize(id: 17, number: "ジャンボ 8mm", size: 8.00),
    KnittingNeedlesSize(id: 18, number: "ジャンボ 9mm", size: 9.00),
    KnittingNeedlesSize(id: 19, number: "ジャンボ 10mm", size: 10.00),
    KnittingNeedlesSize(id: 20, number: "ジャンボ 11mm", size: 11.00),
    KnittingNeedlesSize(id: 21, number: "ジャンボ 12mm", size: 12.00),
    KnittingNeedlesSize(id: 22, number: "ジャンボ 15mm", size: 15.00),
    KnittingNeedlesSize(id: 23, number: "ジャンボ 20mm", size: 20.00),
    KnittingNeedlesSize(id: 24, number: "ジャンボ 25mm", size: 25.00),
    KnittingNeedlesSize(id: 25, number: "ジャンボ 30mm", size: 30.00),
]

func getKnittingNeedlesSize(by id: Int) -> KnittingNeedlesSize? {
    return KnittingNeedlesSizes.first { $0.id == id }
}
