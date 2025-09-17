//
//  StocksEditView.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/04/10.
//

// 20250905 使ってない！！！！！！

import Foundation
import SwiftUI
import SwiftData
import AudioToolbox
import PhotosUI


struct StocksEditDetailEditView: View {
//    @Environment(\.presentationMode) var presentationMode
    
    @Query var stockStatuses: [YarnStockStatus]
    
    @Binding var detail: InputYarnStockDetail
    @State private var showEditCel: Bool = false
    @State private var showEditDetail: Bool = false

    
    
    let reader: ScrollViewProxy
//    let geometry: GeometryProxy
    
    @FocusState var detailFocus: Bool
    
    
    var body: some View {
//        GeometryReader { innerGeometry in
        NavigationLink{
//            StocksDetailEditView(detail: $detail)
        } label: {
            HStack {
                Label("", image: "yarn")
//                    .foregroundStyle(detail.info.symbolColor)
                Image(systemName: "scalemass.fill")
                    .symbolEffect(.wiggle, value: detail.weight)
                Text("\(detail.weight.roundedString())g")
                Spacer()
                Image(systemName: "arrow.trianglehead.swap")
                    .symbolEffect(.wiggle, value: detail.length)
                Text("\(detail.length.roundedString())m")
                Spacer()
                Text(detail.status.name)
                //            Image(systemName: "chevron.right")
                //                .font(.body).foregroundStyle(.secondary)
                //                .frame(width: 20)
                //                .rotationEffect(.degrees(showEditDetail ? 90 : 0)) // isRotatedがtrueなら90度回転
                //                .animation(.easeInOut, value: showEditDetail) // アニメーションを追加
            }
//            .id(detail.hashValue)
            .contentShape(Rectangle())

        }
//        HStack {
//            Label("", image: "yarn")
//                .foregroundStyle(detail.info.symbolColor)
////            Image()
////            let buttonPosition = innerGeometry.frame(in: .named("outerGeo")).origin.y
////            let screenHeight = geometry.size.height
////            Text("\(buttonPosition) / \(screenHeight)")
//            //                Text(showEditCel ? "true" : "false")
//            Image(systemName: "scalemass.fill")
//                .symbolEffect(.wiggle, value: detail.weight)
//            Text("\(detail.weight.roundedString())g")
//            Spacer()
//            Image(systemName: "arrow.left.and.right")
//                .symbolEffect(.wiggle, value: detail.length)
//            Text("\(detail.length.roundedString())m")
//            Spacer()
//            Text(detail.status.name)
//            //            Text("1")
//            //                .font(.system(.title3, design: .rounded))
//            //                .font(.body).foregroundStyle(.secondary)
//            //                .frame(width: 20)
////            Image(systemName: "chevron.right")
////                .font(.body).foregroundStyle(.secondary)
////                .frame(width: 20)
////                .rotationEffect(.degrees(showEditDetail ? 90 : 0)) // isRotatedがtrueなら90度回転
////                .animation(.easeInOut, value: showEditDetail) // アニメーションを追加
//        }
//        .id(detail.hashValue)
//        .contentShape(Rectangle())
        //        .listRowBackground(Color(profile.hilited ? UIColor.systemFill : UIColor.systemBackground).animation(.easeInOut)) //<==Here
        .listRowBackground(Color(showEditCel ? UIColor.systemGray4 : UIColor.secondarySystemGroupedBackground).animation(.easeOut))
        //        .listRowBackground(showEditDetail ? Color(UIColor.systemGray4) : Color(UIColor.secondarySystemGroupedBackground))
//        .onTapGesture {
//            withAnimation{
//                showEditCel.toggle()
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                withAnimation {
//                    showEditDetail.toggle()
//                }
//            }
//            
//            //                let buttonPosition = innerGeometry.frame(in: .named("outerGeo")).origin.y
//            //                let screenHeight = geometry.size.height
//            if !showEditDetail/* && (buttonPosition > screenHeight / 2)*/ {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                    withAnimation {
//                        reader.scrollTo(detail.hashValue, anchor: .center) // スクロールを実行
//                    }
//                }
//            }
//        }
//        }
//        if showEditDetail {
////            HStack {
//                VStack {
//                    Picker("KEY_STATUS", selection: $detail.status.animation()) {
//                        ForEach(stockStatuses.sorted(by: { $0.orderIndex < $1.orderIndex })) {stockStatus in
//                            Text(stockStatus.name).tag(stockStatus)
//                        }
//                    }
//                    //                .pickerStyle(.segmented)
//                    HStack {
//                        Text("重さ")
//                        TextField("00", value: $detail.weight, formatter: numberFormatter)
//                            .frame(width : 60.0)
//                            .padding(6)
//                            .background(Color(UIColor.tertiarySystemFill))
//                            .cornerRadius(5)
//                            .keyboardType(.decimalPad)
//                            .multilineTextAlignment(.trailing)
//                            .focused(focused)
//                            .onChange(of: detail.weight) {
//                                if detail.isLink {
//                                    let tmpW = detail.info.weight ?? 100
//                                    detail.usageRatio = detail.weight / tmpW
//                                }
//                            }
//                        Spacer()
//                        Image(systemName: detail.isLink ? "link.circle.fill" : "link.circle")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 24, height: 24)
//                            .foregroundStyle(detail.isLink ? Color.blue : Color.secondary)
//                            .contentTransition(.symbolEffect(.replace.offUp))
//                            .onTapGesture {
////                                withAnimation{
//                                    detail.isLink.toggle()
////                                }
//                            }
//                        Spacer()
//                        Text("長さ")
//                        TextField("00", value: $detail.length, formatter: numberFormatter)
//                            .frame(width : 60.0)
//                            .padding(6)
//                            .background(Color(UIColor.tertiarySystemFill))
//                            .cornerRadius(5)
//                            .keyboardType(.decimalPad)
//                            .multilineTextAlignment(.trailing)
//                            .focused(focused)
//                            .onChange(of: detail.length) {
//                                if detail.isLink {
//                                    let tmpL = detail.info.length ?? 100
//                                    detail.usageRatio = detail.length / tmpL
//                                }
//                            }
//
//                    }
//                    if detail.isLink{
//                        Slider(value: $detail.usageRatio, in: 0...1)
//                            .onChange(of: detail.usageRatio) {
//                                let tmpW = detail.info.weight ?? 100
//                                // スライダーの値に基づいて二つの値を更新
//                                detail.weight = tmpW * detail.usageRatio
//                                let tmpL = detail.info.length ?? 100
//                                detail.length = tmpL * detail.usageRatio
//                            }
//                    } else {
//                        
//                        HStack {
//                            let tmpW = detail.info.weight ?? 100
//                            Image(systemName: "scalemass.fill")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 20, height: 20)
//                            Slider(value: $detail.weight, in: 0...tmpW)
//                        }
//                        HStack {
//                            let tmpL = detail.info.length ?? 100
//                            Image(systemName: "arrow.up.and.down")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 20, height: 20)
//                            Slider(value: $detail.length, in: 0...tmpL)
//                        }
//
//                    }
//                    TextField("KEY_MEMO",
//                              text: $detail.memo,
//                              axis: .vertical
//                    )
//                    .focused(focused)
//                }
//                
////            }
//            .deleteDisabled(true)
//            .listRowBackground(showEditDetail ? Color(UIColor.systemGray4) : Color(UIColor.secondarySystemGroupedBackground))
//            
//        }
//        }

    }
}

struct StocksEditView: View {
//    @AppStorage("stockStatusList") var stockStatusList: [String] = ["新品", "中古"]
//    var userDefaults = UserDefaults.standard
//    var stockStatusList = userDefaults.array("stockStatusList") as? [String] ?? []
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @Query var stockStatuses: [YarnStockStatus]
    @State var yarnInfo: YarnInfo
    @Binding var inputYarnStock: InputYarnStock
    @Binding var inputYarnStockDetails: [InputYarnStockDetail]

