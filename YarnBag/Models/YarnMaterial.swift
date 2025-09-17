//
//  YarnMaterial.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/03/14.
//

import Foundation
import SwiftData

@Model
final class YarnMaterial {
    @Attribute(.unique)
    var id: UUID = UUID()
    var yarnInfo: YarnInfo
//    var material: String
    var orderIndex: Int
    var materialId: Int
    var percentage: Int
    var createdAt: Date = Date()
    
    init(yarnInfo: YarnInfo,orderIndex: Int=0, materialId: Int=0, percentage: Int=0) {
//        self.id = UUID()
        self.yarnInfo = yarnInfo
        self.orderIndex = orderIndex
        self.materialId = materialId
        self.percentage = percentage
//        self.createdAt = Date()
    }
    
//    init(yarnInfo: YarnInfo, inputYarnMaterial: InputYarnMaterial) {
//        self.yarnInfo = yarnInfo
//        self.materialId = inputYarnMaterial.materialId
//        self.percentage = inputYarnMaterial.percentage ?? 0
//        self.createdAt = Date()
//    }
}
