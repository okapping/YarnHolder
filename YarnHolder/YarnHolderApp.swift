//
//  YarnStockerApp.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/03/10.
//

import SwiftUI
import SwiftData

//@MainActor
//let previewYarn: ModelContainer = {
//    do {
//        // 毛糸基本情報の追加
//        print("previewYarn START")
//        let schema = Schema([Folder.self, YarnInfo.self, YarnMaterial.self/*, YarnStock.self*/, Tag.self/*, Swatch.self*/])
//        let container = try ModelContainer(for: schema, configurations: .init(isStoredInMemoryOnly: true))
//        // フォルダの追加
//        print("Folder START")
//        var folders: [Folder] = []
//        for i in 0..<3 {
//            var folder = Folder(
//                orderIndex: i,
//                name: "テストフォルダ \(i)",
//                colorName: selectColors.randomElement()!
//            )
//            container.mainContext.insert(folder)
//            folders.append(folder)
//        }
//        
//        print("YarnInfo START")
//        var yarnInfos: [YarnInfo] = []
//        for i in 0..<10 {
//            var yarnInfo = YarnInfo(
//                name: "テスト毛糸 \(i)",
////                memo: "これはメモです。テスト毛糸 \(i)のメモです。",
////                symbolColor: ColorComponents(red: Float.random(in: 0.0...1.0), green: Float.random(in: 0.0...1.0), blue: Float.random(in: 0.0...1.0)),
////                createdAt: Date()
//            )
//            yarnInfo.orderIndex = yarnInfos.count
////            yarnInfo.symbolId = Int.random(in: 1...64)
//            yarnInfo.folder = folders[Int.random(in: 0...2)]
////            print(yarnInfo.symbolId)
//            container.mainContext.insert(yarnInfo)
//            yarnInfos.append(yarnInfo)
//        }
//
//        print("YarnMaterial START")
//        // 素材情報の設定
//        for i in 0..<30 {
//            let yarnMaterial = YarnMaterial(
//                yarnInfo: yarnInfos[Int.random(in: 0...9)],
//                orderIndex: i,
//                materialId: Int.random(in: 1...13),
//                percentage: Int.random(in: 0...100),
////                createdAt: Date()
//            )
//            container.mainContext.insert(yarnMaterial)
//        }
//        
//        func generateRandomString(length: Int) -> String {
//            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//            return String((0..<length).compactMap { _ in letters.randomElement() })
//        }
//
//        print("YarnStock START")
//        // 在庫情報の設定
//        for i in 0..<10 {
//            if let imageData = loadImageData(named: "test.stock") {
//                let yarnStock = YarnStock(
//                    yarnInfo: yarnInfos[Int.random(in: 0...9)],
////                    orderIndex: i,
//                    images: [imageData],
//                    sampleColor: ColorComponents(red: Float.random(in: 0.0...1.0), green: Float.random(in: 0.0...1.0), blue: Float.random(in: 0.0...1.0)),
//                    colorCode: generateRandomString(length: 5),
//                    lotNumber: generateRandomString(length: 5),
////                    inventory: Int.random(in: 0...20),
//                    memo: "これはメモです。メモメモ",
////                    createdAt: Date()
//                )
//                container.mainContext.insert(yarnStock)
//            }
//            
//        }
//        
//        print("Tag START")
//        // タグ情報の設定
//        for i in 0..<5 {
//            let tag = Tag(
//                orderIndex: i,
//                name: "テストタグ\(i)",
//                color: ColorComponents(red: Float.random(in: 0.0...1.0), green: Float.random(in: 0.0...1.0), blue: Float.random(in: 0.0...1.0))
//            )
//            container.mainContext.insert(tag)
//        }
//        
//        print("Swatch START")
////        // スワッチの設定
//        func loadImageData(named imageName: String) -> Data? {
//            guard let image = UIImage(named: imageName) else { return nil }
//            guard let imageData = image.pngData() else { return nil }
//            return imageData
//        }
////        
//        for i in 0..<10 {
//            if let imageData = loadImageData(named: "test.swatch") {
//                let swatch = Swatch(
//                    yarnInfo: yarnInfos[Int.random(in: 0...9)],
//                    orderIndex: i,
//                    image: imageData,
//                    needleType: Int.random(in: 0...1),
//                    needleSize: Int.random(in: 0...20),
//                    stitches: Double.random(in: 10...20),
//                    rows: Double.random(in: 10...20),
////                    createdAt: Date()
//                )
//                container.mainContext.insert(swatch)
//            }
//        }
//        
//        let statuses = ["新品","解いた毛糸","修復済み","使用不可"]
//        // yarn stock status
//        for i in 0..<statuses.count {
//            let newStatus = YarnStockStatus(
//                orderIndex: i,
//                name: statuses[i],
//                isDefault: i == 0
//            )
//            container.mainContext.insert(newStatus)
//        }
////        let statusNew = YarnStockStatus(
////            orderIndex: 0,
////            name: ""
////        )
////        container.mainContext.insert(statusNew)
////        let statusOld = YarnStockStatus(
////            orderIndex: 1,
////            name: ""
////        )
////        container.mainContext.insert(statusOld)
//
//        
//        print("return container")
//        return container
//    } catch {
//        fatalError()
//    }
//}()

enum AppearanceModeSetting: Int {
    case followSystem = 0
    case lightMode = 1
    case darkMode = 2
    
    var colorScheme: ColorScheme? {
        switch self {
        case .followSystem:
            return .none
        case .lightMode:
            return .light
        case .darkMode:
            return .dark
        }
    }
}

@main
struct YarnStockerApp: App {
    @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
    
//    @Environment(\.modelContext) private var modelContext
//    @Environment(\.presentationMode) var presentationMode
//    @Query var stockStatuses: [YarnStockStatus]

    init(){
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Folder.self,
            YarnInfo.self,
            YarnMaterial.self,
            YarnStock.self,
            Tag.self,
            Swatch.self,
            YarnStockDetail.self,
            YarnStockStatus.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
//            ZoomTransition()
//            FeedbackListView()
                .preferredColorScheme(AppearanceModeSetting(rawValue: appearanceMode)?.colorScheme)
        }
        .modelContainer(sharedModelContainer)
//        .modelContainer(for: [
//            Folder.self,
//            YarnInfo.self,
//            YarnMaterial.self,
//            YarnStock.self,
//            Tag.self,
//            Swatch.self,
//            YarnStockDetail.self,
//            YarnStockStatus.self
//        ])
    }
}
