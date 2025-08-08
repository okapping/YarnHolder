//
//  Swatch.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/07/18.
//

import Foundation
import SwiftData

@Model
final class Swatch {
    var yarnInfo: YarnInfo
    var orderIndex: Int
    var image: Data?
    var needleType: Int
    var needleSize: Int
    var stitches: Int
    var rows: Int
    var createdAt: Date
    
    init(yarnInfo: YarnInfo, orderIndex: Int=0, image: Data?, needleType: Int=0, needleSize: Int=0, stitches: Int=0, rows: Int=0, createdAt: Date=Date()) {
        self.yarnInfo = yarnInfo
        self.orderIndex = orderIndex
        self.image = image
        self.needleType = needleType
        self.needleSize = needleSize
        self.stitches = stitches
        self.rows = rows
        self.createdAt = createdAt
    }
    
    // 表示用
    var needleName: String {
        if needleType == 0 {
            return "棒針"
        } else if needleType == 1 {
            return "かぎ針"
        } else if needleType == 9 {
            return "その他"
        } else {
            return "エラー"
        }
    }
    
    var needleSizeName: String {
        if needleType == 0 {
            guard let size = getKnittingNeedlesSize(by: needleSize) else { return "エラー" }
            return size.number
        } else if needleType == 1 {
            guard let size = getCrochetHookSize(by: needleSize) else { return "エラー" }
            return size.number
        } else if needleType == 9 {
            return String(needleSize)
        } else {
            return "エラー"
        }

    }
}
