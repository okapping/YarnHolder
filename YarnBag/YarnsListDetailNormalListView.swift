//
//  YarnsListDetailNormalListView.swift
//  YarnBag
//
//  Created by 岡山直也 on 2025/09/14.
//

import SwiftUI
import Flow

struct YarnsListDetailNormalListView: View {
    var yarn: YarnInfo
    var folder: Folder?
    
    var body: some View {
        HStack {
            Text(yarn.name)
                .font(.headline)
                .fontWeight(.bold)
            if yarn.pinFlg {
                Image(systemName: "pin.fill")
                    .font(.caption)
                    .foregroundStyle(.cAmber)
            }
            if yarn.archiveFlg {
                Image(systemName: "archivebox.fill")
                    .font(.caption)
                    .foregroundStyle(.cGreen)
            }
            Spacer()
            // ******************************************************************
            // 画像
            if let image = yarn.images.first {
                if let uiImage = UIImage(data: image) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                    //                    .frame(width: 80, height: 80)
                        .frame(width: 48, height: 48)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 10)) // 角を丸くした四角形
                }
            }

        }
    }
}

