//
//  Item.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/03/10.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class YarnInfo {
    @Attribute(.unique)
    var id: UUID = UUID()
    var name: String
    // 以下基本情報
    var orderIndex: Int = 0
    var standardGaugeStitches: Double?
    var standardGaugeRows: Double?
    var useKnittingNeedlesFrom: Int?
    var useKnittingNeedlesTo: Int?
    var useCrochetHookFrom: Int?
    var useCrochetHookTo: Int?
    var length: Double?
    var weight: Double?
    var memo: String = ""
    
    var laundrySymbols: [Int] = []
    var images: [Data] = []
//    var symbolId: Int = 1
//    var symbolColorName: String = selectColors.randomElement()!
//    var symbolColor: Color {
//        return Color(symbolColorName)
//    }

    // 以下内部データ系
    var pinFlg: Bool = false
    var archiveFlg: Bool = false
    var stocksCount: Int {
        var cnt = 0
        for stock in stocks {
            cnt = cnt + stock.details.count
        }
        return cnt
    }
    
    var createdAt: Date = Date()
    
    var folder: Folder? = nil
    @Relationship(deleteRule: .cascade, inverse: \YarnMaterial.yarnInfo)
    var materials: [YarnMaterial] = []

    @Relationship(deleteRule: .cascade, inverse: \YarnStock.yarnInfo)
    var stocks: [YarnStock] = []

    @Relationship(deleteRule: .cascade, inverse: \Swatch.yarnInfo)
    var swatches: [Swatch] = []

    @Relationship(inverse: \Tag.yarns)
    var tags: [Tag] = []

    init(
        name: String="",length: Double? = 0,weight: Double? = 0,memo: String=""
    ) {
        self.name = name
        self.length = length
        self.weight = weight
        self.memo = memo
    }
    
    init(inputYarnInfo: InputYarnInfo, index: Int) {
        self.name = inputYarnInfo.name
        self.orderIndex = index
        self.useKnittingNeedlesFrom = inputYarnInfo.useKnittingNeedlesFrom
        self.useKnittingNeedlesTo = inputYarnInfo.useKnittingNeedlesTo
        self.useCrochetHookFrom = inputYarnInfo.useCrochetHookFrom
        self.useCrochetHookTo = inputYarnInfo.useCrochetHookTo
        self.standardGaugeStitches = inputYarnInfo.standardGaugeStitches
        self.standardGaugeRows = inputYarnInfo.standardGaugeRows
        self.length = inputYarnInfo.length
        self.weight = inputYarnInfo.weight
        self.memo = inputYarnInfo.memo
        self.tags = inputYarnInfo.tags
        self.folder = inputYarnInfo.folder
        self.laundrySymbols = inputYarnInfo.laundrySymbols
        self.images = inputYarnInfo.images
//        self.symbolId = inputYarnInfo.symbolId
//        self.symbolColorName = inputYarnInfo.symbolColorName
    }
}
