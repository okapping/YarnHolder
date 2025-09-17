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

struct colorTheme: Identifiable, Hashable {
    let id: Int
    let dispName: String
    let sysName: String
}

let colorThemes: [colorTheme] = [
    colorTheme(id: 1, dispName: "KEY_COLOR_RED", sysName: "c.red"),
    colorTheme(id: 2, dispName: "KEY_COLOR_ORANGE", sysName: "c.orange"),
    colorTheme(id: 3, dispName: "KEY_COLOR_AMBER", sysName: "c.amber"),
    colorTheme(id: 4, dispName: "KEY_COLOR_YELLOW", sysName: "c.yellow"),
    colorTheme(id: 5, dispName: "KEY_COLOR_LIME", sysName: "c.lime"),
    colorTheme(id: 6, dispName: "KEY_COLOR_GREEN", sysName: "c.green"),
    colorTheme(id: 7, dispName: "KEY_COLOR_EMERALD", sysName: "c.emerald"),
    colorTheme(id: 8, dispName: "KEY_COLOR_TEAL", sysName: "c.teal"),
    colorTheme(id: 9, dispName: "KEY_COLOR_CYAN", sysName: "c.cyan"),
    colorTheme(id: 10, dispName: "KEY_COLOR_SKY", sysName: "c.sky"),
    colorTheme(id: 11, dispName: "KEY_COLOR_BLUE", sysName: "c.blue"),
    colorTheme(id: 12, dispName: "KEY_COLOR_INDIGO", sysName: "c.indigo"),
    colorTheme(id: 13, dispName: "KEY_COLOR_VIOLET", sysName: "c.violet"),
    colorTheme(id: 14, dispName: "KEY_COLOR_PURPLE", sysName: "c.purple"),
    colorTheme(id: 15, dispName: "KEY_COLOR_FUCHSIA", sysName: "c.fuchsia"),
    colorTheme(id: 16, dispName: "KEY_COLOR_PINK", sysName: "c.pink"),
    colorTheme(id: 17, dispName: "KEY_COLOR_SLATE", sysName: "c.slate"),
    colorTheme(id: 18, dispName: "KEY_COLOR_STONE", sysName: "c.stone"),
]

func getColorTheme(by id: Int) -> colorTheme {
    return colorThemes.first { $0.id == id } ?? colorTheme(id: 7, dispName: "KEY_COLOR_EMERALD", sysName: "c.emerald")
//    let color = colorThemes.first { $0.id == id }
//    if let color = color {
//        return color
//    } else {
//        return colorTheme(id: 11, dispName: "ブルー", sysName: "c.blue")
//    }
//        return color
//    } else {
//        return colorTheme(id: 11, dispName: "ブルー", sysName: "c.blue")
//    }
}

let selectColors: [String] = [
    "c.red",
    "c.orange",
    "c.amber",
    "c.yellow",
    "c.lime",
    "c.green",
    "c.emerald",
    "c.teal",
    "c.cyan",
    "c.sky",
    "c.blue",
    "c.indigo",
    "c.violet",
    "c.purple",
    "c.fuchsia",
    "c.pink",
    "c.slate",
    "c.stone"
]
