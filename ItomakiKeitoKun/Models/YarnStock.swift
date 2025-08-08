//
//  YarnStock.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/04/03.
//

import Foundation
import SwiftData

@Model
final class YarnStock {
    var yarnInfo: YarnInfo
    var orderIndex: Int
    var image: Data?
    var sampleColor: ColorComponents
    var colorCode: String
    var lotNumber: String
    var inventory: Int
    var memo: String
    var createdAt: Date
    
    init(yarnInfo: YarnInfo, orderIndex: Int=0, image: Data?, sampleColor: ColorComponents, colorCode: String="", lotNumber: String="", inventory: Int=0,memo: String="", createdAt: Date=Date()) {
        self.yarnInfo = yarnInfo
        self.orderIndex = orderIndex
        self.image = image
        self.sampleColor = sampleColor
        self.colorCode = colorCode
        self.lotNumber = lotNumber
        self.inventory = inventory
        self.memo = memo
        self.createdAt = createdAt
    }
    
}

