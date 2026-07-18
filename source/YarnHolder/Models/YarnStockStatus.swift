//
//  YarnStockStatus.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/08/15.
//
import Foundation
import SwiftData

@Model
final class YarnStockStatus {
//    @Attribute(.unique)
//    var id: UUID = UUID()
    @Relationship(deleteRule: .cascade, inverse: \YarnStockDetail.status?)
    var details: [YarnStockDetail]? = []
    var orderIndex: Int = 0
    var name: String = ""
    var isDefault : Bool = false
    var createdAt: Date = Date()
    
    init(details: [YarnStockDetail]=[], orderIndex: Int=0, name: String="", isDefault: Bool=false) {
//        self.id = UUID()
        self.details = details
        self.orderIndex = orderIndex
        self.name = name
        self.isDefault = isDefault
//        self.createdAt = Date()
    }
    
}
