//
//  YarnStock.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/04/03.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class YarnStock {
//    @Attribute(.unique)
//    var id: UUID = UUID()
    var yarnInfo: YarnInfo? = nil
    var orderIndex: Int = 0
    var images: [Data] = []
    var sampleColor: ColorComponents = ColorComponents.fromColor(Color.blue)
    var colorCode: String = ""
    var lotNumber: String = ""
//    var inventory: Int
    var memo: String = ""
    var createdAt: Date = Date()
    
    @Relationship(deleteRule: .cascade, inverse: \YarnStockDetail.yarnStock?)
    var details: [YarnStockDetail]? = []
    
    // 総メートル数
    @Transient var totalLength: Double {
        var len: Double = 0.0
        if let wrapedDetails = details {
            for detail in wrapedDetails {
                len = len + detail.length
            }
        }
        return len
    }
    // 総重量
    @Transient var totalWeight: Double {
        var wei: Double = 0.0
        if let wrapedDetails = details {
            for detail in wrapedDetails {
                wei = wei + detail.weight
            }
        }
        return wei
    }


    init(yarnInfo: YarnInfo, images: [Data]=[], sampleColor: ColorComponents=ColorComponents.fromColor(Color.random), colorCode: String="", lotNumber: String=""/*, inventory: Int=0*/,memo: String="") {
//        self.id = UUID()
        self.yarnInfo = yarnInfo
        self.orderIndex = yarnInfo.stocks?.count ?? 0
        self.images = images
        self.sampleColor = sampleColor
        self.colorCode = colorCode
        self.lotNumber = lotNumber
        self.memo = memo
    }
    init(yarnStock: YarnStock) {
        self.yarnInfo = yarnStock.yarnInfo
        self.orderIndex = yarnStock.yarnInfo?.stocks?.count ?? 0
        self.images = yarnStock.images
        self.sampleColor = yarnStock.sampleColor
        self.colorCode = yarnStock.colorCode
        self.lotNumber = yarnStock.lotNumber
        self.memo = yarnStock.memo
    }
    init(yarnInfo: YarnInfo, input: InputYarnStock){
        let colorComponents = ColorComponents.fromColor(input.sampleColor)
        self.yarnInfo =  yarnInfo
        self.orderIndex =  yarnInfo.stocks?.count ?? 0
        self.images =  input.images
        self.sampleColor =  colorComponents
        self.colorCode =  input.colorCode
        self.lotNumber =  input.lotNumber
        self.memo =  input.memo

    }
}

