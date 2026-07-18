//
//  StocksDetailView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/04/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct StocksDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.locale) var locale
    @Environment(YarnStock.self) var stock
    
    @Query var stockStatuses: [YarnStockStatus]
    
    @AppStorage("weightUnit") var weightUnit = "g"
    @AppStorage("lengthUnit") var lengthUnit = "m"
    
    //    @State var stock: YarnStock
    
    @State private var tmpColor: Color = .blue
    
    // 画像拡大用
    //    @State private var showFullImage = false
    //    @State private var showImages: [showImageContainer] = []
    //    @State private var showImageIndex: Int = 0
    
    @State private var ipModel:ImagePreviewModel = .init()
    @State private var stockImageDatas: [ImageData] = []
    @Namespace private var namespace
    
    @FocusState private var focus: Bool
    
    @State private var showImagesSection: Bool = true
    @State private var showInfoSection: Bool = false
    
    func defaultStatus() -> YarnStockStatus {
        return stockStatuses.first(where: { $0.isDefault })!
    }
    
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
    
    //    @State private var isAnimating: Bool = false
    
    // 写真関連
    @State var selectedPhotos: [PhotosPickerItem] = []
    @State var showPhotoSheet: Bool = false
    @State var getUImage: UIImage?
    @State var showCameraSheet: Bool = false
    
    
    // frrdback用
    @State private var feedbackForAddStockDetail: Bool = false
    
    init(){
        //        self._stock = State(initialValue: stock)
        //        self._stockImageDatas = State(initialValue: stock.images.map { ImageData(data: $0) })
    }
    
    var body: some View {
        List() {
            // 基本毛糸情報
            Section(
                isExpanded: $showInfoSection
            ){
                VStack{
                    // 素材
                    if let wrappedMaterials = stock.yarnInfo?.materials{
                        if wrappedMaterials.isEmpty {
                            Text("KEY_NOT_REGISTERED")
                        }
                        ForEach(wrappedMaterials.sorted(by: { $0.orderIndex < $1.orderIndex })) {yarnMaterial in
                            HStack {
                                //                        Text("\(yarnMaterial.orderIndex)")
                                let material = getYarnMaterial(by: yarnMaterial.materialId)
                                let name = LocalizedStringKey(material.name)
                                Text(name)
                                Spacer()
                                Text("\(yarnMaterial.percentage)%")
                            }
                            
                        }
                    }
                    Divider()
                    // 標準ゲージ
                    HStack{
                        Text("KEY_STANDARD_GAUGE")
                        Spacer()
                        if let stitches = stock.yarnInfo?.standardGaugeStitches {
                            Text("KEY_STITCHES\(stitches.roundedString())")
                        }
                        if let rows = stock.yarnInfo?.standardGaugeRows {
                            Text("KEY_ROWS\(rows.roundedString())")
                        }
                    }
                    // 使用棒針
                    HStack {
                        Text("KEY_USE_CIRCULAR_NEEDLE")
                        Spacer()
                        if let from = stock.yarnInfo?.useKnittingNeedlesFrom{
                            let needle = getKnittingNeedlesSize(by: from)
                            Text(dispNeedleSizeLabel(from: needle))
                        }
                        if stock.yarnInfo?.useKnittingNeedlesFrom != nil || stock.yarnInfo?.useKnittingNeedlesTo != nil{
                            Image(systemName: "alternatingcurrent")
                        }
                        if let from = stock.yarnInfo?.useKnittingNeedlesTo{
                            let needle = getKnittingNeedlesSize(by: from)
                            Text(dispNeedleSizeLabel(from: needle))
                        }
                    }
                    // 使用かぎ針
                    HStack {
                        Text("KEY_USE_HOOK")
                        Spacer()
                        if let from = stock.yarnInfo?.useCrochetHookFrom{
                            let needle = getCrochetHookSize(by: from)
                            Text(dispNeedleSizeLabel(from: needle))
                        }
                        if stock.yarnInfo?.useCrochetHookFrom != nil || stock.yarnInfo?.useCrochetHookTo != nil{
                            Image(systemName: "alternatingcurrent")
                        }
                        if let from = stock.yarnInfo?.useCrochetHookTo{
                            let needle = getCrochetHookSize(by: from)
                            Text(dispNeedleSizeLabel(from: needle))
                        }
                    }
                    // 重さ
                    HStack {
                        Text("KEY_WEIGHT")
                        Spacer()
                        if let weight = stock.yarnInfo?.weight{
                            Text("\(String(weight)) \(weightUnit)")
                        }
                    }
                    // 長さ
                    HStack {
                        Text("KEY_LENGTH")
                        Spacer()
                        if let length = stock.yarnInfo?.length{
                            Text("\(String(length)) \(lengthUnit)")
                        }
                    }
                    
                }
                
            } header: {
                HStack {
                    ListTitleView(title: "KEY_LABEL_INFO")
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .rotationEffect(Angle(degrees: showInfoSection ? 90 : 0))
                }
                .contentShape(.rect)
                .onTapGesture{
                    withAnimation{
                        showInfoSection.toggle()
                    }
                }
                
            }
            // 画像
            Section(
                isExpanded: $showImagesSection
                
            ) {
                if stock.images.isEmpty {
                } else {
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            ForEach(Array(stockImageDatas.enumerated()), id: \.element.id) { i, image in
                                Menu{
                                    Button(role: .destructive) {
                                        withAnimation{
                                            stockImageDatas.remove(at: i)
                                            stock.images.remove(at: i)
                                            try? modelContext.save()
                                        }
                                    } label: {
                                        Label("KEY_DELETE", systemImage: "trash")
                                    }
                                    .tint(.red)
                                } label: {
                                    ResizedImage(data: image.data)
                                        .clipShape(RoundedRectangle(cornerRadius: 10)) // 角を丸くした四角形
                                        .frame(height:150)
                                        .matchedGeometryEffect(id: "\(image.id)", in: namespace)
                                        .matchedTransitionSource(id: "\(image.id)", in: namespace)
                                        .buttonStyle(.plain)
                                } primaryAction: {
                                    ipModel.sourceId = "\(image.id)"
                                    ipModel.image = image.data
                                    ipModel.showSheet = true
                                }
                            }
                        }
                    }
                }
            } header: {
                HStack {
                    ListTitleView(title: "KEY_IMAGE")
                    Spacer()
                    Menu {
                        // カメラ表示
                        Button{
                            showCameraSheet = true
                        }label:{
                            Label("KEY_CAMERA", systemImage: "camera")
                        }
                        // アルバム表示
                        Button{
                            showPhotoSheet = true
                        }label:{
                            Label("KEY_ALBUM", systemImage: "photo.on.rectangle.angled")
                        }
                    } label: {
                        Label("KEY_ADD", systemImage: "plus")
                            .fontWeight(.bold)
                    }
                    .listHeaderButtonStyle()
                    Image(systemName: "chevron.forward")
                        .rotationEffect(Angle(degrees: showImagesSection ? 90 : 0))
                }
                .contentShape(.rect)
                .onTapGesture{
                    withAnimation{
                        showImagesSection.toggle()
                    }
                }
                
                
            }
            // *********************
            Section(
            ) {
                HStack {
                    Label("KEY_COLOR_SAMPLE", systemImage: "paintpalette")
                    Spacer()
                    ColorPicker("", selection: $tmpColor, supportsOpacity: false)
                        .labelsHidden()
                        .scaleEffect(CGSize(width: 999, height: 999))
                        .frame(width: 150, height: 44)
                        .cornerRadius(8)
                        .clipped()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black.opacity(0.3), lineWidth: 0.5)
                        )
                        .onChange(of: tmpColor){
                            let colorComponents = ColorComponents.fromColor(tmpColor)
                            stock.sampleColor = colorComponents
                        }
                }
                HStack {
                    Label("KEY_COLOR_CODE", systemImage: "swatchpalette")
                    Spacer()
                    TextField("00", text: Binding(
                        get: { stock.colorCode },
                        set: { stock.colorCode = $0 }
                    ))
                    .multilineTextAlignment(.trailing)
                    .focused(self.$focus)
                }
                HStack {
                    Label("KEY_LOT_NUMBER", systemImage: "numbers.rectangle")
                    Spacer()
                    TextField("AB00", text: Binding(
                        get: { stock.lotNumber },
                        set: { stock.lotNumber = $0 }
                    ))
                    .multilineTextAlignment(.trailing)
                    .focused(self.$focus)
                }
                
                
            }
            // *********************
            Section(
                header:
                    HStack {
                        ListTitleView(title: "KEY_INVENTORY_STATUS")
                        Spacer()
                    }
            ) {
                //                    StocksEditStatusView(/*stockStatus: stockStatus, */inputYarnStockDetails: $inputYarnStockDetails)
                HStack {
                    Label("KEY_STOCK_QUANTITY", systemImage: "basket")
                    Spacer()
                    if let wrappedDetails = stock.details{
                        Text("\(wrappedDetails.count)")
                            .contentTransition(.numericText(value: Double(wrappedDetails.count)))
                            .font(.system(.title, design: .rounded))
                    }
                }
                HStack{
                    Label("KEY_TOTAL_WEIGHT", systemImage: "scalemass")
                    Spacer()
                    Text("\(String(format: "%.1f", stock.totalWeight)) \(weightUnit)")
                        .contentTransition(.numericText(value: stock.totalWeight))
                }
                HStack{
                    Label("KEY_TOTAL_LENGTH", systemImage: "glowplug")
                    Spacer()
                    Text("\(String(format: "%.1f", stock.totalLength)) \(lengthUnit)")
                        .contentTransition(.numericText(value: stock.totalLength))
                }
            }
            Section(
                header:
                    HStack {
                        ListTitleView(title: "KEY_STOCK_DETAIL")
                        Spacer()
                        Button{
                            feedbackForAddStockDetail.toggle()
                            withAnimation{
                                let newDetail = YarnStockDetail(stock: stock, status: defaultStatus())
                                modelContext.insert(newDetail)
                                try? modelContext.save()
                            }
                        } label: {
                            Label("KEY_ADD", systemImage: "plus")
                        }
                        .listHeaderButtonStyle()
                        .sensoryFeedback(.success, trigger: feedbackForAddStockDetail)
                    }
                
            ){
                if let wrappedDetails = stock.details{
                    ForEach(wrappedDetails.sorted(by: { $0.orderIndex < $1.orderIndex })) { detail in
                        NavigationLink{
                            StocksDetailEditView(detail: detail)
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Label("", image: "yarn")
                                    VStack(alignment: .leading){
                                        HStack{
                                            HStack{
                                                Image(systemName: "scalemass.fill")
                                                Text("\(detail.weight.roundedString()) \(weightUnit)")
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            HStack{
                                                Image(systemName: "glowplug")
                                                Text("\(detail.length.roundedString()) \(lengthUnit)")
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        if detail.memo != "" {
                                            Text(detail.memo)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                                .padding(2)
                                        }
                                    }
                                    Spacer()
                                    if let wrappedStatus = detail.status{
                                        Text(wrappedStatus.name)
                                    }
                                }
                                if detail.isLink {
                                    Gauge(value: detail.usageRatio) {
                                        //                                Text("label")
                                    }
                                    .gaugeStyle(.accessoryLinearCapacity)
                                    //                                .tint(tmpColor)
                                }
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            // スワイプ＞削除
                            Button(role: .destructive) {
                                withAnimation{
                                    modelContext.delete(detail)
                                    //                                    try? modelContext.save()
                                    renumberStockDetail()
                                    try? modelContext.save()
                                }
                            } label: {
                                Label("KEY_DELETE", systemImage: "trash.fill")
                            }
                            .tint(.red)
                        }
                    }
                }
            }
            // *********************
            Section() {
                TextField("KEY_MEMO", text: Binding(
                    get: { stock.memo },
                    set: { stock.memo = $0 }
                ), axis: .vertical)
                .focused(self.$focus)
                //                    .frame(minHeight: 80)
            }
            
            // *********************
            // *********************
            // *********************
            
        }
        .onAppear{
            stockImageDatas = stock.images.map { ImageData(data: $0) }
            tmpColor = stock.sampleColor.color
        }
        .onChange(of: stock){
            stockImageDatas = stock.images.map { ImageData(data: $0) }
            tmpColor = stock.sampleColor.color
        }
        // これをつけると、デフォルトでセクションの開閉ができるようになるが、
        // ipadでの見た目がそっけなくなってしまうので、自前で実装する。
        //        .listStyle(.sidebar)
        .toolbarTitleDisplayMode(.inline)
        //        .safeAreaInset(edge: .top) {
        //            if showInfo {
        //                TabView{
        //                    List{
        //                        Text("1")
        //                        Text("1")
        //                        Text("1")
        //                    }
        //                    List{
        //                        Text("2")
        //                        Text("2")
        //                        Text("2")
        //                    }
        //                }
        //                .tabViewStyle(.page)
        //                .frame(width: .infinity, height: 200)
        //
        //            }
        //        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    if let wrappedYarn = stock.yarnInfo{
                        Text(wrappedYarn.name)
                            .fontWeight(.bold)
                    }
                    Rectangle()
                        .fill(tmpColor)
                        .frame(width: 32, height: 32)
                        .cornerRadius(10)
                    
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                //                Button{
                //                    withAnimation{
                //                        showInfo.toggle()
                //                    }
                //                } label: {
                //                    Image(systemName: showInfo ? "info.circle.fill" : "info.circle")
                //                }
            }
            ToolbarItem(placement: .keyboard){
                HStack{
                    Spacer()
                    Button{
                        focus = false
                    }label: {
                        //                        Image(systemName: "keyboard.chevron.compact.down")
                        Text("KEY_DONE")
                    }
                }
            }
            
        }
        //        .fullScreenCover(isPresented: $showFullImage, onDismiss: {
        //            showImages = []
        //        }, content: {
        //            FullImagesView(images: $showImages, selectIndex: $showImageIndex, namespace: namespace)
        //        })
        .fullScreenCover(isPresented:$ipModel.showSheet){
            ImagePreviewView(imageData: $ipModel.image, sourceId: $ipModel.sourceId, namespace: namespace)
        }
        .photosPicker (
            isPresented: $showPhotoSheet,
            selection: $selectedPhotos,
            //                        maxSelectionCount: 5,
            //                        selectionBehavior: .ordered,
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: selectedPhotos){
            Task {
                for item in selectedPhotos {
                    guard let data = try await item.loadTransferable(type: Data.self) else { continue }
                    stock.images.append(data)
                    try? modelContext.save()
                }
                selectedPhotos = []
            }
        }
        //写真を撮る時に表示
        .fullScreenCover(isPresented:$showCameraSheet){
            CameraView(image: $getUImage).ignoresSafeArea()
        }
        //画像を得た時
        .onChange(of: getUImage) {
            if let uiImage = getUImage, let imageData = uiImage.jpegData(compressionQuality: 0.3) {
                stock.images.append(imageData)
                try? modelContext.save()
            }
        }
        
    }
    //    public func deleteDetails(offsets: IndexSet) {
    //        var detail = stock.details
    //        stock.details.remove(atOffsets: offsets)
    //    }
    
    private func renumberStockDetail() {
        // orderIndexでソート
        if let wrappedDetails = stock.details{
            let tmpDetails = wrappedDetails.sorted { $0.orderIndex < $1.orderIndex }
            for (index, detail) in tmpDetails.enumerated() {
                detail.orderIndex = index
            }
            try? modelContext.save()
            
        }
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(previewYarn)
//}

