//
//  ItomakiKeitoKunApp.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/03/10.
//

import SwiftUI
import SwiftData

@MainActor
let previewYarn: ModelContainer = {
    do {
        // 毛糸基本情報の追加
        let schema = Schema([YarnInfo.self, YarnMaterial.self, YarnStock.self, Swatch.self])
        let container = try ModelContainer(for: schema, configurations: .init(isStoredInMemoryOnly: true))
        var yarnInfos: [YarnInfo] = []
        for i in 0..<10 {
            var yarnInfo = YarnInfo(name: "テスト毛糸 \(i)",memo: "これはメモです。テスト毛糸 \(i)のメモです。",createdAt: Date())
            yarnInfo.symbolId = Int.random(in: 1...64)
            print(yarnInfo.symbolId)
            container.mainContext.insert(yarnInfo)
            yarnInfos.append(yarnInfo)
        }

        // 素材情報の設定
        for i in 0..<30 {
            let yarnMaterial = YarnMaterial(
                yarnInfo: yarnInfos[Int.random(in: 0...9)],
                orderIndex: i,
                materialId: Int.random(in: 1...13),
                percentage: Int.random(in: 0...100),
                createdAt: Date()
            )
            container.mainContext.insert(yarnMaterial)
        }
        
        func generateRandomString(length: Int) -> String {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).compactMap { _ in letters.randomElement() })
        }

        // 在庫情報の設定
        for i in 0..<30 {
            if let imageData = loadImageData(named: "test.stock") {
                let yarnStock = YarnStock(
                    yarnInfo: yarnInfos[Int.random(in: 0...9)],
                    orderIndex: i,
                    image: imageData,
                    sampleColor: ColorComponents(red: Float.random(in: 0.0...1.0), green: Float.random(in: 0.0...1.0), blue: Float.random(in: 0.0...1.0)),
                    colorCode: generateRandomString(length: 5),
                    lotNumber: generateRandomString(length: 5),
                    inventory: Int.random(in: 0...20),
                    memo: "これはメモです。メモメモ",
                    createdAt: Date()
                )
                container.mainContext.insert(yarnStock)
            }
            
        }
        
        // タグ情報の設定
        for i in 0..<5 {
            let tag = Tag(
                name: "テストタグ\(i)",
                color: ColorComponents(red: Float.random(in: 0.0...1.0), green: Float.random(in: 0.0...1.0), blue: Float.random(in: 0.0...1.0))
            )
            container.mainContext.insert(tag)
        }
        
        // スワッチの設定
        func loadImageData(named imageName: String) -> Data? {
            guard let image = UIImage(named: imageName) else { return nil }
            guard let imageData = image.pngData() else { return nil }
            return imageData
        }
        
        for i in 0..<30 {
            if let imageData = loadImageData(named: "test.swatch") {
                let swatch = Swatch(
                    yarnInfo: yarnInfos[Int.random(in: 0...9)],
                    image: imageData,
                    needleType: Int.random(in: 0...1),
                    needleSize: Int.random(in: 0...20),
                    stitches: Int.random(in: 10...20),
                    rows: Int.random(in: 10...20),
                    createdAt: Date()
                )
                container.mainContext.insert(swatch)
            }
        }

        return container
    } catch {
        fatalError()
    }
}()

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
struct ItomakiKeitoKunApp: App {
    @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            YarnInfo.self,
//            YarnMaterial.self,
////            YarnMaterial.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(AppearanceModeSetting(rawValue: appearanceMode)?.colorScheme)
        }
//        .modelContainer(sharedModelContainer)
        .modelContainer(for: [YarnInfo.self, YarnMaterial.self])
    }
}
