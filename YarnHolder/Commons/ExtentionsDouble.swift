//
//  ExtentionDouble.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/08/22.
//

import Foundation

extension Double {
    func roundedString() -> String {
        // 小数点以下2桁で四捨五入
        let roundedValue = (self * 100).rounded() / 100
        
        // Stringに変換
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        
        // フォーマットされた文字列を返す
        return formatter.string(from: NSNumber(value: roundedValue)) ?? "\(roundedValue)"
    }
}
