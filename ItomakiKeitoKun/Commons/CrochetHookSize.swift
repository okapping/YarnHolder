//
//  CrochetHookSize.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/04/02.
//

import Foundation

struct CrochetHookSize {
    let id: Int
    let number: String
    let size: Double
}

// 毛糸の素材のマスターデータ
let CrochetHookSizes: [CrochetHookSize] = [
    CrochetHookSize(id: 0, number: "1/0", size: 1.80),
    CrochetHookSize(id: 1, number: "2/0", size: 2.00),
    CrochetHookSize(id: 2, number: "", size: 2.25),
    CrochetHookSize(id: 3, number: "3/0", size: 2.30),
    CrochetHookSize(id: 4, number: "4/0", size: 2.50),
    CrochetHookSize(id: 5, number: "", size: 2.75),
    CrochetHookSize(id: 6, number: "5/0", size: 3.00),
    CrochetHookSize(id: 7, number: "", size: 3.25),
    CrochetHookSize(id: 8, number: "6/0", size: 3.50),
    CrochetHookSize(id: 9, number: "", size: 3.75),
    CrochetHookSize(id: 10, number: "7/0", size: 4.00),
    CrochetHookSize(id: 11, number: "7.5/0", size: 4.50),
    CrochetHookSize(id: 12, number: "8/0", size: 5.00),
    CrochetHookSize(id: 13, number: "9/0", size: 5.50),
    CrochetHookSize(id: 14, number: "10/0", size: 6.00),
    CrochetHookSize(id: 15, number: "", size: 6.50),
    CrochetHookSize(id: 16, number: "ジャンボ 7mm", size: 7.00),
    CrochetHookSize(id: 17, number: "ジャンボ 8mm", size: 8.00),
    CrochetHookSize(id: 18, number: "ジャンボ 9mm", size: 9.00),
    CrochetHookSize(id: 19, number: "ジャンボ 10mm", size: 10.00),
    CrochetHookSize(id: 20, number: "ジャンボ 15mm", size: 15.00),]

func getCrochetHookSize(by id: Int) -> CrochetHookSize? {
    return CrochetHookSizes.first { $0.id == id }
}
