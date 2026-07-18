//
//  Folder.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/08/11.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Folder {
    
    /// ID
//    @Attribute(.unique)
//    var id: UUID = UUID()
    var orderIndex: Int = 0
    var name: String = ""
    var colorName: String = "c.green"
//    var color: ColorComponents
    @Transient
    var color: Color {
        return Color(colorName)
    }

    var createdAt: Date = Date()
    
    @Relationship(deleteRule: .cascade, inverse: \YarnInfo.folder?)
    var yarns: [YarnInfo]? = []
    
    init(orderIndex: Int = 0, name: String = "", colorName: String="c.green", yarns: [YarnInfo] = []) {
        self.orderIndex = orderIndex
        self.name = name
        self.colorName = colorName
        self.createdAt = Date()
        self.yarns = yarns
    }
}
