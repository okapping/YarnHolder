//
//  FullImagesView.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/08/28.
//


import SwiftUI
import Zoomable

struct showImageContainer: Identifiable, Hashable {
    var id = UUID()
    var uiImage: UIImage
}

struct FullImagesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var images: [showImageContainer]
    @Binding var selectIndex: Int
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            // 透明なビューを重ねてナビゲーションバーのタップを無効にする
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    // 何もしない
                }
            TabView(selection: $selectIndex) {
                ForEach(Array(images.enumerated()), id: \.element) { i, image in
//                    ZoomableImageView(image: image.uiImage)
                    Image(uiImage: image.uiImage)
                        .resizable()
                        .scaledToFit()
//                        .aspectRatio(1, contentMode: .fit)
                        .zoomable()
                        .tag(i)
                }
            }
            .tabViewStyle(PageTabViewStyle())
//            if let uiImage = selectModalPhoto {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//                    .transition(.move(edge: .bottom))
//                    .zoomable()
//            }
            VStack {
                HStack {
                    Spacer()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .symbolRenderingMode(.hierarchical)
                    }.padding()
                }
                Spacer()
            }

        }
        .onAppear{
            print("full image view cnt = \(images.count)")
        }
        .presentationBackground(Color.clear)
//        .gesture(
//            DragGesture()
//                .onEnded { gesture in
//                    let horizontalTranslation = gesture.translation.width
//                    let verticalTranslation = gesture.translation.height
//                    
//                    if abs(horizontalTranslation) > abs(verticalTranslation) {
//                        // 水平方向のスワイプ
//                        if horizontalTranslation > 0 {
//                            // 右にスワイプした場合の処理
////                            self.labelText = "右にスワイプしました"
//                        } else {
//                            // 左にスワイプした場合の処理
////                            self.labelText = "左にスワイプしました"
//                        }
//                    } else {
//                        // 垂直方向のスワイプ
//                        if verticalTranslation > 0 {
//                            presentationMode.wrappedValue.dismiss()
//                            // 下にスワイプした場合の処理
////                            self.labelText = "下にスワイプしました"
//                        } else {
//                            // 上にスワイプした場合の処理
////                            self.labelText = "上にスワイプしました"
//                        }
//                    }
//                }
//        )

    }
}
