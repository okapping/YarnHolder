//
//  PhotosView.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/07/18.
//


import Foundation
import SwiftUI

struct PhotosView<T: View>: View {
    private let width: CGFloat
    private let height: CGFloat
    private let content: () -> T
    
    init(width: CGFloat, height: CGFloat, @ViewBuilder content: @escaping () -> T) {
        self.width = width
        self.height = height
        self.content = content
    }
    var body: some View {
        TabView {
            content()
        }
        .tabViewStyle(.page)
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
        .frame(width: width, height: height)
//        .background(Color(UIColor.secondarySystemFill))
    }
}
