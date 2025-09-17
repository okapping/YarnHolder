//
//  ColorComponents.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/04/13.
//

import Foundation
import SwiftUI

struct ColorComponents: Codable {
    let red: Float
    let green: Float
    let blue: Float

    var color: Color {
        Color(red: Double(red), green: Double(green), blue: Double(blue))
    }

    static func fromColor(_ color: Color) -> ColorComponents {
        let resolved = color.resolve(in: EnvironmentValues())
        return ColorComponents(
            red: resolved.red,
            green: resolved.green,
            blue: resolved.blue
        )
    }
}
