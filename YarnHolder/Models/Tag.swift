//
//  Tag.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/07/16.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Tag {
    /// ID
//    @Attribute(.unique)
//    var id: UUID = UUID()
    var orderIndex: Int = 0
    var name: String = ""
    var color: ColorComponents = ColorComponents.fromColor(Color.blue)

    var createdAt: Date = Date()
    
    var yarns: [YarnInfo]? = []
    
    init( orderIndex: Int=0, name: String = "", color: ColorComponents, yarns: [YarnInfo] = []) {
//        self.id = UUID()
        self.orderIndex = orderIndex
        self.name = name
        self.color = color
//        self.createdAt = Date()
        self.yarns = yarns
    }
}
