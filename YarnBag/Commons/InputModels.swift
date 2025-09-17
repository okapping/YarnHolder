//
//  InputModels.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/08/06.
//

import SwiftUI
import SwiftData

@Observable
class InputYarnInfo {
    var name: String
//    var orderIndex: Int = 0
    var memo: String
    var useKnittingNeedlesFrom: Int?
    var useKnittingNeedlesTo: Int?
    var useCrochetHookFrom: Int?
    var useCrochetHookTo: Int?
    var standardGaugeStitches: Double?
    var standardGaugeRows: Double?
    var length: Double?
    var weight: Double?
    var tags: [Tag] = []
    var folder: Folder?
    var laundrySymbols: [Int] = []
    var images: [Data] = []
//    var symbolId: Int = 1
//    var symbolColorName: String = selectColors.randomElement()!
//    var symbolColor: Color {
//        return Color(symbolColorName)
//    }
    init(name: String = "", memo: String = "") {
        self.name = name
        self.memo = memo
    }
    init(yarnInfo: YarnInfo){
        self.name = yarnInfo.name
//        self.orderIndex = yarnInfo.orderIndex
        self.memo = yarnInfo.memo
        self.useKnittingNeedlesFrom = yarnInfo.useKnittingNeedlesFrom
        self.useKnittingNeedlesTo = yarnInfo.useKnittingNeedlesTo
        self.useCrochetHookFrom = yarnInfo.useCrochetHookFrom
        self.useCrochetHookTo = yarnInfo.useCrochetHookTo
        self.standardGaugeStitches = yarnInfo.standardGaugeStitches
        self.standardGaugeRows = yarnInfo.standardGaugeRows
        self.length = yarnInfo.length
        self.weight = yarnInfo.weight
        self.tags = yarnInfo.tags
        self.folder = yarnInfo.folder
        self.laundrySymbols = yarnInfo.laundrySymbols
        self.images = yarnInfo.images
//        self.symbolId = yarnInfo.symbolId
//        self.symbolColorName = yarnInfo.symbolColorName
    }
}
struct InputYarnMaterial: Hashable, Identifiable {
    var id = UUID()
    //    var materialId: String = "none"
    var orderIndex: Int = 0
    var materialId: Int = 0
    var percentage: Int?
}
struct InputYarnStock: Hashable, Identifiable {
    var id = UUID()
    var sampleColor: Color = Color.random
    var images: [Data] = []
    var colorCode: String = ""
    var lotNumber: String = ""
    var memo: String = ""
    
    init(sampleColor: Color = Color.random, images: [Data] = [], colorCode: String = "", lotNumber: String = "", memo: String = ""){
        self.sampleColor = sampleColor
        self.images = images
        self.colorCode = colorCode
        self.lotNumber = lotNumber
        self.memo = memo
    }
    init(yarnStock: YarnStock){
        self.sampleColor = yarnStock.sampleColor.color
        self.images = yarnStock.images
        self.colorCode = yarnStock.colorCode
        self.lotNumber = yarnStock.lotNumber
        self.memo = yarnStock.memo
    }
}
struct InputYarnStockDetail: Hashable, Identifiable {
    var id = UUID()
    var status: YarnStockStatus
    var orderIndex: Int = 0
    var length: Double = 0
    var weight: Double = 0
    var isLink: Bool = true
    var usageRatio: Double = 1
    var memo: String = ""
    var info: YarnInfo
    init(status: YarnStockStatus, orderIndex: Int = 0, length: Double = 0, weight: Double = 0, isLink: Bool = true, usageRatio: Double = 1, memo: String = "", info: YarnInfo){
        self.status = status
        self.orderIndex = orderIndex
        self.length = length
        self.weight = weight
        self.isLink = isLink
        self.usageRatio = usageRatio
        self.memo = memo
        self.info = info

    }
    init(detail: YarnStockDetail, info: YarnInfo){
        self.status = detail.status
        self.orderIndex = detail.orderIndex
        self.length = detail.length
        self.weight = detail.weight
        self.isLink = detail.isLink
        self.usageRatio = detail.usageRatio
        self.memo = detail.memo
        self.info = info
    }
}
struct InputSwatch: Hashable, Identifiable {
    var id = UUID()
    var image: Data?
    var needleType: Int = 0
    var needleSize: Int = 0
    var stitches: Double?
    var rows: Double?
    var weight: Double?
    
    init(image: Data?=nil, needleType: Int = 0, needleSize: Int = 0, stitches: Double?=nil, rows: Double?=nil, weight: Double?=nil){
        self.image = image
        self.needleType = needleType
        self.needleSize = needleSize
        self.stitches = stitches
        self.rows = rows
        self.weight = weight
    }
    init(swatch: Swatch){
        self.image = swatch.image
        self.needleType = swatch.needleType
        self.needleSize = swatch.needleSize
        self.stitches = swatch.stitches
        self.rows = swatch.rows
        self.weight = swatch.weight
    }
}

struct InputTag: Hashable, Identifiable {
    var id = UUID()
    var color: Color = Color.random
    var name: String = ""
}
struct InputFolder: Hashable, Identifiable {
    var id = UUID()
//    var color: Color = Color.random
    var colorName: String = selectColors.randomElement()!
    var name: String = ""
}
