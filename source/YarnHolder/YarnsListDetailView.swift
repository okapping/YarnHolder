//
//  YarnsListDetailView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/08/11.
//


import SwiftUI
import Flow

struct YarnsListDetailView: View {
    @AppStorage("yarnsListDisplayMode") var yarnsListDisplayMode = 0
    var yarn: YarnInfo
    var folder: Folder?
    
    var body: some View {
//        if yarnsListDisplayMode == 0 {
//            YarnsListDetailNormalListView(yarn: yarn, folder: folder)
////                .animation(.easeInOut, value: yarnsListDisplayMode)
//                .swipeActions(edge: .trailing) {
//                    Button() {
//                        withAnimation {
//                            yarn.archiveFlg.toggle()
//                        }
//                    } label: {
//                        Image(systemName: "archivebox.fill")
//                    }
//                    .tint(.green)
//                }
//                .swipeActions(edge: .leading) {
//                    Button() {
//                        withAnimation {
//                            yarn.pinFlg.toggle()
//                        }
//                    } label: {
//                        Image(systemName: "pin.fill")
//                    }
//                    .tint(.orange)
//                }
//
//        } else if yarnsListDisplayMode == 1 {
//            YarnsListDetailDetailsListView(yarn: yarn, folder: folder)
////                .animation(.easeInOut, value: yarnsListDisplayMode)
//                .swipeActions(edge: .trailing) {
//                    Button() {
//                        withAnimation {
//                            yarn.archiveFlg.toggle()
//                        }
//                    } label: {
//                        Image(systemName: "archivebox.fill")
//                    }
//                    .tint(.green)
//                }
//                .swipeActions(edge: .leading) {
//                    Button() {
//                        withAnimation {
//                            yarn.pinFlg.toggle()
//                        }
//                    } label: {
//                        Image(systemName: "pin.fill")
//                    }
//                    .tint(.orange)
//                }
//
//        }
        
        VStack(alignment: .leading) {
            HStack {
                //                            Label(yarn.name, image: "yarn")
                //                            Label(yarn.name, image: "yarn")
                //            createImageView(for: getYarnSymbol(by: yarn.symbolId))
                //                .font(.title2)
                //                .frame(width: 36)
                //                .foregroundColor(yarn.symbolColor)
                //                            Image("yarn")
                VStack(alignment: .leading) {
                    // ******************************************************************
                    // 毛糸名とpinのマーク
                    HStack {
                        Text(yarn.name)
//                            .font(.title3)
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
                        //                    Spacer()
                        //                    ForEach(Array(yarn.stocks.sorted(by: { $0.orderIndex < $1.orderIndex }).enumerated()), id: \.element.id) { index, stock in
                        //                        //                            ForEach(yarn.stocks.sorted(by: { $0.orderIndex < $1.orderIndex })){ stock in
                        //                        if index < 3 {
                        //                            ZStack {
                        //                                Circle()
                        //                                    .foregroundColor(stock.sampleColor.color)
                        //                                    .frame(width: 30, height: 30)
                        //                                Text("\(stock.details.count)")
                        //                                    .font(.system(.body, design: .rounded))
                        //                                    .fontWeight(.bold)
                        //                                    .foregroundColor(stock.sampleColor.color.isLight ? .black : .white)
                        //                            }.padding(-6)
                        //
                        //                        }
                        //                    }
                        //                    if yarn.stocks.count > 3 {
                        //                        Image(systemName: "ellipsis")
                        //                            .font(.caption)
                        //                            .foregroundColor(.primary)
                        //                            .fontWeight(.bold)
                        //                    }
                    }
//                    .animation(.smooth, value: yarnsListDisplayMode)
                    // ******************************************************************:
                    // タグ
                    if yarnsListDisplayMode == 1 {
                        if let unwrappedTags = yarn.tags {
                            if !unwrappedTags.isEmpty {
                                HFlow {
                                    ForEach(unwrappedTags) { tag in
                                        HStack {
                                            //                                Image(systemName: "tag.fill")
                                            //                                    .foregroundColor(tag.color.color.isLight ? .black : .white)
                                            Text("\(Image(systemName: "number"))\(tag.name)")
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                                .foregroundColor(tag.color.color.isLight ? .black : .white)
                                        }
                                        //                            .font(.caption)
                                        .padding(3)
                                        .background(tag.color.color)
                                        .cornerRadius(30)
                                    }
                                }
                                .padding(EdgeInsets())
                            }
                        }
                    }
                    // ******************************************************************
                    // フォルダ
                    if yarnsListDisplayMode == 1 {
                        if let _ = folder {
                            
                        } else {
                            if let yarnFolder = yarn.folder {
                                HStack {
                                    Image(systemName: "folder")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .fontWeight(.bold)
                                    Text("\(yarnFolder.name)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .fontWeight(.bold)
                                    
                                }
                            } else {
                                HStack {
                                    Image(systemName: "questionmark.folder")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .fontWeight(.bold)
                                    Text("KEY_NONE_FOLDER")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .fontWeight(.bold)
                                    
                                }
                            }
                        }

                    }
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
            .padding(.vertical, 2)
            // ******************************************************************
            // 在庫の丸
            if yarnsListDisplayMode == 1 {
                if let wrappedStocks = yarn.stocks{
                    HFlow(spacing: 4){
                        if !wrappedStocks.isEmpty {
                            ForEach(Array(wrappedStocks.sorted(by: { $0.orderIndex < $1.orderIndex }).enumerated()), id: \.element.id) { index, stock in
                                HStack{
                                    if let wrappedDetails = stock.details{
                                        Text("\(wrappedDetails.count)")
                                            .font(.system(.callout, design: .rounded))
                                            .fontWeight(.bold)
                                        //                                    .padding(2)
                                            .foregroundColor(stock.sampleColor.color.isLight ? .black : .white)
                                        //                                    .background(stock.sampleColor.color)
                                        //                                    .cornerRadius(5)
                                    }
                                }
                                .frame(width: 25, height: 30)
                                .background(stock.sampleColor.color)
                                .cornerRadius(5)
                            }
                            Spacer()
                            Text(String(yarn.stocksCount))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 4)
                        } else {
                            HStack{}
                                .frame(width: 25, height: 30)
                            //                            .background(stock.sampleColor.color)
                            //                            .cornerRadius(5)
                        }
                    }
                    .padding(4)
                    .frame(maxWidth: .infinity)
                    .background(.primary.opacity(0.1))
                    .cornerRadius(5)

                }

            }
//            }
            // ******************************************************************
        }
//        .animation(.easeInOut, value: yarnsListDisplayMode)
        //                    }
        .swipeActions(edge: .trailing) {
            Button() {
                withAnimation {
                    yarn.archiveFlg.toggle()
                }
            } label: {
                Image(systemName: "archivebox.fill")
            }
            .tint(.green)
        }
        .swipeActions(edge: .leading) {
            Button() {
                withAnimation {
                    yarn.pinFlg.toggle()
                }
            } label: {
                Image(systemName: "pin.fill")
            }
            .tint(.orange)
        }

    }
}
