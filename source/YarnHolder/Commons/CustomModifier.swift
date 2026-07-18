//
//  CustomModifier.swift
//  YarnHolder
//
//  Created by 岡山直也 on 2025/12/23.
//

import SwiftUI

struct ListHeaderButton: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .fontWeight(.bold)
                .buttonStyle(.bordered)
                .controlSize(.small)
                .buttonBorderShape(.capsule)
                .glassEffect()
        } else {
            content
                .fontWeight(.bold)
                .buttonStyle(.bordered)
                .controlSize(.small)
                .buttonBorderShape(.capsule)
        }
    }
}
extension View {
    func listHeaderButtonStyle() -> some View {
        self.modifier(ListHeaderButton())
    }
}

extension View {
    func modifier(@ViewBuilder _ closure: (Self) -> some View) -> some View {
        closure(self)
    }
}


//struct PhotoChangeModifier<T: Equatable>: ViewModifier {
//    @Binding var value: T?
//
//    func body(content: Content) -> some View {
//        content
//            .onChange(of: value) { newValue in
//                handlePhotoChange(photo: newValue)
//            }
//    }
//
//    private func handlePhotoChange(photo: T?) {
//        // ここに共通処理を書く
//        print("Photo changed: \(String(describing: photo))")
//    }
//}