    @Binding var inputComplete: Bool
//    @State private var buttonIsDisabled = true
    @State var isEntry: Bool
    
    // 色見本関連
    @State private var selectedColor: Color = .secondary
//    @State private var showColorPicker = false

    // 在庫状況関連
    @State private var isPlusButtonPressed: Bool = false
    @State private var isMinusButtonPressed: Bool = false
    
    // 在庫ステータス追加
    @State private var showAddStockStatus: Bool = false
    @State private var inputStockStatusName: String = ""
    //  フォーカス
    @FocusState var focus: Bool
//    @FocusState var detailFocus: Bool

    // 写真関連
    @State var selectedPhotos: [PhotosPickerItem] = []
    @State var showPhotoSheet: Bool = false
    
    // 写真関連
    //UIImageに変換したアイテムを格納する
    @State var getUImage: UIImage?
    //トリミングされた画像があれば表示
    //    @State var CreppedUImage: UIImage?
    //アルバムorカメラから画像が取得されれば、トリミングへ
//    @State private var showImageCropper = false
    //カメラ表示
    @State var showCameraSheet: Bool = false

    func defaultStatus() -> YarnStockStatus {
        return stockStatuses.first(where: { $0.isDefault })!
    }
    
//    @State var showStockDetail: Bool =  true
    
