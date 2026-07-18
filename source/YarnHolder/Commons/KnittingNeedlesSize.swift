//
//  Untitled.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/03/31.
//

import Foundation

struct KnittingNeedlesSize: Identifiable {
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

//    let size: Double
}
let defaultKnittingNeedlesSize = KnittingNeedlesSize(id: 0,  mmSize: "1.25",  jpSize: "",                   usSize: "000",  ukSize: "16", )
// 毛糸の素材のマスターデータ
let KnittingNeedlesSizes: [KnittingNeedlesSize] = [
    defaultKnittingNeedlesSize,
//    KnittingNeedlesSize(id: 0,  mmSize: "1.25",  jpSize: "",                   usSize: "000",  ukSize: "16", ),
    KnittingNeedlesSize(id: 1,  mmSize: "1.50",  jpSize: "",                   usSize: "00",   ukSize: "15", ),
    KnittingNeedlesSize(id: 2,  mmSize: "1.75",  jpSize: "",                   usSize: "",     ukSize: "14", ),
    KnittingNeedlesSize(id: 3,  mmSize: "2.00",  jpSize: "",                   usSize: "0",    ukSize: "", ),
    KnittingNeedlesSize(id: 4,  mmSize: "2.10",  jpSize: "0号",                usSize: "",     ukSize: "", ),
    KnittingNeedlesSize(id: 5,  mmSize: "2.25",  jpSize: "",                   usSize: "1",    ukSize: "13", ),
    KnittingNeedlesSize(id: 6,  mmSize: "2.40",  jpSize: "1号",                usSize: "",     ukSize: "", ),
    KnittingNeedlesSize(id: 7,  mmSize: "2.70",  jpSize: "2号",                usSize: "",     ukSize: "", ),
    KnittingNeedlesSize(id: 8,  mmSize: "2.75",  jpSize: "",                   usSize: "2",    ukSize: "12", ),
    KnittingNeedlesSize(id: 9,  mmSize: "3.00",  jpSize: "3号",                usSize: "",     ukSize: "11", ),
    KnittingNeedlesSize(id: 10, mmSize: "3.25",  jpSize: "",                   usSize: "3",    ukSize: "10", ),
    KnittingNeedlesSize(id: 11, mmSize: "3.30",  jpSize: "4号",                usSize: "",     ukSize: "", ),
    KnittingNeedlesSize(id: 12, mmSize: "3.50",  jpSize: "",                   usSize: "4",    ukSize: "", ),
    KnittingNeedlesSize(id: 13, mmSize: "3.60",  jpSize: "5号",                usSize: "",     ukSize: "", ),
    KnittingNeedlesSize(id: 14, mmSize: "3.75",  jpSize: "",                   usSize: "5",    ukSize: "9", ),
    KnittingNeedlesSize(id: 15, mmSize: "3.90",  jpSize: "6号",                usSize: "",     ukSize: "", ),
    KnittingNeedlesSize(id: 16, mmSize: "4.00",  jpSize: "",                   usSize: "6",    ukSize: "8", ),
    KnittingNeedlesSize(id: 17, mmSize: "4.20",  jpSize: "7号",                usSize: "",     ukSize: "", ),
    KnittingNeedlesSize(id: 18, mmSize: "4.50",  jpSize: "8号",                usSize: "7",    ukSize: "7", ),
    KnittingNeedlesSize(id: 19, mmSize: "4.80",  jpSize: "9号",                usSize: "",     ukSize: "", ),
    KnittingNeedlesSize(id: 20, mmSize: "5.00",  jpSize: "",                   usSize: "8",    ukSize: "6", ),
    KnittingNeedlesSize(id: 21, mmSize: "5.10",  jpSize: "10号",               usSize: "",     ukSize: "", ),
    KnittingNeedlesSize(id: 22, mmSize: "5.40",  jpSize: "11号",               usSize: "",     ukSize: "", ),
    KnittingNeedlesSize(id: 23, mmSize: "5.50",  jpSize: "",                   usSize: "9",    ukSize: "5", ),
    KnittingNeedlesSize(id: 24, mmSize: "5.70",  jpSize: "12号",               usSize: "",     ukSize: "", ),
    KnittingNeedlesSize(id: 25, mmSize: "6.00",  jpSize: "13号",               usSize: "10",   ukSize: "4", ),
    KnittingNeedlesSize(id: 26, mmSize: "6.30",  jpSize: "14号",               usSize: "",     ukSize: "", ),
    KnittingNeedlesSize(id: 27, mmSize: "6.50",  jpSize: "",                   usSize: "10.5", ukSize: "3", ),
    KnittingNeedlesSize(id: 28, mmSize: "6.60",  jpSize: "15号",               usSize: "",     ukSize: "", ),
    KnittingNeedlesSize(id: 29, mmSize: "7.00",  jpSize: "ジャンボ 7mm号",     usSize: "",     ukSize: "2", ),
    KnittingNeedlesSize(id: 30, mmSize: "7.50",  jpSize: "",                   usSize: "",     ukSize: "1", ),
    KnittingNeedlesSize(id: 31, mmSize: "8.00",  jpSize: "ジャンボ 8mm号",     usSize: "11",   ukSize: "0", ),
    KnittingNeedlesSize(id: 32, mmSize: "9.00",  jpSize: "ジャンボ 9mm号",     usSize: "13",   ukSize: "00", ),
    KnittingNeedlesSize(id: 33, mmSize: "10.00", jpSize: "ジャンボ 10mm号",    usSize: "15",   ukSize: "000", ),
    KnittingNeedlesSize(id: 34, mmSize: "11.00", jpSize: "ジャンボ 11mm号",    usSize: "",     ukSize: "", ),
    KnittingNeedlesSize(id: 35, mmSize: "12.00", jpSize: "ジャンボ 12mm号",    usSize: "17",   ukSize: "", ),
    KnittingNeedlesSize(id: 36, mmSize: "15.00", jpSize: "ジャンボ 15mm号",    usSize: "",     ukSize: "", ),
    KnittingNeedlesSize(id: 37, mmSize: "16.00", jpSize: "",                   usSize: "19",   ukSize: "", ),
    KnittingNeedlesSize(id: 38, mmSize: "19.00", jpSize: "",                   usSize: "35",   ukSize: "", ),
    KnittingNeedlesSize(id: 39, mmSize: "20.00", jpSize: "ジャンボ 20mm号",    usSize: "",     ukSize: "", ),
    KnittingNeedlesSize(id: 40, mmSize: "25.00", jpSize: "ジャンボ 25mm号",    usSize: "50",   ukSize: "", ),
    ]

func getKnittingNeedlesSize(by id: Int) -> KnittingNeedlesSize {
    return KnittingNeedlesSizes.first { $0.id == id } ?? defaultKnittingNeedlesSize
}
