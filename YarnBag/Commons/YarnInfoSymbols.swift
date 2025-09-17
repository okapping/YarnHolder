//
//  YarnInfoSymbols.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/08/06.
//
import Foundation
import SwiftUI

struct YarnSymbol: Identifiable, Hashable {
    let id: Int
    let name: String
//    let detail: String
    let groupId: Int
}

let defaultYarnSymbol = YarnSymbol(id: 1, name: "yarn", groupId: 1)

// 洗濯表示のマスターデータ
let yarnSymbols: [YarnSymbol] = [
    defaultYarnSymbol,
    YarnSymbol(id: 2, name: "wheat", groupId: 1),
    YarnSymbol(id: 3, name: "alpaca", groupId: 1),
    YarnSymbol(id: 4, name: "corn", groupId: 1),
    YarnSymbol(id: 5, name: "diamond", groupId: 1),
    YarnSymbol(id: 6, name: "diamond2", groupId: 1),
    YarnSymbol(id: 7, name: "firework", groupId: 1),
    YarnSymbol(id: 8, name: "flower1", groupId: 1),
    YarnSymbol(id: 9, name: "flower2", groupId: 1),
    YarnSymbol(id: 10, name: "frasco", groupId: 1),
    YarnSymbol(id: 11, name: "island", groupId: 1),
    YarnSymbol(id: 12, name: "peach", groupId: 1),
    YarnSymbol(id: 13, name: "sheep", groupId: 1),
    YarnSymbol(id: 14, name: "sunrise", groupId: 1),
    YarnSymbol(id: 15, name: "thread", groupId: 1),
    YarnSymbol(id: 16, name: "tulip", groupId: 1),
    YarnSymbol(id: 17, name: "leaf", groupId: 2),
    YarnSymbol(id: 18, name: "camera.macro", groupId: 2),
    YarnSymbol(id: 19, name: "tree", groupId: 2),
    YarnSymbol(id: 20, name: "carrot", groupId: 2),
    YarnSymbol(id: 21, name: "fossil.shell", groupId: 2),
    YarnSymbol(id: 22, name: "pawprint", groupId: 2),
    YarnSymbol(id: 23, name: "fish", groupId: 2),
    YarnSymbol(id: 24, name: "ladybug", groupId: 2),
    YarnSymbol(id: 25, name: "bird", groupId: 2),
    YarnSymbol(id: 26, name: "cat", groupId: 2),
    YarnSymbol(id: 27, name: "dog", groupId: 2),
    YarnSymbol(id: 28, name: "hare", groupId: 2),
    YarnSymbol(id: 29, name: "mountain.2", groupId: 2),
    YarnSymbol(id: 30, name: "drop", groupId: 2),
    YarnSymbol(id: 31, name: "flame", groupId: 2),
    YarnSymbol(id: 32, name: "bolt", groupId: 2),
    YarnSymbol(id: 33, name: "sun.max.fill", groupId: 2),
    YarnSymbol(id: 34, name: "moon.fill", groupId: 2),
    YarnSymbol(id: 35, name: "sparkles", groupId: 2),
    YarnSymbol(id: 36, name: "moon.stars.fill", groupId: 2),
    YarnSymbol(id: 37, name: "cloud", groupId: 2),
    YarnSymbol(id: 38, name: "cloud.rain", groupId: 2),
    YarnSymbol(id: 39, name: "cloud.bolt", groupId: 2),
    YarnSymbol(id: 40, name: "cloud.sun.rain", groupId: 2),
    YarnSymbol(id: 41, name: "cloud.moon.rain", groupId: 2),
    YarnSymbol(id: 42, name: "wind", groupId: 2),
    YarnSymbol(id: 43, name: "snowflake", groupId: 2),
    YarnSymbol(id: 44, name: "tornado", groupId: 2),
    YarnSymbol(id: 45, name: "car.rear", groupId: 2),
    YarnSymbol(id: 46, name: "lightrail", groupId: 2),
    YarnSymbol(id: 47, name: "sailboat", groupId: 2),
    YarnSymbol(id: 48, name: "bicycle", groupId: 2),
    YarnSymbol(id: 49, name: "moped", groupId: 2),
    YarnSymbol(id: 50, name: "motorcycle", groupId: 2),
    YarnSymbol(id: 51, name: "scooter", groupId: 2),
    YarnSymbol(id: 52, name: "giftcard", groupId: 2),
    YarnSymbol(id: 53, name: "basket", groupId: 2),
    YarnSymbol(id: 54, name: "lightbulb", groupId: 2),
    YarnSymbol(id: 55, name: "lightbulb.max.fill", groupId: 2),
    YarnSymbol(id: 56, name: "fan.floor", groupId: 2),
    YarnSymbol(id: 57, name: "fan.ceiling", groupId: 2),
    YarnSymbol(id: 58, name: "lamp.desk", groupId: 2),
    YarnSymbol(id: 59, name: "chandelier", groupId: 2),
    YarnSymbol(id: 60, name: "party.popper", groupId: 2),
    YarnSymbol(id: 61, name: "balloon.2", groupId: 2),
    YarnSymbol(id: 62, name: "frying.pan", groupId: 2),
    YarnSymbol(id: 63, name: "popcorn", groupId: 2),
    YarnSymbol(id: 64, name: "sofa", groupId: 2),]

func getYarnSymbol(by id: Int) -> YarnSymbol {
    return yarnSymbols.first { $0.id == id } ?? defaultYarnSymbol
}

func createImageView(for symbol: YarnSymbol) -> Image {
    switch symbol.groupId {
    case 1:
        return Image(symbol.name)
//            .resizable()
//            .scaledToFit()

    case 2:
        return Image(systemName: symbol.name)
//            .resizable()
//            .scaledToFit()

    default:
        return Image(systemName: "xmark.circle")
//            .resizable()
//            .scaledToFit()

    }
}
/*
 .resizable()
 .scaledToFit()
 .frame(width: 28, height: 28)
 .foregroundColor(.blue)

 */
