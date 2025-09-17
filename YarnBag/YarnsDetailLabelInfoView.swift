//
//  YarnsDetailLabelInfoView.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/07/29.
//

import SwiftUI
import SwiftData
import TipKit
import Flow


struct YarnsDetailLabelInfoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.locale) var locale
    
    @AppStorage("appColorTheme") var appColorTheme = 10
    @AppStorage("weightUnit") var weightUnit = "g"
    @AppStorage("lengthUnit") var lengthUnit = "m"

    var yarnInfo: YarnInfo
    
    // delete yarn
    @State private var showYarnDeleteSheet = false
    @State private var showYarnArchiveSheet = false
    @Environment(\.presentationMode) var presentation
    
    // 画像拡大用
    @State private var showFullImage = false
    @State private var showImages: [showImageContainer] = []
    @State private var showImageIndex: Int = 0
    
    func dispNeedleSizeLabel(from needle: KnittingNeedlesSize) -> String {
        let code = locale.language.languageCode?.identifier ?? ""
        if code == "ja" {
            return needle.dispSizeJp
        } else {
            return "\(needle.mmSize)mm"
        }
    }
    func dispNeedleSizeLabel(from needle: CrochetHookSize) -> String {
        let code = locale.language.languageCode?.identifier ?? ""
        if code == "ja" {
            return needle.dispSizeJp
        } else {
            return "\(needle.mmSize)mm"
        }
    }

    var body: some View {
        // *******************************************
        List {
            // *******************************************
            // 画像
            Section(
//                header: ListTitleView(title: "画像")
            ) {
                if yarnInfo.images.isEmpty {
//                    Text("KEY_NOT_REGISTERED")
//                        .listStyle(.plain)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Array(yarnInfo.images.enumerated()), id: \.element) { i, image in
                                if let uiImage = UIImage(data: image) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 10)) // 角を丸くした四角形
                                        .frame(height:150)
                                        .onTapGesture {
                                            for tmpImage in yarnInfo.images{
                                                if let tmpUiImage = UIImage(data: tmpImage) {
                                                    let appendImage = showImageContainer(uiImage: tmpUiImage)
                                                    showImages.append(appendImage)
                                                }
                                            }
                                            print("detail view cnt = \(showImages.count)")
                                            showImageIndex = i
                                            showFullImage = true
                                        }

                                }
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }


            }
            // *******************************************
            // 素材
            Section(
                header:
                    HStack {
                        Image(systemName: "leaf.fill")
                            .font(.title3)
                        ListTitleView(title: "KEY_MATERIAL")
                }
            ) {
                if yarnInfo.materials.isEmpty {
                    Text("KEY_NOT_REGISTERED")
                }
                ForEach(yarnInfo.materials.sorted(by: { $0.orderIndex < $1.orderIndex })) {yarnMaterial in
                    HStack {
//                        Text("\(yarnMaterial.orderIndex)")
                        let material = getYarnMaterial(by: yarnMaterial.materialId)
                        let name = LocalizedStringKey(material.name)
                        Text(name)
                        //                            Text(Material(rawValue: yarnMaterial.materialId)!.name)
                        
                        Spacer()
                        Text("\(yarnMaterial.percentage)%")
                    }
                    
                }
            }
            // *******************************************
            // 洗濯表示
            Section(
                header:
                    HStack {
                        Image(systemName: "washer.fill")
                            .font(.title3)
                        ListTitleView(title: "KEY_CARE_LABEL")
                    }
            ) {
                NavigationLink{
                    List{
                        ForEach(yarnInfo.laundrySymbols, id: \.self) { symId in
                            if let symbol = getLaundrySymbol(by: symId){
                                HStack {
                                    Image(symbol.name)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.primary)
                                    Text(LocalizedStringKey(symbol.detail))
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        if yarnInfo.laundrySymbols.isEmpty {
                            Text("KEY_NOT_REGISTERED")
                        }
                        HFlow(spacing: 8) {
                            ForEach(yarnInfo.laundrySymbols, id: \.self) { symId in
                                if let symbol = getLaundrySymbol(by: symId){
                                    Image(symbol.name)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                }
//                HStack {
//                    if yarnInfo.laundrySymbols.isEmpty {
//                        Text("KEY_NOT_REGISTERED")
//                    }
//                    HFlow(spacing: 8) {
//                        ForEach(yarnInfo.laundrySymbols, id: \.self) { symId in
//                            LaundrySymbolImageView(symbolId: symId)
//                        }
//                    }
//                }
            }
            
            // *******************************************
            // 基本情報
            Section(
//                header: ListTitleView(title: "基本情報")
            ) {
                // 標準ゲージ
                HStack{
                    Text("KEY_STANDARD_GAUGE")
                    Spacer()
                    if let stitches = yarnInfo.standardGaugeStitches {
                        Text("KEY_STITCHES\(stitches.roundedString())")
                    }
                    if let rows = yarnInfo.standardGaugeRows {
                        Text("KEY_ROWS\(rows.roundedString())")
                    }
                }
                // 使用棒針
                HStack {
                    Text("KEY_USE_CIRCULAR_NEEDLE")
                    Spacer()
                    if let from = yarnInfo.useKnittingNeedlesFrom{
                        if let needle = getKnittingNeedlesSize(by: from){
                            Text(dispNeedleSizeLabel(from: needle))
                        }
                    }
                    if yarnInfo.useKnittingNeedlesFrom != nil || yarnInfo.useKnittingNeedlesTo != nil{
                        Image(systemName: "alternatingcurrent")
                    }
                    if let from = yarnInfo.useKnittingNeedlesTo{
                        if let needle = getKnittingNeedlesSize(by: from){
                            Text(dispNeedleSizeLabel(from: needle))
                        }
                    }
                }
                // 使用かぎ針
                HStack {
                    Text("KEY_USE_HOOK")
                    Spacer()
                    if let from = yarnInfo.useCrochetHookFrom{
                        if let needle = getCrochetHookSize(by: from){
                            Text(dispNeedleSizeLabel(from: needle))
                        }
                    }
                    if yarnInfo.useCrochetHookFrom != nil || yarnInfo.useCrochetHookTo != nil{
                        Image(systemName: "alternatingcurrent")
                    }
                    if let from = yarnInfo.useCrochetHookTo{
                        if let needle = getCrochetHookSize(by: from){
                            Text(dispNeedleSizeLabel(from: needle))
                        }
                    }
                }
                // 重さ
                HStack {
                    Text("KEY_WEIGHT")
                    Spacer()
                    if let weight = yarnInfo.weight{
                        Text("\(String(weight)) \(weightUnit)")
                    }
                }
                // 長さ
                HStack {
                    Text("KEY_LENGTH")
                    Spacer()
                    if let length = yarnInfo.length{
                        Text("\(String(length)) \(lengthUnit)")
                    }
                }
                
            }
            Section(
                header:
                    HStack {
                        Image(systemName: "note.text")
                            .font(.title3)
                        ListTitleView(title: "KEY_MEMO")
                    }
            ) {
                Text(yarnInfo.memo)
            }
//            Section() {
//                Text(showYarnArchiveSheet ? "true" : "false")
//                Button() {
//                    showYarnArchiveSheet = true
//                } label: {
//                    HStack{
//                        Spacer()
//                        Text("毛糸をアーカイブする")
//                        Spacer()
//                    }
//                    
//                }
//            }
            Section() {
                Button(role: .destructive) {
                    showYarnDeleteSheet = true
                } label: {
                    HStack{
                        Spacer()
                        Text("KEY_DELETE_YARN")
                        Spacer()
                    }
                    
                }
                .tint(.red)
            }

        }
        // アーカイブ確認用
//        .actionSheet(isPresented: $showYarnArchiveSheet){
//            ActionSheet(
//                title: Text("アーカイブします。よろしいですか？"),
//                buttons:[
//                    .destructive(Text("KEY_ARCHIVE")){
//                        archiveYarnInfo(yarnInfo: yarnInfo)
//                    },
//                        .cancel()
//                ]
//            )
//        }
        // 削除確認用
        .actionSheet(isPresented: $showYarnDeleteSheet){
            ActionSheet(
                title: Text("KEY_CONFIRM_DELETE_YARN_INFO"),
                //                message: Text("削除後は戻せません。削除してもよろしいですか？"),
                buttons:[
                    .destructive(Text("KEY_DELETE_YARN")){
                        deleteYarnInfo(yarnInfo: yarnInfo)
                    },
                        .cancel()
                ]
            )
        }
        .fullScreenCover(isPresented: $showFullImage, onDismiss: {
            showImages = []
        }, content: {
            FullImagesView(images: $showImages, selectIndex: $showImageIndex)
        })

    }
    private func archiveYarnInfo(yarnInfo: YarnInfo) {
        withAnimation{
            yarnInfo.archiveFlg = true
            try? modelContext.save()
        }
    }
    private func deleteYarnInfo(yarnInfo: YarnInfo) {
        // 念の為リレーション先を削除してから本体を削除する
        for material in yarnInfo.materials {
            modelContext.delete(material)
        }
        for stock in yarnInfo.stocks {
            for detail in stock.details {
                modelContext.delete(detail)
            }
            try? modelContext.save()
            modelContext.delete(stock)
        }
        for swatch in yarnInfo.swatches {
            modelContext.delete(swatch)
        }
//        for tag in yarnInfo.tags {
//            modelContext.delete(tag)
//        }
        try? modelContext.save()
        modelContext.delete(yarnInfo)
        try? modelContext.save()
        // 前の画面に戻る
        self.presentation.wrappedValue.dismiss()
    }

}

#Preview {
    YarnsDetailLabelInfoView(yarnInfo: .init())
}
