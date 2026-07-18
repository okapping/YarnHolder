////
////  TestView.swift
////  YarnStocker
////
////  Created by 岡山直也 on 2025/07/30.
////
//import Foundation
//import SwiftUI
//import SwiftData
//import Flow
//
//
//struct ColorCheckView: View {
//    var body: some View {
//        List {
//            Section {
//                cell(text: "primary", color: .primary)
//                cell(text: "secondary", color: .secondary)
//                cell(text: "accentColor", color: .accentColor)
//            }
//            Section {
//                cell(text: "systemRed", color: Color(UIColor.systemRed))
//                cell(text: "systemGreen", color: Color(UIColor.systemGreen))
//                cell(text: "systemBlue", color: Color(UIColor.systemBlue))
//            }
//            Section {
//                cell(text: "systemCyan", color: Color(UIColor.systemCyan))
//                cell(text: "systemMint", color: Color(UIColor.systemMint))
//                cell(text: "systemPink", color: Color(UIColor.systemPink))
//                cell(text: "systemTeal", color: Color(UIColor.systemTeal))
//                cell(text: "systemBrown", color: Color(UIColor.systemBrown))
//                cell(text: "systemIndigo", color: Color(UIColor.systemIndigo))
//                cell(text: "systemOrange", color: Color(UIColor.systemOrange))
//                cell(text: "systemPurple", color: Color(UIColor.systemPurple))
//                cell(text: "systemYellow", color: Color(UIColor.systemYellow))
//            }
//            Section {
//                cell(text: "systemGray", color: Color(UIColor.systemGray))
//                cell(text: "systemGray2", color: Color(UIColor.systemGray2))
//                cell(text: "systemGray3", color: Color(UIColor.systemGray3))
//                cell(text: "systemGray4", color: Color(UIColor.systemGray4))
//                cell(text: "systemGray5", color: Color(UIColor.systemGray5))
//                cell(text: "systemGray6", color: Color(UIColor.systemGray6))
//            }
//            Section {
//                cell(text: "systemFill", color: Color(UIColor.systemFill))
//                cell(text: "secondarySystemFill", color: Color(UIColor.secondarySystemFill))
//                cell(text: "tertiarySystemFill", color: Color(UIColor.tertiarySystemFill))
//                cell(text: "quaternarySystemFill", color: Color(UIColor.quaternarySystemFill))
//            }
//            Section {
//                cell(text: "systemBackground", color: Color(UIColor.systemBackground))
//                cell(text: "secondarySystemBackground", color: Color(UIColor.secondarySystemBackground))
//                cell(text: "tertiarySystemBackground", color: Color(UIColor.tertiarySystemBackground))
//            }
//            Section {
//                cell(text: "systemGroupedBackground", color: Color(UIColor.systemGroupedBackground))
//                cell(text: "secondarySystemGroupedBackground", color: Color(UIColor.secondarySystemGroupedBackground))
//                cell(text: "tertiarySystemGroupedBackground", color: Color(UIColor.tertiarySystemGroupedBackground))
//            }
//            Section{
//                ForEach(selectColors, id: \.self){ colorName in
//                    cell(text: colorName, color: Color(colorName))
//                }
//            }
//        }
//    }
//    
//    func cell(text: String, color: Color) -> some View {
//        return VStack {
//            HStack {
//                Text(text)
//                    .frame(width:200, height: 35)
//                Rectangle()
//                    .foregroundColor(color)
//                    .frame(width: 150, height: 35)
//            }
//        }
//    }
//}
//
//struct ItemNameSampleView: View {
//    //    @Environment(\.modelContext) private var modelContext
//    //    @Query private var items: [Item]
//    var name: String
//    var body: some View {
//        Text(name)
//    }
//}
//
//struct ItemSampleView: View {
//    //    @Environment(\.modelContext) private var modelContext
//    //    @Query private var items: [Item]
//    var item: Item
//    var body: some View {
//        NavigationStack {
//            List{
//                NavigationLink{
//                    Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                        .toolbar {
//                            ToolbarItem(placement: .navigationBarLeading) {
//                                Button{
//                                    
//                                } label:{
//                                    Label("戻せる", systemImage:"arrow.left")
//                                }
//                            }
//                        }
//                        .tint(.secondary)
//                } label:{
//                    Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                }
//            }
//            
//            .navigationTitle(item.name)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button{
//                        
//                    } label:{
//                        Label("戻す", systemImage:"arrow.left")
//                    }
//                }
//            }
//        }
//        .tint(.green)
//    }
//}
//struct NavigationSplitViewSample: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
//    
//    var body: some View {
//        NavigationSplitView {
//            List (items){ item in
////                ForEach(items) { item in
//                    NavigationLink {
////                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                        ItemSampleView(item: item)
//                    } label: {
//                        HStack {
//                            Text(item.name)
//                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                        }
//                        
//                    }
////                }
////                .onDelete(perform: deleteItems)
//            }
//            
//            .toolbar {
//#if os(iOS)
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//#endif
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
//        .tint(.red)
//    }
//    
//    private func addItem() {
//        withAnimation {
//            let newName = "テスト \(1 + items.count)"
//            let newItem = Item(name: newName, timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//    
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
//}
////@Model
////final class Item {
////    var name: String
////    var timestamp: Date
////    
////    init(name: String, timestamp: Date) {
////        self.name = name
////        self.timestamp = timestamp
////    }
////}
//
//struct ZoomTransition: View {
//    var columns: [GridItem] = [
//        GridItem(.flexible(), spacing: 10),
//        GridItem(.flexible())
//    ]
//    var imageObj: [ImageModel] = [
//        ImageModel(image: "test.swatch"),
//        ImageModel(image: "test.swatch"),
//        ImageModel(image: "test.swatch"),
//        ImageModel(image: "test.swatch"),
//        ImageModel(image: "test.swatch"),
//        ImageModel(image: "test.swatch")
//    ]
//    @Namespace private var namespace
//    @State var selectedCover: ImageModel?
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                GeometryReader { reader in
//                    LazyVGrid(columns: columns, spacing: 10) {
//                        ForEach(imageObj, id: \.self) { image in
//                            AlbumImageView(obj: image, width: reader.size.width)
//                                .onTapGesture {
//                                    selectedCover = image
//                                }
//                                .matchedTransitionSource(id: image.id, in: namespace)
//                        }
//                    }
//                }
//                Spacer()
//            }
//            .sheet(item: $selectedCover) { image in
//                FullAlbumCover(obj: image)
//                    .navigationTransition(.zoom(sourceID: image.id, in: namespace))
//            }
//            .navigationTitle("Travis Scott")
//            .tint(.white)
//            .padding(10)
//        }
//        .accentColor(.white)
//    }
//}
//struct ImageModel: Hashable, Identifiable {
//    var id = UUID()
//    var image: String
//}
//struct AlbumImageView: View {
//    var obj: ImageModel
//    var width: CGFloat
//    var body: some View {
//        Image(obj.image)
//            .resizable()
//            .scaledToFill()
//            .frame(width: (width / 2) - 10, height: (width / 2) - 10)
//            .clipShape(RoundedRectangle(cornerRadius: 12))
//    }
//}
//struct FullAlbumCover: View {
//    var obj: ImageModel
//    var body: some View {
//        Image(obj.image)
//            .resizable()
//            .scaledToFill()
//            .ignoresSafeArea()
//    }
//}
////#Preview{
////    ZoomTransition()
////}
//struct TwinSliderView: View {
//    @State private var value1: Double = 60.0
//    @State private var value2: Double = 100.0
//    @State private var sliderValue: Double = 1.0
//    
//    var body: some View {
//        VStack {
//            // スライダー
//            Slider(value: $sliderValue, in: 0...1)
//                .onChange(of: sliderValue) {
//                    // スライダーの値に基づいて二つの値を更新
//                    value1 = 60 * sliderValue
//                    value2 = 100 * sliderValue
//                }
//                .padding()
//            
//            // 値の表示と編集用テキストフィールド
//            HStack {
//                TextField("Value 1", value: $value1, formatter: NumberFormatter())
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .keyboardType(.decimalPad)
//                    .onChange(of: value1) {
//                        // スライダーの値を更新
//                        sliderValue = value1 / 60
//                    }
//                
//                TextField("Value 2", value: $value2, formatter: NumberFormatter())
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .keyboardType(.decimalPad)
//                    .onChange(of: value2) {
//                        // スライダーの値を更新
//                        sliderValue = value2 / 100
//                    }
//            }
//            .padding()
//            
//            // 値の表示
//            Text("Value 1: \(value1, specifier: "%.2f")")
//            Text("Value 2: \(value2, specifier: "%.2f")")
//        }
//        .padding()
//    }
//}
////#Preview{
////    TwinSliderView()
////}
//
//
//struct FeedbackListView: View {
//    @State private var start = false
//    @State private var stop = false
//    @State private var alignment = false
//    @State private var decrease = false
//    @State private var increase = false
//    @State private var levelChange = false
//    @State private var selection = false
//    @State private var success = false
//    @State private var warning = false
//    @State private var error = false
//    @State private var impact = false
//    @State private var impactWeightLight = false
//    @State private var impactWeightMedium = false
//    @State private var impactWeightHeavy = false
//    @State private var impactFlexibilityRigid = false
//    @State private var impactFlexibilitySoft = false
//    @State private var impactFlexibilitySolid = false
//    var body: some View {
//        List {
//            Section {
//                Button {
//                    start.toggle()
//                } label: {
//                    Text("start")
//                }
//                
//                Button {
//                    stop.toggle()
//                } label: {
//                    Text("stop")
//                }
//            } header: {
//                Text("Indicating start and stop")
//            }
//            
//            Section {
//                Button {
//                    alignment.toggle()
//                } label: {
//                    Text("alignment")
//                }
//                
//                Button {
//                    decrease.toggle()
//                } label: {
//                    Text("decrease")
//                }
//                
//                Button {
//                    increase.toggle()
//                } label: {
//                    Text("increase")
//                }
//                
//                Button {
//                    levelChange.toggle()
//                } label: {
//                    Text("levelChange")
//                }
//                
//                Button {
//                    selection.toggle()
//                } label: {
//                    Text("selection")
//                }
//            } header: {
//                Text("Indicating changes and selections")
//            }
//            
//            Section {
//                Button {
//                    success.toggle()
//                } label: {
//                    Text("success")
//                }
//                
//                Button {
//                    warning.toggle()
//                } label: {
//                    Text("warning")
//                }
//                
//                Button {
//                    error.toggle()
//                } label: {
//                    Text("error")
//                }
//            } header: {
//                Text("Indicating the outcome of an operation")
//            }
//            
//            Section {
//                Button {
//                    impact.toggle()
//                } label: {
//                    Text("impact")
//                }
//                
//                Button {
//                    impactWeightLight.toggle()
//                } label: {
//                    Text("impact(light)")
//                }
//                
//                Button {
//                    impactWeightMedium.toggle()
//                } label: {
//                    Text("impact(medium)")
//                }
//                
//                Button {
//                    impactWeightHeavy.toggle()
//                } label: {
//                    Text("impact(heavy)")
//                }
//                
//                Button {
//                    impactFlexibilityRigid.toggle()
//                } label: {
//                    Text("impact(rigid)")
//                }
//                
//                Button {
//                    impactFlexibilitySoft.toggle()
//                } label: {
//                    Text("impact(soft)")
//                }
//                
//                Button {
//                    impactFlexibilitySolid.toggle()
//                } label: {
//                    Text("impact(solid)")
//                }
//            } header: {
//                Text("Producing a physical impactin")
//            }
//        }
//        .sensoryFeedback(.start, trigger: start)
//        .sensoryFeedback(.stop, trigger: stop)
//        .sensoryFeedback(.alignment, trigger: alignment)
//        .sensoryFeedback(.decrease, trigger: decrease)
//        .sensoryFeedback(.increase, trigger: increase)
//        .sensoryFeedback(.levelChange, trigger: levelChange)
//        .sensoryFeedback(.selection, trigger: selection)
//        .sensoryFeedback(.success, trigger: success)
//        .sensoryFeedback(.warning, trigger: warning)
//        .sensoryFeedback(.error, trigger: error)
//        .sensoryFeedback(.impact, trigger: impact)
//        .sensoryFeedback(.impact(weight: .light), trigger: impactWeightLight)
//        .sensoryFeedback(.impact(weight: .medium), trigger: impactWeightMedium)
//        .sensoryFeedback(.impact(weight: .heavy), trigger: impactWeightHeavy)
//        .sensoryFeedback(.impact(flexibility: .rigid), trigger: impactFlexibilityRigid)
//        .sensoryFeedback(.impact(flexibility: .soft), trigger: impactFlexibilitySoft)
//        .sensoryFeedback(.impact(flexibility: .solid), trigger: impactFlexibilitySolid)
//    }
//}
////#Preview{
////    FeedbackListView()
////}
//
//struct NSPView: View {
//    // https://www.createwithswift.com/exploring-the-navigationsplitview/
//    @State private var visibility: NavigationSplitViewVisibility = .all
//    
//    @Query var folders: [Folder]
//    @Query var allYarns: [YarnInfo]
//    @State var selectedYarn: YarnInfo? = nil
////    var allYarns:
//    var body: some View {
//        NavigationSplitView(columnVisibility: $visibility) {
//            List {
//                NavigationLink("Category 1", destination: CategoryView(category: "Category 1"))
//                NavigationLink("Category 2", destination: CategoryView(category: "Category 2"))
//                NavigationLink{
//                    TestYarnsListView(yarns: allYarns)
//                } label: {
//                    Text("すべての毛糸")
//                }
//                ForEach(folders) { folder in
//                    NavigationLink{
//                        TestYarnsListView(yarns: folder.yarns)
//                    } label: {
//                        Text(folder.name)
//                    }
//                }
//            }
//            .navigationTitle("Sidebar")
//        } content: {
//            ContentUnavailableView("Select an element from the sidebar", systemImage: "doc.text.image.fill")
//        } detail: {
//            NavigationStack{
//                ContentUnavailableView("Select an element from the list", systemImage: "doc.text.image.fill")
//            }
//            
//        }
//    }
//}
//
//struct TestYarnsListView: View {
//    var yarns: [YarnInfo]
//    var body: some View {
//        List {
//            ForEach(yarns){ yarn in
//                NavigationLink{
//                    TestYarnDetailView(yarn: yarn)
//                } label: {
//                    Text(yarn.name)
//                }
//            }
//        }.navigationTitle("Yarn List")
//    }
//}
//struct TestYarnDetailView: View {
//    var yarn: YarnInfo
//    var body: some View {
//        NavigationStack{
//            List{
//                NavigationLink{
//                    List{
//                        Text("detail detail View")
//                    }
//                    .navigationTitle("detail detail View")
//                } label:{
//                    Text("detail detail View")
//                }
//                Text(yarn.name)
//            }
//            
//                .navigationTitle(yarn.name)
//        }
//    }
//}
//struct CategoryView: View {
//    let category: String
//    
//    var body: some View {
//        List {
//            NavigationLink("\(category) Item 1", destination: DetailView(item: "\(category) Item 1"))
//            NavigationLink("\(category) Item 2", destination: DetailView(item: "\(category) Item 2"))
//        }
//        .navigationTitle("Content")
//    }
//}
//
//struct DetailView: View {
//    let item: String
//    
//    var body: some View {
//        NavigationStack{
//            Text("Details for \(item)")
//                .navigationTitle("Detail")
//        }
//    }
//    
//}
////#Preview{
////    NSPView()
////        // .modelContainer(previewYarn)
////}
//
//struct ConvertView: View {
//    @State private var centimeterInput: String = ""
//    @State private var convertedValues: [String: Double] = [:]
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            TextField("センチメートルの値を入力", text: $centimeterInput)
//                .keyboardType(.decimalPad)
//                .padding()
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//            
//            Button(action: {
//                convertValues()
//            }) {
//                Text("変換する")
//                    .font(.headline)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
//            
//            List {
//                ForEach(convertedValues.sorted(by: { $0.key < $1.key }), id: \.key) { unit, value in
//                    Text("\(unit): \(value, specifier: "%.2f")")
//                }
//            }
//        }
//        .padding()
//    }
//    
//    func convertValues() {
//        guard let centimeters = Double(centimeterInput) else {
//            // 入力が無効な場合の処理
//            return
//        }
//        
//        convertedValues["mm"] = centimeters * 10
//        convertedValues["cm"] = centimeters
//        convertedValues["km"] = centimeters / 100000
//        convertedValues["inch"] = centimeters / 2.54
//        convertedValues["foot"] = centimeters / 30.48
//        convertedValues["yard"] = centimeters / 91.44
//        convertedValues["mile"] = centimeters / 160934.4
//    }
//}
////#Preview{
////    ConvertView()
////    //        // .modelContainer(previewYarn)
////}
//
//
//struct MeshGradientView: View {
////    private let gradientColors: [Color] = [
////        // ビビットカラーを赤から順に設定
////        Color(hue: 360/360, saturation: 1, brightness: 1),
////        Color(hue: 30/360, saturation: 1, brightness: 1),
////        Color(hue: 60/360, saturation: 1, brightness: 1),
////        Color(hue: 90/360, saturation: 1, brightness: 1),
////        Color(hue: 120/360, saturation: 1, brightness: 1),
////        Color(hue: 150/360, saturation: 1, brightness: 1),
////        Color(hue: 180/360, saturation: 1, brightness: 1),
////        Color(hue: 210/360, saturation: 1, brightness: 1),
////        Color(hue: 240/360, saturation: 1, brightness: 1),
////        Color(hue: 270/360, saturation: 1, brightness: 1),
////        Color(hue: 300/360, saturation: 1, brightness: 1),
////        Color(hue: 330/360, saturation: 1, brightness: 1),
////        Color(hue: 360/360, saturation: 1, brightness: 1),
////    ]
//    
//    private let gradientColors: [Color] = (0...12).map { i in
//        Color(hue: Double(i) * 30 / 360, saturation: 1, brightness: 1)
//    }
//
//    func gradientPoints() -> [SIMD2<Float>] {
//        var points: [SIMD2<Float>] = []
//        for index in 0..<gradientColors.count {
//            // SIMD2<Float>に変換
//            points.append(SIMD2<Float>(0, Float((1/CGFloat(gradientColors.count - 1)) * CGFloat(index))))
//            points.append(SIMD2<Float>(0.5, Float((1/CGFloat(gradientColors.count - 1)) * CGFloat(index))))
//            points.append(SIMD2<Float>(1.0, Float((1/CGFloat(gradientColors.count - 1)) * CGFloat(index))))
//        }
//        return points
//    }
//    func sortedGradientColors() -> [Color] {
//        var colors: [Color] = []
//        for color in gradientColors {
//            colors.append(.white)
//            colors.append(color)
//            colors.append(.black)
//        }
//        return colors
//    }
//
//    
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 10)
//                .fill(
//                    MeshGradient(
//                        width: 3,
//                        height: gradientColors.count,
//                        points:gradientPoints(),
//                        colors:sortedGradientColors()
//                    )
//                )
////                .frame(maxWidth: .infinity)
//                .frame(width:300, height: 250)
//                .padding()
//            VStack{
//                ForEach(gradientColors, id: \.self){ color in
//                    Text("\(color.hsb.h)")
//                }
//            }.hidden()
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(uiColor: .systemGroupedBackground))
//    }
//}
//
////#Preview{
////    MeshGradientView()
////}
//
//
//struct RulerTestView: View {
////    @State var screenSizeHeight: CGFloat = 0
//    @State var alignment: HorizontalAlignment = .leading
//    @State var markPosition: VerticalAlignment = .top
//
//    var body: some View {
//        ZStack{
//            CmRulerView(rulerWidth: 300, alignment: alignment, markPosition: markPosition)
//                .foregroundStyle(.primary)
//                .background(.secondary.opacity(0.2))
//            VStack{
//                Spacer()
//                HStack{
//                    Button{
//                        withAnimation{
//                            alignment = .leading
//                        }
//                    } label: {
//                        Text("leading")
//                    }
//                    Button{
//                        withAnimation{
//                            alignment = .trailing
//                        }
//                    } label: {
//                        Text("trailing")
//                    }
//                }
//                .buttonStyle(.bordered)
//                HStack{
//                    Button{
//                        withAnimation{
//                            markPosition = .top
//                        }
//                    } label: {
//                        Text("top")
//                    }
//                    Button{
//                        withAnimation{
//                            markPosition = .bottom
//                        }
//                    } label: {
//                        Text("bottom")
//                    }
//                    
//                }
//                .buttonStyle(.bordered)
//            }
//        }
//    }
//}
//
//#Preview{
//    RulerTestView()
//}
