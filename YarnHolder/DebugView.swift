//
//  DebugView.swift
//  YarnHolder
//
//  Created by 岡山直也 on 2026/04/16.
//

import SwiftUI
import SwiftData

struct DebugView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var tags: [Tag]
    
    var body: some View {
        List{
            Button("インサートダミーデータ（日本語）"){
                insertDummyData(lang: "ja")
            }
            Button("インサートダミーデータ（英語）"){
                insertDummyData(lang: "en")
            }
            Button("タグ全消し"){
                for tag in tags {
                    modelContext.delete(tag)
                }
            }
        }

    }
    public func loadImageData(named imageName: String) -> Data? {
        guard let image = UIImage(named: imageName) else { return nil }
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return nil }
        return imageData
    }
    public func insertDummyData(lang: String){
        
        // ************フォルダ
        var folders: [Folder] = []
        var folderNames: [String]
        if lang == "ja"{
            folderNames = ["毛糸屋さん A", "B商店", "メーカーC"]
        } else {
            folderNames = ["Yarn Shop A", "B Store", "Manufacturer C"]
        }
        for i in 0..<3 {
            let folder = Folder(
                orderIndex: i,
                name: folderNames[i],
                colorName: selectColors.randomElement()!
            )
            modelContext.insert(folder)
            folders.append(folder)
        }
        
        // ************タグ
        var tags: [Tag] = []
        var tagNames: [String]
        if lang == "ja"{
            tagNames = ["アクリル", "コットン", "お気に入り", "残りわずか"]
        } else {
            tagNames = ["Acrylic", "Cotton", "Favorite", "Low stock"]
        }
        for i in 0..<4 {
            let tag = Tag(
                orderIndex: i,
                name: tagNames[i],
                color: ColorComponents(red: Float.random(in: 0.0...1.0), green: Float.random(in: 0.0...1.0), blue: Float.random(in: 0.0...1.0))
            )
            modelContext.insert(tag)
            tags.append(tag)
        }
        
        // ************毛糸情報
        var yarnInfos: [YarnInfo] = []
        var imageNames = ["test.yarn1-1", "test.yarn2-1", "test.yarn3", "test.yarn4"]
        var names: [String]
        var infos: [Double]
        if lang == "ja" {
            names = ["アクリルヤーン", "ふんわりナチュラル", "ひつじヤーン", "もこもこ毛糸"]
            infos = [17, 25, 15, 17, 20, 22, 25, 53]
        } else {
            names = ["Acrylic Yarn", "Soft Natural", "Sheep Yarn", "Fluffy Yarn"]
            infos = [17, 25, 16, 18, 20, 22, 25, 53]
        }
        for i in 0..<4 {
            let image = imageNames[i]
            let name = names[i]
            guard let imageData = loadImageData(named: image) else { return }
            var sampleImages: [Data] = [imageData]
            var yarnInfo = YarnInfo(
                name: name,
//                images: sampleImages,
            )
            yarnInfo.images = sampleImages
            yarnInfo.orderIndex = yarnInfos.count
            yarnInfo.folder = folders[Int.random(in: 0...2)]
            if i == 0{
                guard let image1 = loadImageData(named: "test.yarn1-2") else { return }
                guard let image2 = loadImageData(named: "test.yarn1-3") else { return }
                yarnInfo.laundrySymbols = [13, 23, 33, 46, 51, 62, 72]
                yarnInfo.standardGaugeStitches = infos[0]
                yarnInfo.standardGaugeRows = infos[1]
                yarnInfo.useKnittingNeedlesFrom = Int(infos[2])
                yarnInfo.useKnittingNeedlesTo = Int(infos[3])
                yarnInfo.useCrochetHookFrom = Int(infos[4])
                yarnInfo.useCrochetHookTo = Int(infos[5])
                yarnInfo.weight = infos[6]
                yarnInfo.length = infos[7]
                yarnInfo.tags = [tags[0], tags[2]]
                yarnInfo.images.append(image1)
                yarnInfo.images.append(image2)
            }
            if i == 1{
                guard let imageData = loadImageData(named: "test.yarn2-2") else { return }
                yarnInfo.images.append(imageData)
            }
            modelContext.insert(yarnInfo)
            yarnInfos.append(yarnInfo)
        }
        
        // ************毛糸の素材
        let yarnMaterial = YarnMaterial(
            yarnInfo: yarnInfos[0],
            orderIndex: 0,
            materialId: 9,
            percentage: 100,
        )
        modelContext.insert(yarnMaterial)
        
        // ************在庫
        var colorCode: [String]
        var lotNumber: [String]
        var stockImageNames = ["test.yarn1-1"]
        var memo: [String]
        if lang == "ja" {
            colorCode = ["203"]
            lotNumber = ["CA"]
            memo = ["2026年4月15日に購入"]
        } else {
            colorCode = ["203"]
            lotNumber = ["CA"]
            memo = ["Purchased on April 15, 2026."]
        }
        
        for i in 0..<1 {
            let image = stockImageNames[0]
            guard let imageData = loadImageData(named: image) else { return }
            let yarnStock = YarnStock(
                yarnInfo: yarnInfos[0],
                images: [imageData],
                sampleColor: ColorComponents(red: 241/255, green: 237/255, blue: 206/255),
                colorCode: colorCode[i],
                lotNumber: lotNumber[i],
                memo: memo[i],
            )
            modelContext.insert(yarnStock)
            
        }
        
        // ************スワッチ
        guard let swatchImageData = loadImageData(named: "test.swatch") else { return }
        let swatch = Swatch(
            yarnInfo: yarnInfos[0],
            image: swatchImageData,
            needleType: 0,
            needleSize: 18,
            stitches: 14,
            rows: 22,
        )
        modelContext.insert(swatch)
        
        
    }

}
