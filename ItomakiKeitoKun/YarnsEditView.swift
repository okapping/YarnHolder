//
//  YarnsEditView.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/03/11.
//

import Foundation
import SwiftUI
import SwiftData
import Flow
import PhotosUI


struct YarnsEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var inputYarnInfo: InputYarnInfo
    @Binding var inputYarnMaterials: [InputYarnMaterial]
//    @Binding var inputYarnStocks: [InputYarnStock]
    @Binding var inputComplete: Bool
    @State private var buttonIsDisabled = true
    @State var isEntry: Bool
    
//    @State var test = Material.none
    @State var test: [Int] = []

    // 写真関連
    @State var selectedPhotos: [PhotosPickerItem] = []
//    @State var selectedImages: [UIImage] = []
    @State var showPhotoSheet: Bool = false

    //カメラ表示
    @State var showCameraSheet: Bool = false
    //UIImageに変換したアイテムを格納する
    @State var getUImage: UIImage?

    //  フォーカス
    @FocusState var focus: Bool
    
    var body: some View {
        NavigationStack {
            List {
                // **********************************************
                Section {
                    TextField("KEY_YARN_NAME", text: $inputYarnInfo.name)
                        .focused(self.$focus)
                }
                // **********************************************
                // シンボル
                Section (
//                    header: ListTitleView(title: "シンボル")
                ){
                    NavigationLink{
                        YarnSymbolsSelectView(selectSymbol: $inputYarnInfo.symbolId)
                    } label: {
                        HStack{
                            Spacer()
//                            Text("\(inputYarnInfo.symbolId)")
                            createImageView(for: getYarnSymbol(by: inputYarnInfo.symbolId))
                                .font(.largeTitle)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 50, height: 50)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                    }
                }
                // **********************************************
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
                                ListTitleButtonView(title: "KEY_ADD")
//                                if inputYarnInfo.images != nil {
//                                    ListTitleButtonView(title: "画像を変更")
//                                } else {
//                                    ListTitleButtonView(title: "画像を追加")
//                                }
                            }
                        }
                ){
                    if inputYarnInfo.images.isEmpty {
                        Text("KEY_NOT_REGISTERED")
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(inputYarnInfo.images, id: \.self) { image in
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
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                    }
                }
                // **********************************************
//                Section (
//                    header:
//                        HStack {
//                            Text("在庫")
//                            Button{
//                                let newStock: InputYarnStock = .init()
//                                withAnimation {
//                                    inputYarnStocks.append(newStock)
//                                }
//                            } label: {
//                                Image(systemName: "plus.app")
//                            }
//                        }
//                        .font(.title2)
//                        .foregroundColor(.primary.opacity(0.7))
//                ) {}
                // **********************************************
//                Section (
//                    header:
//                        ListTitleView(title: "タグ")
//                ){
//                    NavigationLink{
//                        TagsSelectView(selectTags: $inputYarnInfo.tags)
//                    } label: {
//                        HFlow(spacing: 8) {
//                            ForEach(inputYarnInfo.tags) { tag in
//                                Text("# \(tag.name)").tag(tag as Tag?)
//                                    .font(.footnote) // フォントサイズを小さくする
//                                    .padding(8)
//                                    .background(Color.gray.opacity(0.2))
//                                    .foregroundColor(.primary) // テキスト色も環境に応じて変更
//                                    .cornerRadius(10)
//                            }
//                        }
//                    }
//                }
                // **********************************************
                Section (
                    header:
                        HStack {
                            ListTitleView(title: "KEY_MATERIAL")
                            Spacer()
                            Button{
                                let newMaterial: InputYarnMaterial = .init()
                                withAnimation {
                                    inputYarnMaterials.append(newMaterial)
                                }
                            } label: {
                                ListTitleButtonView(title: "KEY_ADD")
                            }
                        }
//                        .font(.title2)
                        
                ) {
//                    ForEach(yarnInfo.materials.sorted(by: { $0.orderIndex < $1.orderIndex })) {yarnMaterial in

//                    ForEach($inputYarnMaterials.sorted(by: { $0.orderIndex < $1.orderIndex })) { $yarnMaterial in
                    ForEach($inputYarnMaterials) { $yarnMaterial in
//                        ForEach(Array(inputYarnMaterials.enumerated()), id: \.element) { i, material in
                        HStack {
                            Text("\(yarnMaterial.orderIndex)")
                            Picker("", selection: $yarnMaterial.materialId) {
                                ForEach(Materials, id: \.id) { material in
                                    let name = LocalizedStringKey(material.name)
                                    Text(name).tag(material.id as Int)
                                }
                            }
                            Divider()
                            HStack {
                                TextField("100", value: $yarnMaterial.percentage, format: .number)
                                    .frame(width : 40.0)
                                    .padding(5)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(5)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .focused(self.$focus)
                                Text("％")
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
//                                print("delete index = \(index)")
                                if let removeIndex = inputYarnMaterials.firstIndex(of: yarnMaterial) {
                                    inputYarnMaterials.remove(at: removeIndex)
                                }
                            } label: {
                                Label("KEY_DELETE", systemImage: "trash.fill")
                            }
                        }
                    }
                }
                // **********************************************
                // 洗濯表示
                Section (
                    header:
                        ListTitleView(title: "KEY_CARE_LABEL")
                ){
                    NavigationLink{
                        LaundrySymbolsSelectView(selectSymbols: $inputYarnInfo.laundrySymbols)
                    } label: {
                        HFlow(spacing: 8) {
                            ForEach(inputYarnInfo.laundrySymbols, id: \.self) { symId in
                                if let symbol = getLaundrySymbol(by: symId){
                                    Image(symbol.name)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }

                // **********************************************
                // 基本情報
                Section(
//                    header: ListTitleView(title: "基本情報")
                ) {
                    // 標準ゲージ
                    HStack {
                        Text("KEY_STANDARD_GAUGE")
                        Spacer()
                        TextField("00", value: $inputYarnInfo.standardGaugeStitches, format: .number)
                            .frame(width : 40.0)
                            .padding(5)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused(self.$focus)
                        Text("目")
                        TextField("00", value: $inputYarnInfo.standardGaugeRows, format: .number)
                            .frame(width : 40.0)
                            .padding(5)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused(self.$focus)
                        Text("段")
                    }
                    // 使用棒針
                    NavigationLink {
                        List{
                            Section(
                                footer:
                                    VStack(alignment: .leading){
                                        Text("KEY_REFERENCE_CIRCULAR_NEEDLE_SIZE")
                                        ForEach(KnittingNeedlesSizes, id: \.id) { needle in
                                            Text("\(needle.number)号・・・\(String(needle.size))mm")
                                        }
                                    }
                                    
                            ){
                                Picker("KEY_MIN_SIZE", selection: $inputYarnInfo.useKnittingNeedlesFrom) {
                                    ForEach(KnittingNeedlesSizes, id: \.id) { needle in
                                        Text(needle.number).tag(needle.id as Int?)
                                    }
                                }
                                Picker("KEY_MAX_SIZE", selection: $inputYarnInfo.useKnittingNeedlesTo) {
                                    ForEach(KnittingNeedlesSizes, id: \.id) { needle in
                                        Text(needle.number).tag(needle.id as Int?)
                                    }
                                }
                            }
                        }
                        .navigationTitle("KEY_USE_CIRCULAR_NEEDLE")
                    } label: {
                        HStack {
                            Text("KEY_USE_CIRCULAR_NEEDLE")
                            Spacer()
                            HStack {
                                if let from = inputYarnInfo.useKnittingNeedlesFrom{
                                    if let size = getKnittingNeedlesSize(by: from){
                                        Text("\(size.number)号 〜")
                                            .foregroundColor(.accentColor)
                                    }
                                }
                                if let from = inputYarnInfo.useKnittingNeedlesTo{
                                    if let size = getKnittingNeedlesSize(by: from){
                                        Text("\(size.number)号 まで")
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                        }
                    }
                    // 使用かぎ針
                    NavigationLink {
                        List {
                            Section(
                                footer:
                                    VStack(alignment: .leading){
                                        Text("KEY_REFERENCE_HOOK_SIZE")
                                        ForEach(CrochetHookSizes.filter { !$0.number.isEmpty }, id: \.id) { needle in
                                            Text("\(needle.number)号・・・\(String(needle.size))mm")
                                        }
                                    }
                                
                            ){
                                Picker("KEY_MIN_SIZE", selection: $inputYarnInfo.useCrochetHookFrom) {
                                    ForEach(CrochetHookSizes.filter { !$0.number.isEmpty }, id: \.id) { needle in
                                        Text(needle.number).tag(needle.id as Int?)
                                    }
                                }
                                Picker("KEY_MAX_SIZE", selection: $inputYarnInfo.useCrochetHookTo) {
                                    ForEach(CrochetHookSizes.filter { !$0.number.isEmpty }, id: \.id) { needle in
                                        Text(needle.number).tag(needle.id as Int?)
                                    }
                                }
                            }
                        }
                        .navigationTitle("KEY_USE_HOOK")
                    } label: {
                        HStack {
                            Text("KEY_USE_HOOK")
                            Spacer()
                            HStack {
                                if let from = inputYarnInfo.useCrochetHookFrom{
                                    if let size = getCrochetHookSize(by: from){
                                        Text("\(size.number)号 〜")
                                            .foregroundColor(.accentColor)
                                    }
                                }
                                if let from = inputYarnInfo.useCrochetHookTo{
                                    if let size = getCrochetHookSize(by: from){
                                        Text("\(size.number)号 まで")
                                            .foregroundColor(.accentColor)
                                    }
                                }

                            }
                        }
                    }
                    // 重量
                    HStack {
                        Text("KEY_WEIGHT")
                        Spacer()
                        TextField("000", value: $inputYarnInfo.weight, format: .number)
                            .frame(width : 40.0)
                            .padding(5)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused(self.$focus)
                        Text("g")
                    }
                    // 長さ
                    HStack {
                        Text("KEY_LENGTH")
                        Spacer()
                        TextField("000", value: $inputYarnInfo.length, format: .number)
                            .frame(width : 40.0)
                            .padding(5)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused(self.$focus)
                        Text("m")
                    }
                }
                Section {
                    TextField("KEY_MEMO",
                              text: $inputYarnInfo.memo,
                              axis: .vertical
                    )
                    .focused(self.$focus)
                }
            }
//            .listStyle(.grouped)
            .navigationTitle(isEntry ? "KEY_ADD_YARN" : "KEY_EDIT_YARN_INFO")
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
                            .foregroundColor(buttonIsDisabled ? .gray : .blue) // ボタンの色を変更
                    }
                    .disabled(buttonIsDisabled)
                }
                ToolbarItem(placement: .keyboard){
                    HStack{
                        Spacer()
                        Button{
                            focus = false
                        }label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                    }
                }
                
            }
            .onChange(of: inputYarnInfo.name) { _, _ in
                checkButtonIsDisabled()
            }
        }
        .onAppear{
            checkButtonIsDisabled()
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
                //            selectedImages = []
                //            editEvent.images = []
                
                for item in selectedPhotos {
                    guard let data = try await item.loadTransferable(type: Data.self) else { continue }
                    inputYarnInfo.images.append(data)
                    //                guard let uiImage = UIImage(data: data) else { continue }
                    //                selectedImages.append(uiImage)
                }
                selectedPhotos = []
            }

//            Task {
//                withAnimation {
//                    
//                }
//                for photo in selectedPhotos {
//                    guard let data = try await photo.loadTransferable(type: Data.self) else { return }
//                    inputYarnInfo.images.append(getUImage.pingData())
//                }
//                guard let uiImage = UIImage(data:data) else {return}
//                selectedPhotos = []
//                getUImage = uiImage
                //                withAnimation {
                //                    inputSwatch.image = data
                //                }
//            }
        }
        
        //写真を撮る時に表示
        .fullScreenCover(isPresented:$showCameraSheet){
            CameraView(image: $getUImage).ignoresSafeArea()
        }
        //画像を得た時
        .onChange(of: getUImage) {
            if let uiImage = getUImage, let pngData = uiImage.pngData() {
                inputYarnInfo.images.append(pngData)
            }
        }
//        .onChange(of:getUImage){
//            Task {
////                guard let getUImage = getUImage else { return }
//                if let uiImage = getUImage {
//                    inputYarnInfo.images.append(uiImage.pngData())
//                }
//            }
////            showImageCropper = true
//        }
        //得た画像を編集する時に表示
//        .sheet(isPresented: $showImageCropper) {
//            ImageCropper(image: self.$getUImage, visible: self.$showImageCropper, done: imageCropped)
//        }

    }
    private func checkButtonIsDisabled() {
        buttonIsDisabled = inputYarnInfo.name.isEmpty
    }

//    private func deleteMaterial(at offsets: IndexSet) {
//        print("deleteMaterial")
//        inputYarnMaterials.remove(atOffsets: offsets)
//    }

}

#Preview {
    YarnsEditView(
        inputYarnInfo: .constant(.init()),
        inputYarnMaterials: .constant([InputYarnMaterial()]),
//        inputYarnStocks: .constant([InputYarnStock()]),
        inputComplete: .constant(false),
        isEntry: true
    )
//        .modelContainer(previewFolderContainer)
    //        .environment(\.colorScheme, .dark)
//    ContentView()
//        .modelContainer(for: YarnInfo.self, inMemory: true)
    .modelContainer(previewYarn)
}