    @State private var isAnimating: Bool = false
    var body: some View {
        NavigationStack {
//            GeometryReader { geometry in
                ScrollViewReader { reader in
                    List{
                        // 画像挿入
                        Section (
                            header:
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
//                                    .tint(selectFolder?.color ?? .secondary)
                                    
                                }
                        ){
                            if inputYarnStock.images.isEmpty {
                                Text("KEY_NOT_REGISTERED")
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(Array(inputYarnStock.images.enumerated()), id: \.element) { index, image in
                                            Menu {
                                                Button(role: .destructive) {
                                                    withAnimation {
                                                        deleteImage(index: index)
                                                    }
                                                } label: {
                                                    Label("KEY_DELETE", systemImage: "trash")
                                                }
                                                .tint(.red)
                                            } label: {
                                                if let uiImage = UIImage(data: image) {
                                                    Image(uiImage: uiImage)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .clipShape(RoundedRectangle(cornerRadius: 10)) // 角を丸くした四角形
                                                        .frame(height:150)
                                                }
                                            }
                                        }
                                    }
                                }
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.clear)
                            }
                        }
                        
                        Section(
                            //                    header: Text("KEY_BASIC_INFO")
                        ) {
                            HStack {
                                Text("KEY_COLOR_SAMPLE")
                                Spacer()
                                ColorPicker("", selection: $inputYarnStock.sampleColor, supportsOpacity: false)
                                    .labelsHidden()
                                    .scaleEffect(CGSize(width: 999, height: 999))
                                    .frame(width: 150, height: 44)
                                    .cornerRadius(8)
                                    .clipped()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black.opacity(0.3), lineWidth: 0.5)
                                    )
                            }
                            HStack {
//                                let buttonPosition = geometry.frame(in: .global).minY
//                                Text("\(Int(geometry.frame(in: .global).origin.y))")
                                Text("KEY_COLOR_CODE")
                                Spacer()
                                TextField("00", text: $inputYarnStock.colorCode)
                                    .multilineTextAlignment(.trailing)
                                    .focused(self.$focus)
                            }
                            HStack {
//                                let buttonPosition = geometry.frame(in: .global).minY
//                                Text("\(buttonPosition)")
                                Text("KEY_LOT_NUMBER")
                                Spacer()
                                TextField("AB00", text: $inputYarnStock.lotNumber)
                                    .multilineTextAlignment(.trailing)
                                    .focused(self.$focus)
                            }
                            
                            
                        }
                        // *********************************************
                        //                // 在庫情報
                        //                Section(
                        ////                    header: Text("KEY_STOCK_INFO")
                        //                ) {
                        //                    HStack {
                        //                        Text("KEY_STOCK_QUANTITY")
                        //                        Spacer()
                        //                        Button {
                        //                            UISelectionFeedbackGenerator().selectionChanged()
                        //                            inputYarnStock.inventory -= 1
                        //                        } label: {
                        //                            Image(systemName: "minus.square.fill")
                        //                                .font(.title)
                        //                                .symbolRenderingMode(.multicolor)
                        //                        }
                        //                        .padding(.horizontal, 20)
                        //                        .buttonStyle(.plain)
                        //                        .disabled(inputYarnStock.inventory == 0)
                        //                        //                        .symbolEffect(.bounce.down.byLayer, options: .nonRepeating, value: isMinusButtonPressed)
                        //                        Text(String(inputYarnStock.inventory))
                        //                            .font(.title2)
                        //                        Button {
                        //                            UISelectionFeedbackGenerator().selectionChanged()
                        //                            inputYarnStock.inventory += 1
                        //                        } label: {
                        //                            Image(systemName: "plus.square.fill")
                        //                                .font(.title)
                        //                                .symbolRenderingMode(.multicolor)
                        //                        }
                        //                        .padding(.horizontal, 20)
                        //                        .buttonStyle(.plain)
                        //                        //                        .symbolEffect(.bounce.up.byLayer, options: .nonRepeating, value: isPlusButtonPressed)
                        //                    }
                        //                }
                        // *********************************************
                        //                ForEach(stockStatuses.sorted(by: { $0.orderIndex < $1.orderIndex })) {stockStatus in
