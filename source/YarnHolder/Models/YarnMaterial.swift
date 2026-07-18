//
//  YarnMaterial.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/03/14.
//

import Foundation
import SwiftData

@Model
final class YarnMaterial {
//    @Attribute(.unique)
//    var id: UUID = UUID()
    var yarnInfo: YarnInfo? = nil
//    var material: String
    var orderIndex: Int = 0
    var materialId: Int = 0
    var percentage: Int = 0
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
