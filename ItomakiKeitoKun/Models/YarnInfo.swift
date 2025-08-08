//
//  Item.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/03/10.
//

import Foundation
import SwiftData

@Model
final class YarnInfo {
    var name: String
    // 在庫
    // 素材
    // 以下基本情報
    var orderIndex: Int = 0
    var standardGaugeStitches: Int?
    var standardGaugeRows: Int?
    var useKnittingNeedlesFrom: Int?
    var useKnittingNeedlesTo: Int?
    var useCrochetHookFrom: Int?
    var useCrochetHookTo: Int?
    var length: Double?
    var weight: Double?
    var memo: String
    
    var laundrySymbols: [Int] = []
    var images: [Data] = []
    var symbolId: Int = 1

    var createdAt: Date
    
    @Relationship(deleteRule: .cascade, inverse: \YarnMaterial.yarnInfo)
    var materials: [YarnMaterial] = []

    @Relationship(deleteRule: .cascade, inverse: \YarnStock.yarnInfo)
    var stocks: [YarnStock] = []

    @Relationship(deleteRule: .cascade, inverse: \Swatch.yarnInfo)
    var swatches: [Swatch] = []

    @Relationship(inverse: \Tag.yarns)
    var tags: [Tag] = []

    init(name: String="", memo: String="", createdAt: Date=Date()) {
        self.name = name
        self.memo = memo
        self.createdAt = createdAt
    }
    
    init(inputYarnInfo: InputYarnInfo) {
        self.name = inputYarnInfo.name
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
        self.laundrySymbols = inputYarnInfo.laundrySymbols
        self.images = inputYarnInfo.images
        self.symbolId = inputYarnInfo.symbolId
        self.createdAt = Date()
    }
}
