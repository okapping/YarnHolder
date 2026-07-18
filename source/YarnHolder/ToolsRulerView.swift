//
//  ToolsRulerView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/09/30.
//

/*
 Rectangle()
 .fill(Color.blue)
 .frame(width:326 / 2 * 0.3937 ,height:326 / 2 * 0.3937)
上記にてiPhone Seにて1cmが作れた。
 〜解説〜
 326・・・iphoneSEのppi（pixcel per inch）
 / 2・・・多分表示の大きさが２倍率になっている。
 * 0.3937・・・1インチに0.3937をかけると1cmになる。
 */
import SwiftUI
import DevicePpi


enum MeasurementUnit: String, CaseIterable {
    case inch
    case centimeter
    case sun

    var value: String {
        switch self {
        case .inch:
            return "KEY_IN"
        case .centimeter:
            return "KEY_CM"
        case .sun:
            return "KEY_SUN"
        }
    }
}


struct ToolsRulerView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("appColorTheme") var appColorTheme = 10
    @AppStorage("selectedUnit") var selectedUnit: MeasurementUnit = .centimeter

    @State var screenSizeWidth = UIScreen.main.bounds.width
    @State var screenSizeHeight = UIScreen.main.bounds.height
    @State var screenScale = UIScreen.main.scale
    
    let ppi: Double = {
        switch Ppi.get() {
        case .success(let ppi):
            return ppi
        case .unknown(let bestGuessPpi, let error):
            // A bestGuessPpi value is provided but may be incorrect
            // Treat as a non-fatal error -- e.g. log to your backend and/or display a message
            return bestGuessPpi
        }
    }()
    
    let inchToCm: Double = 0.3937

    @State private var hiddenTabBar = false
    
    @State private var leftRulerSize: CGSize = CGSize()
    @State private var rightRulerSize: CGSize = CGSize()
//    @State private var backgroundSize: CGSize = CGSize()
    
    var body: some View {
        
        ZStack{
            ZStack(){
                CmRulerView(rulerWidth: screenSizeHeight, alignment: .trailing, markPosition: .top)
                    .rotationEffect(Angle(degrees: 270))
                    .offset(x: -(screenSizeWidth / 2) + (leftRulerSize.height / 2))
                    .background() {
                        GeometryReader { geometry in
                            Path { path in
                                let size = geometry.size
                                DispatchQueue.main.async {
                                    if self.leftRulerSize != size {
                                        self.leftRulerSize = size
                                    }
                                }
                            }
                        }
                    }
                //                Spacer()
                CmRulerView(rulerWidth: screenSizeHeight, alignment: .leading, markPosition: .top)
                    .rotationEffect(Angle(degrees: 90))
//                    .background(Color.blue.opacity(0.5))
                    .offset(x: (screenSizeWidth / 2) - (rightRulerSize.height / 2))
                    .background() {
                        GeometryReader { geometry in
                            Path { path in
                                let size = geometry.size
                                DispatchQueue.main.async {
                                    if self.rightRulerSize != size {
                                        self.rightRulerSize = size
                                    }
                                }
                            }
                        }
                    }
            }
            VStack{
//                Text("background size width : \(backgroundSize.width)")
//                Text("background size height : \(backgroundSize.height)")
//                Text("screenSizeWidth : \(screenSizeWidth)")
//                Text("screenSizeHeight : \(screenSizeHeight)")
//                Text("screen scale : \(screenScale)")
//                Text("device ppi : \(ppi)")
                // 1cmのマス
//                ZStack{
//                    Rectangle()
//                        .fill(Color.blue)
//                        .frame(width:ppi / screenScale * inchToCm ,height:ppi / screenScale * inchToCm)
//                    
//                    Text("1 cm")
//                }
                Spacer()
                Picker("KEY_SELECT_UNIT", selection: $selectedUnit.animation()) {
                    ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                        Text(LocalizedStringKey(unit.value)).tag(unit)
                    }
                }
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 70)
//                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .symbolRenderingMode(.hierarchical)
                        .contentTransition(.symbolEffect(.replace))
                }
                .buttonStyle(.plain)
                .padding(.bottom, 40)
            }
//            .background() {
//                GeometryReader { geometry in
//                    Path { path in
//                        let size = geometry.size
//                        DispatchQueue.main.async {
//                            if self.backgroundSize != size {
//                                self.backgroundSize = size
//                            }
//                        }
//                    }
//                }
//            }

        }
        .ignoresSafeArea(.all)
        .statusBarHidden(hiddenTabBar)// Bindingさせて、上の階層から消す
        .onAppear{
            withAnimation{
                hiddenTabBar = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            // 画面の向きの変更を検知した後、
            // なぜか遅らせないと、反映される前の値になってしまう。
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    screenSizeWidth = UIScreen.main.bounds.width
                    screenSizeHeight = UIScreen.main.bounds.height
                }
            }
        }
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbarBackground(.hidden, for: .navigationBar)
//        .navigationBarHidden(hiddenTabBar)
//        .toolbar(hiddenTabBar ? .hidden : .visible, for: .tabBar)
    }
}

