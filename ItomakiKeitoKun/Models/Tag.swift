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
    var id: UUID
    // タグ名
    var name: String
    // 色コード
    var color: ColorComponents
    /// 作成日時
    var createdAt: Date
    
    var yarns: [YarnInfo] = []
    
    init(name: String = "", color: ColorComponents, yarns: [YarnInfo] = []) {
        self.id = UUID()
        self.name = name
        self.color = color
        self.createdAt = Date()
        self.yarns = yarns
    }
}
