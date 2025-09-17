//
//  StocksDetailView.swift
//  ItomakiKeitoKun
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
    
    @State private var isAnimating: Bool = false
    
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
                    //                    Text("KEY_NOT_REGISTERED")
                    //                        .listStyle(.plain)
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
//                                            .contextMenu(menuItems: {
//                                                Button(role: .destructive) {
//                                                    stock.images.remove(at: i)
//                                                    try? modelContext.save()
//                                                } label: {
//                                                    Label("KEY_DELETE", systemImage: "trash")
//                                                }
//                                                .tint(.red)
//                                            })

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
//                                    Image(uiImage: uiImage)
//                                        .resizable()
//                                        .scaledToFit()
//                                        .clipShape(RoundedRectangle(cornerRadius: 10)) // 角を丸くした四角形
//                                        .frame(height:150)
//                                        .contextMenu(menuItems: {
//                                            Button(role: .destructive) {
//                                                stock.images.remove(at: i)
//                                                try? modelContext.save()
//                                            } label: {
//                                                Label("KEY_DELETE", systemImage: "trash")
//                                            }
//                                            .tint(.red)
//                                        })
//                                        .onTapGesture {
//                                            for tmpImage in stock.images{
//                                                if let tmpUiImage = UIImage(data: tmpImage) {
//                                                    let appendImage = showImageContainer(uiImage: tmpUiImage)
//                                                    showImages.append(appendImage)
//                                                }
//                                            }
//                                            print("detail view cnt = \(showImages.count)")
//                                            showImageIndex = i
//                                            showFullImage = true
//                                        }
                                    
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
                    Text("KEY_COLOR_SAMPLE")
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
                    Text("KEY_COLOR_CODE")
                    Spacer()
                    TextField("00", text: $stock.colorCode)
                        .multilineTextAlignment(.trailing)
                        .focused(self.$focus)
                }
                HStack {
                    //                                let buttonPosition = geometry.frame(in: .global).minY
                    //                                Text("\(buttonPosition)")
                    Text("KEY_LOT_NUMBER")
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
                        Button{
                            feedbackForAddStockDetail.toggle()
                            let newDetail = YarnStockDetail(stock: stock, status: defaultStatus())
                            withAnimation {
                                stock.details.append(newDetail)
                                try? modelContext.save()
                            }
                            
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
            ) {
                //                    StocksEditStatusView(/*stockStatus: stockStatus, */inputYarnStockDetails: $inputYarnStockDetails)
                HStack {
                    Text("KEY_STOCK_QUANTITY")
                    Spacer()
                    Text("\(stock.details.count)")
                        .scaleEffect(isAnimating ? 1.2 : 1.0) // 拡大縮小
                    //                                    .rotationEffect(.degrees(isAnimating ? 5 : 0)) // 回転
                        .animation(.easeInOut(duration: 0.2), value: isAnimating) // アニメーション
                        .onChange(of: stock.details.count) {
                            isAnimating = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isAnimating = false
                            }
                        }
                        .font(.system(.title, design: .rounded))
                }
//                .contentShape(Rectangle())
                ForEach(stock.details.sorted(by: { $0.orderIndex < $1.orderIndex })) { detail in
//                    StocksEditDetailEditView(detail: $detail, reader: reader/*, focused: $detailFocus, geometry: geometry*/)
                    NavigationLink{
                        StocksDetailEditView(detail: detail)
                    } label: {
                        VStack {
                            HStack {
                                Label("", image: "yarn")
//                                    .foregroundStyle(tmpColor)
                                //                                .foregroundStyle(detail.info.symbolColor)
                                Image(systemName: "scalemass.fill")
//                                    .symbolEffect(.wiggle, value: detail.weight)
                                Text("\(detail.weight.roundedString()) \(weightUnit)")
                                Spacer()
                                Image(systemName: "arrow.left.and.right")
//                                    .symbolEffect(.wiggle, value: detail.length)
                                Text("\(detail.length.roundedString()) \(lengthUnit)")
                                Spacer()
                                Text(detail.status.name)
                            }
                            if detail.isLink {
                                Gauge(value: detail.usageRatio) {
                                    //                                Text("BPM")
                                }
                                .gaugeStyle(.accessoryLinearCapacity)
//                                .tint(tmpColor)
                            }
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        // スワイプ＞削除
                        Button(role: .destructive) {
                            modelContext.delete(detail)
                            try? modelContext.save()
                            renumberStockDetail()
                            try? modelContext.save()
                        } label: {
                            Label("KEY_DELETE", systemImage: "trash.fill")
                        }
                        .tint(.red)
//                        // スワイプ＞更新
//                        Button {
//                            tmpEditFolder = folder
//                            inputFolder.name = folder.name
//                            inputFolder.colorName = folder.colorName
//                            showFolderEditSheet = true
//                        } label: {
//                            Label("KEY_EDIT", systemImage: "pencil")
//                        }
//                        .tint(.orange)
                    }


                }
//                .onDelete(perform: deleteDetails)
                
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
                    Text(stock.yarnInfo.name)
                        .fontWeight(.bold)
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
        let tmpDetails = stock.details.sorted { $0.orderIndex < $1.orderIndex }
        for (index, detail) in tmpDetails.enumerated() {
            detail.orderIndex = index
        }
        try? modelContext.save()
    }
}
