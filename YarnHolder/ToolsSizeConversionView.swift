//
//  ToolsSizeConversionView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/10/06.
//


import SwiftUI

enum ConversionContent: String, CaseIterable {
    case length
    case weight
    
    var value: String {
        switch self {
        case .length:
            return "KEY_LENGTH"
        case .weight:
            return "KEY_WEIGHT"
        }
    }
}

enum LengthUnit: String, CaseIterable {
    case mm
    case cm
    case m
//    case km
    case inch
    case foot
    case yard
//    case mile

    var title: String {
        switch self {
        case .mm:
            return "KEY_MM"
        case .cm:
            return "KEY_CM"
        case .m:
            return "KEY_M"
//        case .km:
//            return "キロメートル"
        case .inch:
            return "KEY_IN"
        case .foot:
            return "KEY_FE"
        case .yard:
            return "KEY_YD"
//        case .mile:
//            return "マイル"
        }
    }
    var unit: String {
        switch self {
        case .mm:
            return "mm"
        case .cm:
            return "cm"
        case .m:
            return "m"
        case .inch:
            return "in"
        case .foot:
            return "ft"
        case .yard:
            return "yd"
        }
    }

    func convertValue(refMeter: Double) -> Double {
        switch self {
        case .mm:
            return refMeter / 0.001 //* 1000// 0.001 //
        case .cm:
            return refMeter / 0.01 // * 100// 0.01 //
        case .m:
            return refMeter / 1 // * 1// 1 //
//        case .km:
//            return value / 1000 // * 0.001// 1000 //
        case .inch:
            return refMeter / 0.0254 // * 39.3701// 0.0254 //
        case .foot:
            return refMeter / 0.3048 // * 3.28084// 0.3048 //
        case .yard:
            return refMeter / 0.9144 // * 1.09361// 0.9144 //
//        case .mile:
//            return value  / 1609.34 //* 0.000621371// 1609.34 //
        }
    }
}

enum WeightUnit: String, CaseIterable {
    case gram
    case kilogram
    case ounces
    case pound

    var title: String {
        switch self {
        case .gram:
            return "KEY_GM"
        case .kilogram:
            return "KEY_KG"
        case .ounces:
            return "KEY_OZ_2"
        case .pound:
            return "KEY_PD"
        }
    }
    var unit: String {
        switch self {
        case .gram:
            return "g"
        case .kilogram:
            return "kg"
        case .ounces:
            return "oz"
        case .pound:
            return "lb"
        }
    }
    func convertValue(refOunce: Double) -> Double {
        switch self {
        case .gram:
            return refOunce / 0.03527396
        case .kilogram:
            return refOunce / 35.27396
        case .ounces:
            return refOunce / 1
        case .pound:
            return refOunce / 16

        }
    }
}

struct ToolsSizeConversionView: View {
    @AppStorage("selectedConversionContent") var selectedConversionContent: ConversionContent = .length

    @State private var inputNumber: String = ""
    @State private var selectedLengthUnit: LengthUnit = .cm
    @State private var selectedWeightUnit: WeightUnit = .gram

    @State private var referenceMeterValue: Double = 0
    @State private var referenceOunceValue: Double = 0

    //  フォーカス
    @FocusState var focus: Bool

    func formatDouble(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0  // 小数点以下の桁数の下限を0に
        formatter.maximumFractionDigits = 2  // 小数点以下の桁数の上限を6に
        
        if let formattedString = formatter.string(from: NSNumber(value: value)) {
            return formattedString
        }
        
        return "\(value)"  // フォーマッターが失敗した場合は元の値を返す
    }

