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
    @Attribute(.unique)
    var id: UUID = UUID()
    var yarnInfo: YarnInfo
    var orderIndex: Int = 0
    var image: Data?
    var needleType: Int = 0
    var needleSize: Int = 0
    var stitches: Double = 0
    var rows: Double = 0
    var weight: Double = 0
//    var stock: YarnStock? = nil
    var createdAt: Date = Date()
    
    init(yarnInfo: YarnInfo, orderIndex: Int=0, image: Data?, needleType: Int=0, needleSize: Int=0, stitches: Double=0, rows: Double=0, weight: Double=0) {
//        self.id = UUID()
        self.yarnInfo = yarnInfo
        self.orderIndex = orderIndex
        self.image = image
        self.needleType = needleType
        self.needleSize = needleSize
        self.stitches = stitches
        self.weight = weight
        self.rows = rows
//        self.createdAt = Date()
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
            return size.dispSizeJp
        } else if needleType == 1 {
            guard let size = getCrochetHookSize(by: needleSize) else { return "エラー" }
            return size.dispSizeJp
        } else if needleType == 9 {
            return "\(needleSize)"
        } else {
            return "エラー"
        }

    }
}
