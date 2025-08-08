//
//  ColorExtensions.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/07/31.
//
import Foundation
import SwiftUI

extension Color {
    var relativeLuminance: CGFloat {
        // 色の相対輝度を計算する
        return 0.2126 * components.red + 0.7152 * components.green + 0.0722 * components.blue
    }
    
    private var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        // 色の成分を取得する
        var redComponent: CGFloat = 0
        var greenComponent: CGFloat = 0
        var blueComponent: CGFloat = 0
        var alphaComponent: CGFloat = 0
        
        UIColor(self).getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent)
        
        return (redComponent, greenComponent, blueComponent, alphaComponent)
    }
    
    // isLight
    var isLight: Bool {
        // 色の相対輝度が0.5以上の場合は明るい色と判定する
        return relativeLuminance >= 0.5
    }
    
    // random
    static var random: Color {
        // ランダムな色を生成する
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
    
    // toHex
    func toHex() -> String {
        // 色を16進数に変換する
        let components = self.components
        let red = Int(components.red * 255)
        let green = Int(components.green * 255)
        let blue = Int(components.blue * 255)
        return String(format: "#%02X%02X%02X", red, green, blue)
    }

}
