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
    @Query var stockStatuses: [YarnStockStatus]
    
    @AppStorage("weightUnit") var weightUnit = "g"
    @AppStorage("lengthUnit") var lengthUnit = "m"

    @State var stock: YarnStock
    
    @State private var tmpColor: Color = .blue
    
    // 画像拡大用
    @State private var showFullImage = false
    @State private var showImages: [showImageContainer] = []
    @State private var showImageIndex: Int = 0

    @FocusState private var focus: Bool
        
    @State private var showImagesSection: Bool = true
    
    func defaultStatus() -> YarnStockStatus {
        return stockStatuses.first(where: { $0.isDefault })!
    }
    
//    @State private var isAnimating: Bool = false
    
    // 写真関連
    @State var selectedPhotos: [PhotosPickerItem] = []
    @State var showPhotoSheet: Bool = false
    @State var getUImage: UIImage?
    @State var showCameraSheet: Bool = false

    
    // frrdback用
    @State private var feedbackForAddStockDetail: Bool = false

    var body: some View {
        List() {
            // 画像
            Section(
                isExpanded: $showImagesSection
                
            ) {
                if stock.images.isEmpty {
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Array(stock.images.enumerated()), id: \.element) { i, image in
                                if let uiImage = UIImage(data: image) {
                                    Menu{
                                        Button(role: .destructive) {
                                            stock.images.remove(at: i)
                                            try? modelContext.save()
                                        } label: {
                                            Label("KEY_DELETE", systemImage: "trash")
                                        }
                                        .tint(.red)
                                    } label: {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(RoundedRectangle(cornerRadius: 10)) // 角を丸くした四角形
                                            .frame(height:150)
                                    } primaryAction: {
                                        for tmpImage in stock.images{
                                            if let tmpUiImage = UIImage(data: tmpImage) {
                                                let appendImage = showImageContainer(uiImage: tmpUiImage)
                                                showImages.append(appendImage)
                                            }
                                        }
                                        print("detail view cnt = \(showImages.count)")
                                        showImageIndex = i
                                        showFullImage = true
                                    }
                                }
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
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
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .buttonBorderShape(.capsule)

                }
                
            }
            // *********************
            Section(
                //                    header: Text("KEY_BASIC_INFO")
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
                    //                                let buttonPosition = geometry.frame(in: .global).minY
                    //                                Text("\(Int(geometry.frame(in: .global).origin.y))")
                    Label("KEY_COLOR_CODE", systemImage: "swatchpalette")
                    Spacer()
                    TextField("00", text: $stock.colorCode)
                        .multilineTextAlignment(.trailing)
                        .focused(self.$focus)
                }
                HStack {
                    //                                let buttonPosition = geometry.frame(in: .global).minY
                    //                                Text("\(buttonPosition)")
                    Label("KEY_LOT_NUMBER", systemImage: "numbers.rectangle")
                    Spacer()
                    TextField("AB00", text: $stock.lotNumber)
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
                    Label("KEY_TOTAL_LENGTH", systemImage: "arrow.left.and.right")
                    Spacer()
                    Text("\(String(format: "%.1f", stock.totalLength)) \(lengthUnit)")
                        .contentTransition(.numericText(value: stock.totalLength))
                }
            }
            Section(
                header:
                    HStack {
                        ListTitleView(title: "KEY_DETAIL")
                        Spacer()
                        Button{
                            feedbackForAddStockDetail.toggle()
                            withAnimation{
                                let newDetail = YarnStockDetail(stock: stock, status: defaultStatus())
                                modelContext.insert(newDetail)
                                try? modelContext.save()
                            }
//                            withAnimation {
//                                stock.details.append(newDetail)
//                                try? modelContext.save()
//                            }
                            
                        } label: {
                            Label("KEY_ADD", systemImage: "plus")
                                .fontWeight(.bold)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .buttonBorderShape(.capsule)
                        //                                .tint(inputYarnInfo.symbolColor)
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
                                                Image(systemName: "arrow.left.and.right")
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
                                    try? modelContext.save()
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
                TextField("KEY_MEMO",
                          text: $stock.memo,
                          axis: .vertical
                )
                .focused(self.$focus)
                //                    .frame(minHeight: 80)
            }

            // *********************
            // *********************
            // *********************
            
        }
//        .listStyle(.sidebar)
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

        .onAppear {
            tmpColor = stock.sampleColor.color
        }
        .fullScreenCover(isPresented: $showFullImage, onDismiss: {
            showImages = []
        }, content: {
            FullImagesView(images: $showImages, selectIndex: $showImageIndex)
        })

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
            if let uiImage = getUImage, let pngData = uiImage.pngData() {
                stock.images.append(pngData)
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
