//
//  InputModels.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/08/06.
//

import SwiftUI
import SwiftData

@Observable
class InputYarnInfo {
    var name: String
    var memo: String
    var useKnittingNeedlesFrom: Int?
    var useKnittingNeedlesTo: Int?
    var useCrochetHookFrom: Int?
    var useCrochetHookTo: Int?
    var standardGaugeStitches: Int?
    var standardGaugeRows: Int?
    var length: Double?
    var weight: Double?
    var tags: [Tag] = []
    var laundrySymbols: [Int] = []
    var images: [Data] = []
    var symbolId: Int = 1
    init(name: String = "", memo: String = "") {
        self.name = name
        self.memo = memo
    }
    init(yarnInfo: YarnInfo){
        self.name = yarnInfo.name
        self.memo = yarnInfo.memo
        self.useKnittingNeedlesFrom = yarnInfo.useKnittingNeedlesFrom
        self.useKnittingNeedlesTo = yarnInfo.useKnittingNeedlesTo
        self.useCrochetHookFrom = yarnInfo.useCrochetHookFrom
        self.useCrochetHookTo = yarnInfo.useCrochetHookTo
        self.standardGaugeStitches = yarnInfo.standardGaugeStitches
        self.standardGaugeRows = yarnInfo.standardGaugeRows
        self.length = yarnInfo.length
        self.weight = yarnInfo.weight
        self.tags = yarnInfo.tags
        self.laundrySymbols = yarnInfo.laundrySymbols
        self.images = yarnInfo.images
        self.symbolId = yarnInfo.symbolId
    }
}
//@Observable
//class InputYarnMaterial: Identifiable {
//    var material: String
//    var percentage: Double
//    init(material: String = "none", percentage :Double = 0.0) {
//        self.material = material
//        self.percentage = percentage
//    }
//}
struct InputYarnMaterial: Hashable, Identifiable {
    var id = UUID()
    //    var materialId: String = "none"
    var orderIndex: Int = 0
    var materialId: Int = 0
    var percentage: Int?
}
struct InputYarnStock: Hashable, Identifiable {
    var id = UUID()
    var sampleColor: Color = Color.random
    var image: Data?
    var colorCode: String = ""
    var lotNumber: String = ""
    var inventory: Int = 0
    var memo: String = ""
}
struct InputSwatch: Hashable, Identifiable  {
    var id = UUID()
    var image: Data?
    var needleType: Int = 0
    var needleSize: Int = 0
    var stitches: Int?
    var rows: Int?
}

struct InputTag: Hashable, Identifiable {
    var id = UUID()
    var color: Color = .gray
    var name: String = ""
}
