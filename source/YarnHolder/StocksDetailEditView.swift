//
//  StocksDetailEditView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/08/31.
//

import SwiftUI
import SwiftData

struct StocksDetailEditView: View {
    @Query var stockStatuses: [YarnStockStatus]
    
    //    @State var detail: InputYarnStockDetail = .init
    @State var detail: YarnStockDetail
    
    @State var tmpWeight: Double = 0
    @State var tmpLength: Double = 0
    @State var tmpUsageRatio: Double = 1
    
    //    @State var sliderChanging: Bool = false
    @FocusState var focus: Bool
    @FocusState var focusForWeight: Bool
    @FocusState var focusForLength: Bool
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal       // 桁区切りや小数点をローカル形式で表示
        formatter.maximumFractionDigits = 1    // 小数点以下を表示しない
        formatter.minimum = 0
        formatter.maximum = 1000
        return formatter
    }
    var body: some View {
        List{
            Section {
                Picker("KEY_STATUS", selection: $detail.status.animation()) {
                    ForEach(stockStatuses.sorted(by: { $0.orderIndex < $1.orderIndex })) {stockStatus in
                        Text(stockStatus.name).tag(stockStatus)
                    }
                }
            }
            Section{
                HStack {
                    VStack {
                        Text("KEY_WEIGHT")
                            .font(.system(.body, design: .rounded))
                        TextField("00", value: $tmpWeight, formatter: numberFormatter)
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.bold)
                            .multilineTextAlignment(TextAlignment.center)
                            .padding(6)
                            .keyboardType(.decimalPad)
                            .focused(self.$focusForWeight)
                            .onChange(of: tmpWeight) {
                                if focusForWeight || focusForLength {
                                    detail.weight = tmpWeight
                                }
                                if detail.isLink {
                                    let tmpW = detail.yarnStock?.yarnInfo?.weight ?? 100
                                    tmpUsageRatio = tmpWeight / tmpW
                                }
                            }
                    }
                    Spacer()
                    ZStack {
                        Rectangle()
                            .fill(detail.isLink ? .blue : .clear)
                            .frame(width: 40, height: 40)
                            .cornerRadius(10)
                        Image(systemName: "link")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(detail.isLink ? .white : .secondary)
                            .padding()
                    }
                    .onTapGesture {
                        withAnimation{
                            detail.isLink.toggle()
                        }
                    }
                    .sensoryFeedback(.success, trigger: detail.isLink)
                    Spacer()
                    VStack {
                        Text("KEY_LENGTH")
                            .font(.system(.body, design: .rounded))
                        //                    .fontWeight(.bold)
                        TextField("00", value: $tmpLength, formatter: numberFormatter)
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.bold)
                            .multilineTextAlignment(TextAlignment.center)
                        //                    .frame(width : 60.0)
                            .padding(6)
                        //                    .background(Color(UIColor.tertiarySystemFill))
                        //                    .cornerRadius(5)
                            .keyboardType(.decimalPad)
                        //                    .multilineTextAlignment(.trailing)
                            .focused(self.$focusForLength)
                            .onChange(of: tmpLength) {
                                if focusForWeight || focusForLength {
                                    detail.length = tmpLength
                                }
                                if detail.isLink {
                                    //                                    let tmpL = detail.info.length ?? 100
                                    let tmpL = detail.yarnStock?.yarnInfo?.length ?? 100
                                    tmpUsageRatio = tmpLength / tmpL
                                }
                            }
                    }
                    
                }
                if detail.isLink{
                    Slider(value: $tmpUsageRatio, in: 0...1, onEditingChanged: { change in
                        if change {
                            print("移動開始")
                        }else {
                            print("移動終了")
                            // 移動が終了したタイミングで、tmpから実際のmodelに反映する
                            detail.weight = tmpWeight
                            detail.length = tmpLength
                            detail.usageRatio = tmpUsageRatio
                        }
                    })
                    .onChange(of: tmpUsageRatio) {
                        if focusForWeight || focusForLength {
                            detail.usageRatio = tmpUsageRatio
                        }
                        // スライダーの値に基づいて二つの値を更新
                        //                            let tmpW = detail.info.weight ?? 100
                        let tmpW = detail.yarnStock?.yarnInfo?.weight ?? 100
                        tmpWeight = tmpW * tmpUsageRatio
                        //                            let tmpL = detail.info.length ?? 100
                        let tmpL = detail.yarnStock?.yarnInfo?.length ?? 100
                        tmpLength = tmpL * tmpUsageRatio
                    }
                    .padding()
                } else {
                    VStack {
                        HStack {
                            //                            let tmpW = detail.info.weight ?? 100
                            let tmpW = detail.yarnStock?.yarnInfo?.weight ?? 100
                            Image(systemName: "scalemass.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Slider(value: $tmpWeight, in: 0...tmpW, onEditingChanged: { change in
                                if change {
                                    print("移動開始")
                                }else {
                                    print("移動終了")
                                    // 移動が終了したタイミングで、tmpから実際のmodelに反映する
                                    detail.weight = tmpWeight
                                    detail.length = tmpLength
                                    detail.usageRatio = tmpUsageRatio
                                }
                            })
                        }
                        HStack {
                            //                            let tmpL = detail.info.length ?? 100
                            let tmpL = detail.yarnStock?.yarnInfo?.length ?? 100
                            Image(systemName: "glowplug")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Slider(value: $tmpLength, in: 0...tmpL, onEditingChanged: { change in
                                if change {
                                    print("移動開始")
                                }else {
                                    print("移動終了")
                                    // 移動が終了したタイミングで、tmpから実際のmodelに反映する
                                    detail.weight = tmpWeight
                                    detail.length = tmpLength
                                    detail.usageRatio = tmpUsageRatio
                                }
                            })
                        }
                    }
                    .padding()
                }
                
            }
            // 線を端まで表示する
            .alignmentGuide(.listRowSeparatorLeading, computeValue: { _ in
                0
            })
            Section{
                TextField("KEY_MEMO",
                          text: $detail.memo,
                          axis: .vertical
                )
                .focused(self.$focus)
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard){
                HStack{
                    Spacer()
                    Button{
                        focus = false
                        focusForWeight = false
                        focusForLength = false
                    }label: {
                        Text("KEY_DONE")
                    }
                }
            }
        }
        .onAppear{
            tmpWeight = detail.weight
            tmpLength = detail.length
            tmpUsageRatio = detail.usageRatio
        }
    }
}
