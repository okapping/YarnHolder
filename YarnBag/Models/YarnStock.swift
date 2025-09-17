//
//  YarnStock.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/04/03.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class YarnStock {
    @Attribute(.unique)
    var id: UUID = UUID()
    var yarnInfo: YarnInfo
    var orderIndex: Int = 0
    var images: [Data]
    var sampleColor: ColorComponents
    var colorCode: String
    var lotNumber: String
//    var inventory: Int
    var memo: String
    var createdAt: Date = Date()
    
    @Relationship(deleteRule: .cascade, inverse: \YarnStockDetail.yarnStock)
    var details: [YarnStockDetail] = []

    init(yarnInfo: YarnInfo, images: [Data]=[], sampleColor: ColorComponents=ColorComponents.fromColor(Color.random), colorCode: String="", lotNumber: String=""/*, inventory: Int=0*/,memo: String="") {
//        self.id = UUID()
        self.yarnInfo = yarnInfo
        self.orderIndex = yarnInfo.stocks.count
        self.images = images
        self.sampleColor = sampleColor
        self.colorCode = colorCode
        self.lotNumber = lotNumber
        self.memo = memo
    }
    init(yarnStock: YarnStock) {
        self.yarnInfo = yarnStock.yarnInfo
        self.orderIndex = yarnStock.yarnInfo.stocks.count
        self.images = yarnStock.images
        self.sampleColor = yarnStock.sampleColor
        self.colorCode = yarnStock.colorCode
        self.lotNumber = yarnStock.lotNumber
        self.memo = yarnStock.memo
    }
    init(yarnInfo: YarnInfo, input: InputYarnStock){
        let colorComponents = ColorComponents.fromColor(input.sampleColor)
        self.yarnInfo =  yarnInfo
        self.orderIndex =  yarnInfo.stocks.count
        self.images =  input.images
        self.sampleColor =  colorComponents
        self.colorCode =  input.colorCode
        self.lotNumber =  input.lotNumber
        self.memo =  input.memo

    }
}

