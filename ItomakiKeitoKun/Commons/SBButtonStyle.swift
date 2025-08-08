//
//  SBButtonStyle.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/04/13.
//

import Foundation
import SwiftUI

struct SBButtonStyle: ButtonStyle {
  let onTouchDown: () -> Void
  let onTouchUp: () -> Void
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .onChange(of: configuration.isPressed) { $0 ? onTouchDown() : onTouchUp() }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .contentShape(Rectangle())
  }
}

