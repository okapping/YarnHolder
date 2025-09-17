//
//  Tag.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/07/16.
//

import Foundation
import SwiftData

@Model
final class Tag {
    /// ID
    @Attribute(.unique)
    var id: UUID = UUID()
    var orderIndex: Int
    var name: String
    var color: ColorComponents

    var createdAt: Date = Date()
    
    var yarns: [YarnInfo] = []
    
    init( orderIndex: Int=0, name: String = "", color: ColorComponents, yarns: [YarnInfo] = []) {
//        self.id = UUID()
        self.orderIndex = orderIndex
        self.name = name
        self.color = color
//        self.createdAt = Date()
        self.yarns = yarns
    }
}
