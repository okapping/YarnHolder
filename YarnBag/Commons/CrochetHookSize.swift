//
//  CrochetHookSize.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/04/02.
//

import Foundation

struct CrochetHookSize: Identifiable {
    let id: Int
    let mmSize: String
    let jpSize: String
    let usSize: String
    let ukSize: String
    var dispSizeJp: String {
        var jp = ""
        if jpSize != "" {
            jp = "（\(jpSize)）"
        }
        return "\(mmSize)mm\(jp)"
    }
    var dispSizeDefault: String {
        var us = ""
        var uk = ""
        if usSize != "" {
            us = " / US \(usSize)"
        }
        if ukSize != "" {
            uk = " / UK \(ukSize)"
        }
        return "\(mmSize)mm\(us)\(uk)"
    }

}

// 毛糸の素材のマスターデータ
let CrochetHookSizes: [CrochetHookSize] = [
    CrochetHookSize(id: 0, mmSize: "0.50", jpSize: "14号", usSize: "", ukSize: "", ),
    CrochetHookSize(id: 1, mmSize: "0.60", jpSize: "12号", usSize: "", ukSize: "", ),
    CrochetHookSize(id: 2, mmSize: "0.75", jpSize: "10号", usSize: "", ukSize: "", ),
    CrochetHookSize(id: 3, mmSize: "0.90", jpSize: "8号", usSize: "", ukSize: "", ),
    CrochetHookSize(id: 4, mmSize: "1.00", jpSize: "6号", usSize: "", ukSize: "", ),
    CrochetHookSize(id: 5, mmSize: "1.25", jpSize: "4号", usSize: "", ukSize: "", ),
    CrochetHookSize(id: 6, mmSize: "1.50", jpSize: "2号", usSize: "6 steel", ukSize: "3-5 steel", ),
    CrochetHookSize(id: 7, mmSize: "1.75", jpSize: "0号", usSize: "5 steel", ukSize: "", ),
    CrochetHookSize(id: 8, mmSize: "1.80", jpSize: "1/0号", usSize: "", ukSize: "", ),
    CrochetHookSize(id: 9, mmSize: "2.00", jpSize: "2/0号", usSize: "A-0(or 4 steel)", ukSize: "14 or 2.5 steel", ),
    CrochetHookSize(id: 10, mmSize: "2.20", jpSize: "", usSize: "", ukSize: "", ),
    CrochetHookSize(id: 11, mmSize: "2.25", jpSize: "", usSize: "B-1(or 2 steel)", ukSize: "13 or 1.5 steel", ),
    CrochetHookSize(id: 12, mmSize: "2.30", jpSize: "3/0号", usSize: "", ukSize: "", ),
    CrochetHookSize(id: 13, mmSize: "2.50", jpSize: "4/0号", usSize: "", ukSize: "12", ),
    CrochetHookSize(id: 14, mmSize: "2.75", jpSize: "", usSize: "C-2(or 1 steel)", ukSize: "1 steel", ),
    CrochetHookSize(id: 15, mmSize: "3.00", jpSize: "5/0号", usSize: "", ukSize: "11", ),
    CrochetHookSize(id: 16, mmSize: "3.25", jpSize: "", usSize: "D-3(or 0 steel)", ukSize: "10 or 0 steel", ),
    CrochetHookSize(id: 17, mmSize: "3.50", jpSize: "6/0号", usSize: "E-4(or 00 steel)", ukSize: "9", ),
    CrochetHookSize(id: 18, mmSize: "3.60", jpSize: "", usSize: "", ukSize: "", ),
    CrochetHookSize(id: 19, mmSize: "3.75", jpSize: "", usSize: "F-5", ukSize: "8", ),
    CrochetHookSize(id: 20, mmSize: "4.00", jpSize: "7/0号", usSize: "G-6", ukSize: "7", ),
    CrochetHookSize(id: 21, mmSize: "4.50", jpSize: "7.5/0号", usSize: "7", ukSize: "", ),
    CrochetHookSize(id: 22, mmSize: "5.00", jpSize: "8/0号", usSize: "H-8", ukSize: "6", ),
    CrochetHookSize(id: 23, mmSize: "5.50", jpSize: "9/0号", usSize: "I-9", ukSize: "5", ),
    CrochetHookSize(id: 24, mmSize: "6.00", jpSize: "10/0号", usSize: "J-10", ukSize: "4", ),
    CrochetHookSize(id: 25, mmSize: "6.50", jpSize: "", usSize: "K-10 1/2", ukSize: "3", ),
    CrochetHookSize(id: 26, mmSize: "7.00", jpSize: "ジャンボ 7mm号", usSize: "", ukSize: "2", ),
    CrochetHookSize(id: 27, mmSize: "8.00", jpSize: "ジャンボ 8mm号", usSize: "L-11", ukSize: "", ),
    CrochetHookSize(id: 28, mmSize: "9.00", jpSize: "", usSize: "M/N-13", ukSize: "", ),
    CrochetHookSize(id: 29, mmSize: "10.00", jpSize: "ジャンボ 10mm号", usSize: "N/P-15", ukSize: "", ),
    CrochetHookSize(id: 30, mmSize: "15.00", jpSize: "ジャンボ 15mm号", usSize: "P/Q", ukSize: "", ),
    CrochetHookSize(id: 31, mmSize: "16.00", jpSize: "", usSize: "Q", ukSize: "", ),
    CrochetHookSize(id: 32, mmSize: "19.00", jpSize: "", usSize: "S", ukSize: "", ),
]

func getCrochetHookSize(by id: Int) -> CrochetHookSize? {
    return CrochetHookSizes.first { $0.id == id }
}