struct CmRulerView: View {
    var rulerWidth: Double = 300
    var isReverse: Bool = false
    var alignment: HorizontalAlignment = .leading
    var markPosition: VerticalAlignment = .top
    
    func forEachCount() -> [Int] {
        var forEachCount: [Int] = []
        if alignment == .leading {
            forEachCount = Array(0...30)
        } else {
            forEachCount = (0...30).reversed()
        }
        return forEachCount
    }
//    var
    var body: some View {
        VStack(alignment: alignment, spacing: 0) {
//            Text("rulerWidth = \(rulerWidth)")
//            RoundedRectangle(cornerRadius: 30)
//                .frame(width: rulerWidth, height: 30)
            HStack(alignment: .bottom, spacing: 0){
                //                let loopCount = screenResolutionHeight  / (ppi * inchToCm)
                // 強制的に30cmまで繰り返すようにしている。
                // 今後の課題である。
                ForEach(Array(forEachCount().enumerated()), id: \.element) { i, num in
                    //                    ForEach(0..<Int(loopCount) + 1) { num in
                    VStack(alignment: alignment, spacing: 0) {
                        if markPosition == .bottom {
                            Text("\(num)")
                                .frame(width: 30, alignment: Alignment(horizontal: alignment, vertical: .center))
                        }
//                            .background(Color.red.opacity(0.5))
                        CmCellView(num: num, alignment: alignment, markPosition: markPosition, isLast: i == forEachCount().count - 1)
                        if markPosition == .top {
                            Text("\(num)")
                                .frame(width: 30, alignment: Alignment(horizontal: alignment, vertical: .center))
                        }

                    }
                    
                }
            }
//            .background(Color.yellow.opacity(0.5))
        }
        
        .frame(width:rulerWidth, alignment: Alignment(horizontal: alignment, vertical: .center))
        .clipped()
    }
}
struct CmCellView: View {
    @AppStorage("selectedUnit") var selectedUnit: MeasurementUnit = .centimeter
    
    let screenScale = UIScreen.main.scale
    
    let ppi: Double = {
        switch Ppi.get() {
        case .success(let ppi):
            return ppi
        case .unknown(let bestGuessPpi, let error):
            // A bestGuessPpi value is provided but may be incorrect
            // Treat as a non-fatal error -- e.g. log to your backend and/or display a message
            return bestGuessPpi
        }
    }()
    
    let inchToCm: Double = 0.3937
    let inchToSun: Double = 1.194

    var num: Int
    var alignment: HorizontalAlignment = .leading
    var markPosition: VerticalAlignment = .top
    
    var isLast: Bool = false
    
    
    func paddingSize() -> Double {
        // メモリごとのpadding値の調整
        // 1インチのサイズから各サイズへ変換する
        switch selectedUnit {
        case .inch:
            return ((ppi / screenScale) / markerDivision() - 2)
        case .centimeter:
            return ((ppi / screenScale * inchToCm) / markerDivision() - 2)
        case .sun:
            return ((ppi / screenScale * inchToSun) / markerDivision() - 2)
        }
    }
    func markerDivision() -> Double {
        // 1サイズあたりの内側の線の数
        switch selectedUnit {
        case .inch:
            return 16
        case .centimeter:
            return 10
        case .sun:
            return 10
        }
    }
    func markLength(at position: Int) -> Double {
        // メモリの長さを設定する
        switch selectedUnit {
        case .inch:
            switch position {
            case 0:
                return 30
            case 8:
                return 27.5
            case 4, 12:
                return 25
            case 2, 6, 10, 14:
                return 20
            default:
                return 15
            }
        case .centimeter:
            switch position {
            case 0:
                return 30
            case 5:
                return 25
            default:
                return 15
            }
        case .sun:
            switch position {
            case 0:
                return 30
            default:
                return 20
            }
        }
    }
    var body: some View {
        HStack(alignment: markPosition, spacing: 0){
            ForEach(Array(Array(0..<Int(markerDivision())).enumerated()), id: \.element){ index, i in
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 2, height: markLength(at: index))
                    .padding(.trailing, paddingSize())
            }
            if isLast {
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 2, height: 30)
            }
        }
        .geometryGroup()
        .animation(.default, value: selectedUnit)
//        .background(Color.green.opacity(0.5))
    }
}

#Preview {
    ToolsRulerView()
//    CmRulerView(rulerWidth: 300, alignment: .trailing, markPosition: .center)
//    CmRulerView(rulerWidth: 300, alignment: .trailing, markPosition: .bottom)
}
