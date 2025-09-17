//
//  YarnStockDetail.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/08/15.
//

import Foundation
import SwiftData

@Model
final class YarnStockDetail {
    @Attribute(.unique)
    var id: UUID = UUID()
    var yarnStock: YarnStock
    var orderIndex: Int = 0
//    var image: Data?
//    var sampleColor: ColorComponents
    var length: Double = 0
    var weight: Double = 0
    var isLink: Bool = true
    var usageRatio: Double = 1
    var memo: String = ""
    var createdAt: Date = Date()
    
    var status: YarnStockStatus 
    
    init(stock: YarnStock, status: YarnStockStatus) {
        self.yarnStock = stock
        self.status = status
        self.orderIndex = stock.details.count
        self.length = stock.yarnInfo.length ?? 0
        self.weight = stock.yarnInfo.weight ?? 0
        self.isLink = true
        self.usageRatio = 1
        self.memo = ""
    }
    
    init(yarnStock: YarnStock, input: InputYarnStockDetail, index: Int) {
        self.yarnStock = yarnStock
        self.orderIndex = index
        self.length = input.length
        self.weight = input.weight
        self.isLink = input.isLink
        self.usageRatio = input.usageRatio
        self.memo = input.memo
        self.status = input.status
    }
}

/*
 var id = UUID()
 var status: YarnStockStatus
 var orderIndex: Int = 0
 var length: Double = 0
 var weight: Double = 0
 var memo: String = ""
 var info: YarnInfo

 */