//                        GeometryReader { innerGeometry in
//                        let size = geometry.size.height
//                            let x = innerGeometry.frame(in: .named("outerGeo")).origin.x
//                            let y = innerGeometry.frame(in: .named("outerGeo")).origin.y
////                            let maxY = geometryProxy.frame(in: .named("container")).maxY
////                            let sizeY = geometry.frame(in: .named("container")).size
//                            VStack {
//                                Text("size: \(size)")
//                                Text("x: \(x), y: \(y)").background(.red)
////                                Text("sizeY: \(sizeY)").background(.red)
//                            }
//                        }

                        Section(
                            header:
                                HStack {
                                    ListTitleView(title: "KEY_INVENTORY_STATUS")
                                    Spacer()
                                    Button{
                                        let newDetail = InputYarnStockDetail(
                                            status: defaultStatus(),
                                            length: yarnInfo.length ?? 0,
                                            weight: yarnInfo.weight ?? 0,
                                            info: yarnInfo
                                        )
                                        withAnimation {
                                            inputYarnStockDetails.append(newDetail)
                                            //                                        print("add InputYarnStockDetail count = \(inputYarnStockDetails.count)")
                                            //                                        print("add InputYarnStockDetail status = \(newDetail.status.name)")
                                        }
                                        
                                    } label: {
                                        Label("KEY_ADD", systemImage: "plus")
                                            .fontWeight(.bold)
                                    }
                                    .buttonStyle(.bordered)
                                    .controlSize(.small)
                                    .buttonBorderShape(.capsule)
                                    //                                .tint(inputYarnInfo.symbolColor)
                                    .sensoryFeedback(.selection, trigger: inputYarnStockDetails.count)
                                }
                        ) {
                            //                    StocksEditStatusView(/*stockStatus: stockStatus, */inputYarnStockDetails: $inputYarnStockDetails)
                            HStack {
                                Text("KEY_STOCK_QUANTITY")
                                Spacer()
                                Text("\(inputYarnStockDetails.count)")
                                    .scaleEffect(isAnimating ? 1.2 : 1.0) // 拡大縮小
//                                    .rotationEffect(.degrees(isAnimating ? 5 : 0)) // 回転
                                    .animation(.easeInOut(duration: 0.2), value: isAnimating) // アニメーション
                                    .onChange(of: inputYarnStockDetails.count) {
                                        isAnimating = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            isAnimating = false
                                        }
                                    }
                                    .font(.system(.title, design: .rounded))
                                    
//                                Image(systemName: "chevron.right")
//                                    .font(.body).foregroundStyle(.secondary)
//                                    .frame(width: 20)
//                                    .rotationEffect(.degrees(showStockDetail ? 90 : 0)) // isRotatedがtrueなら90度回転
//                                    .animation(.easeInOut, value: showStockDetail) // アニメーションを追加
                                
                            }
                            .contentShape(Rectangle())
                            ForEach($inputYarnStockDetails) { $detail in
                                StocksEditDetailEditView(detail: $detail, reader: reader/*, focused: $detailFocus, geometry: geometry*/)
                            }
                            .onDelete(perform: deleteDetails)
                            
                        }
                        // *********************************************
                        // *********************************************
                        Section() {
//                            let buttonPosition = geometry.frame(in: .global).minY
//                            Text("\(buttonPosition)")
                            TextField("KEY_MEMO",
                                      text: $inputYarnStock.memo,
                                      axis: .vertical
                            )
                            .focused(self.$focus)
                            //                    .frame(minHeight: 80)
                        }
                        .id("memo")
                    }
                    //            .listStyle(.grouped)
                    .navigationTitle("KEY_ADD_STOCK")
                    .toolbarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("KEY_CANCEL")
                                    .foregroundColor(.red) // キャンセルボタンの色
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                inputComplete = true
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("KEY_COMPLETE")
                                //                            .foregroundColor(buttonIsDisabled ? .secondary : .blue) // ボタンの色を変更
                            }
                            //                    .disabled(buttonIsDisabled)
                        }
                        ToolbarItem(placement: .keyboard){
                            HStack{
                                Spacer()
                                Button{
                                    focus = false
//                                    detailFocus = false
                                }label: {
//                                    Image(systemName: "keyboard.chevron.compact.down")
                                    Text("KEY_DONE")
                                }
                            }
                        }
                        
                    }
                    
                }