    var body: some View {
        List{
            Section{
                Picker("Category", selection: $selectedConversionContent.animation()) {
                    ForEach(ConversionContent.allCases, id: \.self) { unit in
                        Text(LocalizedStringKey(unit.value)).tag(unit)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)

            }

            Section(
                header: ListTitleView(title: "KEY_CONVERSION_FROM")
            ){
                switch selectedConversionContent{
                case .length:
                    Picker("KEY_UNIT", selection: $selectedLengthUnit) {
                        ForEach(LengthUnit.allCases, id: \.self) { unit in
                            Text(LocalizedStringKey(unit.title)).tag(unit)
                        }
                    }
                case .weight:
                    Picker("KEY_UNIT", selection: $selectedWeightUnit) {
                        ForEach(WeightUnit.allCases, id: \.self) { unit in
                            Text(LocalizedStringKey(unit.title)).tag(unit)
                        }
                    }
                }
//                .pickerStyle(SegmentedPickerStyle())
                HStack{
                    TextField(LocalizedStringKey("000"), text: $inputNumber.animation())
                        .keyboardType(.decimalPad)
                        .focused(self.$focus)
                    switch selectedConversionContent{
                    case .length:
                        Text(selectedLengthUnit.unit)
                    case .weight:
                        Text(selectedWeightUnit.unit)
                    }
                }
            }
            Section(
                header: ListTitleView(title: "KEY_CONVERSION_TO")
            ){
                switch selectedConversionContent{
                case .length:
                    ForEach(LengthUnit.allCases, id: \.self) { unit in
                        HStack{
                            Text(LocalizedStringKey(unit.title))
                            Spacer()
                            Text("\(formatDouble(unit.convertValue(refMeter: referenceMeterValue)))")
                                .contentTransition(.numericText(value: unit.convertValue(refMeter: referenceMeterValue)))
                            //                        Text("\(String(format: "%.6f", unit.convertValue(value: referenceMeterValue)))")
                            Text(unit.unit)
                        }.tag(unit)
                    }
                case .weight:
                    ForEach(WeightUnit.allCases, id: \.self) { unit in
                        HStack{
                            Text(LocalizedStringKey(unit.title))
                            Spacer()
                            Text("\(formatDouble(unit.convertValue(refOunce: referenceOunceValue)))")
                                .contentTransition(.numericText(value: unit.convertValue(refOunce: referenceOunceValue)))
                            //                        Text("\(String(format: "%.6f", unit.convertValue(value: referenceMeterValue)))")
                            Text(unit.unit)
                        }.tag(unit)
                    }
                }
            }
            
        }
        .navigationTitle("KEY_SIZE_CONVERSION")
//        .safeAreaInset(edge: .top) {
//            Picker("", selection: $selectedConversionContent.animation()) {
//                ForEach(ConversionContent.allCases, id: \.self) { unit in
//                    Text(LocalizedStringKey(unit.value)).tag(unit)
//                }
//            }
//            .padding(.horizontal)
//            .padding(.bottom)
//            .pickerStyle(.segmented)
//            .background(.bar) // Thanks @BenzyKneez
//        }
//        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar{
            ToolbarItem(placement: .keyboard){
                HStack{
                    Spacer()
                    Button{
                        focus = false
                    }label: {
                        Text("KEY_DONE")
                    }
                }
            }

        }
        .onChange(of: inputNumber){
            withAnimation{
//                switch selectedConversionContent{
//                case .length:
//                    convertToMm()
//                case .weight:
//                    convertToOunce()
//                }
                convertToMm()
                convertToOunce()
            }
        }
        .onChange(of: selectedLengthUnit){
            withAnimation{
                convertToMm()
            }
        }
        .onChange(of: selectedWeightUnit){
            withAnimation{
                convertToOunce()
            }
        }
//        .padding()
    }
    
    func convertToMm(){
        guard let num = Double(inputNumber) else {
            // 入力が無効な場合の処理
            return referenceMeterValue = 0
        }
        switch selectedLengthUnit {
        case .mm:
            return referenceMeterValue = num * 0.001
        case .cm:
            return referenceMeterValue = num * 0.01
        case .m:
            return referenceMeterValue = num * 1
            //        case .km:
            //            return referenceMeterValue = num * 1000
        case .inch:
            return referenceMeterValue = num * 0.0254
        case .foot:
            return referenceMeterValue = num * 0.3048
        case .yard:
            return referenceMeterValue = num * 0.9144
            //        case .mile:
            //            return referenceMeterValue = num * 1609.34
        }
    }
    func convertToOunce(){
        guard let num = Double(inputNumber) else {
            // 入力が無効な場合の処理
            return referenceOunceValue = 0
        }
        switch selectedWeightUnit {
        case .gram:
            return referenceOunceValue = num * 0.03527396
        case .kilogram:
            return referenceOunceValue = num * 35.27396
        case .ounces:
            return referenceOunceValue = num * 1
        case .pound:
            return referenceOunceValue = num * 16
        }
    }
}

#Preview {
    ToolsSizeConversionView()
}