//            }.coordinateSpace(.named("outerGeo"))
        }/*.coordinateSpace(.named("container"))*/
        // 画像周り
        /*
         ＜忘れそうなので、仕様説明＞
         画像を選択すると、PhotosPickerItemになる。
         それをonChangeで監視して、変更があった際にuiImage型に変換してgetUImageに代入する
         getUImageが変わるとまたonChanggいーあ呼ばれ、
         そのuiImageからImageCropperを使ってトリミング画面を表示させる
         ImageCropperにてdoneを押した後の処理としてimageCropped関数を読んでおり、
         uiImage型をData型に変換し、inputSwatch.imageへ保存している
         表示時はData型をuiImage型へ変換して表示している。
         */
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
                    inputYarnStock.images.append(data)
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
                inputYarnStock.images.append(pngData)
            }
        }
//        //得た画像を編集する時に表示
//        .sheet(isPresented: $showImageCropper) {
//            ImageCropper(image: self.$getUImage, visible: self.$showImageCropper, done: imageCropped)
//        }
    }
    //トリミングが終わった後に呼ばれる
//    func imageCropped(image: UIImage){
//        //        CreppedUImage = image
//        withAnimation {
//            //            guard let uiImage = uiImage else { return }
//            //            imageData = image.pngData()
//            inputYarnStock.image = image.pngData()
//        }
//    }
    
//    func addStockDetail(status: YarnStockStatus) {
//        withAnimation {
//            let newDetail = InputYarnStockDetail(orderIndex: <#T##Int#>, length: <#T##Double?#>, weight: <#T##Double?#>, memo: <#T##String#>)
//        }
//    }
    
    private func addStatus() {
        defer {
            inputStockStatusName = ""
        }
        if inputStockStatusName.isEmpty {
            return
        }
        withAnimation{
            let newStatus = YarnStockStatus(
                orderIndex:stockStatuses.count,
                name: inputStockStatusName
            )
            modelContext.insert(newStatus)

        }
    }
    
    public func deleteDetails(offsets: IndexSet) {
        inputYarnStockDetails.remove(atOffsets: offsets)
    }

    private func deleteImage(index: Int) {
        inputYarnStock.images.remove(at: index)
    }

}
#Preview {
//    @Previewable @State var yarnInfo: YarnInfo = .init(name: "テスト毛糸", memo: "", createdAt: Date())
////    @Previewable @State var colorCmp = ColorComponents(red: Float.random(in: 0.0...1.0), green: Float.random(in: 0.0...1.0), blue: Float.random(in: 0.0...1.0))
//    @Previewable @State var yarnStock: YarnStock = YarnStock(
//        yarnInfo: YarnInfo(name: "テスト毛糸", memo: "", createdAt: Date()),
//        orderIndex: 0,
//        image: nil,
//        sampleColor: ColorComponents(red: Float.random(in: 0.0...1.0), green: Float.random(in: 0.0...1.0), blue: Float.random(in: 0.0...1.0)),
//        colorCode: "",
//        lotNumber: "",
//        inventory: 0,
//        memo: "", createdAt: Date()
//    )
    @Previewable @State var yarnInfo: YarnInfo = YarnInfo(name: "テスト毛糸", length: 60, weight: 50)
    @Previewable @State var inputYarnStock: InputYarnStock = .init()
    @Previewable @State var inputYarnStockDetail: [InputYarnStockDetail] = []
    @Previewable @State var inputComplete = false
    @Previewable @State var isEntry = true
    StocksEditView( yarnInfo: yarnInfo, inputYarnStock: $inputYarnStock, inputYarnStockDetails: $inputYarnStockDetail, inputComplete: $inputComplete, isEntry: isEntry)
        .modelContainer(previewYarn)
}

