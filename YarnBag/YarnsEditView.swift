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
    @Environment(\.locale) var locale
    @Query var folders: [Folder]
    
    @AppStorage("weightUnit") var weightUnit = "g"
    @AppStorage("lengthUnit") var lengthUnit = "m"

    
    @Binding var inputYarnInfo: InputYarnInfo
    @Binding var inputYarnMaterials: [InputYarnMaterial]
//    @Binding var inputYarnStocks: [InputYarnStock]
    @Binding var inputComplete: Bool
    @State private var buttonIsDisabled = true
    var isEntry: Bool
    var selectFolder: Folder? = nil
    
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
    @FocusState var focusName: Bool
    
    @State private var date = Date()
//    public func sortedYarns(from yarns: [YarnInfo]) -> [YarnInfo] {// KnittingNeedlesSize
    func dispNeedleSizeIndex(from needle: KnittingNeedlesSize) -> String {
        let code = locale.language.languageCode?.identifier ?? ""
        if code == "ja" {
            return needle.dispSizeJp
        } else {
            return needle.dispSizeDefault
        }
    }
    func dispNeedleSizeIndex(from needle: CrochetHookSize) -> String {
        let code = locale.language.languageCode?.identifier ?? ""
        if code == "ja" {
            return needle.dispSizeJp
        } else {
            return needle.dispSizeDefault
        }
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
    var body: some View {
        NavigationStack {
            List {
                // **********************************************
                // シンボル
//                Section (
//                    //                    header: ListTitleView(title: "シンボル")
//                ){
//                    NavigationLink{
//                        YarnSymbolsSelectView(selectSymbol: $inputYarnInfo.symbolId, selectColor: $inputYarnInfo.symbolColorName)
//                    } label: {
//                        HStack{
//                            Spacer()
//                            //                            Text("\(inputYarnInfo.symbolId)")
//                            createImageView(for: getYarnSymbol(by: inputYarnInfo.symbolId))
////                                .font(.largeTitle)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 60, height: 60)
//                                .foregroundColor(inputYarnInfo.symbolColor)
//                            Spacer()
//                        }
//                    }
//                }

                // **********************************************
                Section {
                    TextField("KEY_YARN_NAME", text: $inputYarnInfo.name)
                        .font(.title)
                        .padding(4)
                        .focused(self.$focusName)
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
                                Label("KEY_ADD", systemImage: "plus")
                                    .fontWeight(.bold)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                            .buttonBorderShape(.capsule)
//                            .tint(selectFolder?.color ?? .secondary)

                        }
                ){
                    if inputYarnInfo.images.isEmpty {
                        Text("KEY_NOT_REGISTERED")
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(inputYarnInfo.images.enumerated()), id: \.element) { index, image in
                                    Menu {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                deleteImage(index: index)
//                                                inputYarnInfo.images.remove(at: index)
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
//                                    .background(Color(UIColor.tertiarySystemFill))
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
//                                ListTitleButtonView(title: "KEY_ADD", color:inputYarnInfo.symbolColor)
                                Label("KEY_ADD", systemImage: "plus")
                                    .fontWeight(.bold)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                            .buttonBorderShape(.capsule)
//                            .tint(inputYarnInfo.symbolColor)
//                            .tint(selectFolder?.color ?? .secondary)

                        }
//                        .font(.title2)
                        
                ) {
//                    ForEach(yarnInfo.materials.sorted(by: { $0.orderIndex < $1.orderIndex })) {yarnMaterial in

//                    ForEach($inputYarnMaterials.sorted(by: { $0.orderIndex < $1.orderIndex })) { $yarnMaterial in
                    ForEach($inputYarnMaterials) { $yarnMaterial in
//                        ForEach(Array(inputYarnMaterials.enumerated()), id: \.element) { i, material in
                        HStack {
//                            Text("\(yarnMaterial.orderIndex)")
                            Picker("", selection: $yarnMaterial.materialId) {
                                ForEach(Materials, id: \.id) { material in
                                    let name = LocalizedStringKey(material.name)
                                    Text(name).tag(material.id as Int)
                                }
                            }
                            Divider()
                            HStack {
                                TextField("100", value: $yarnMaterial.percentage, format: .number)
                                    .frame(width : 80.0)
                                    .padding(5)
                                    .background(Color(UIColor.tertiarySystemFill))
                                    .cornerRadius(8)
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
                            .tint(.red)
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
                            .background(Color(UIColor.tertiarySystemFill))
                            .cornerRadius(8)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused(self.$focus)
                        Text("KEY_STITCHES")
                        TextField("00", value: $inputYarnInfo.standardGaugeRows, format: .number)
                            .frame(width : 40.0)
                            .padding(5)
                            .background(Color(UIColor.tertiarySystemFill))
                            .cornerRadius(8)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused(self.$focus)
                        Text("KEY_ROWS")
                    }
                    // 使用棒針
                    NavigationLink {
                        List{
                            Section(
                                footer:
                                    VStack(alignment: .leading){
                                        Text("KEY_REFERENCE_CIRCULAR_NEEDLE_SIZE")
                                        Grid {
                                            GridRow {
                                                Text("mm").fontWeight(.bold)
                                                Text("US").fontWeight(.bold)
                                                Text("UK").fontWeight(.bold)
                                                Text("JP").fontWeight(.bold)
                                            }
                                            ForEach(KnittingNeedlesSizes, id: \.id) { needle in
                                                GridRow {
                                                    Text(needle.mmSize) + Text("mm")
                                                    Text(needle.usSize != "" ? needle.usSize : "-")
                                                    Text(needle.ukSize != "" ? needle.ukSize : "-")
                                                    Text(needle.jpSize != "" ? needle.jpSize : "-")
                                                }
                                                Divider()
                                            }
                                        }
                                    }
                                    
                            ){
                                Picker("KEY_MIN_SIZE", selection: $inputYarnInfo.useKnittingNeedlesFrom) {
                                    ForEach(KnittingNeedlesSizes, id: \.id) { needle in
                                        Text(dispNeedleSizeIndex(from: needle)).tag(needle.id as Int?)
                                    }
                                }
                                Picker("KEY_MAX_SIZE", selection: $inputYarnInfo.useKnittingNeedlesTo) {
                                    ForEach(KnittingNeedlesSizes, id: \.id) { needle in
                                        Text(dispNeedleSizeIndex(from: needle)).tag(needle.id as Int?)
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
                                    if let needle = getKnittingNeedlesSize(by: from){
                                        Text(dispNeedleSizeLabel(from: needle))
                                            .foregroundColor(.accentColor)
                                    }
                                }
                                if inputYarnInfo.useKnittingNeedlesFrom != nil || inputYarnInfo.useKnittingNeedlesTo != nil{
                                    Image(systemName: "alternatingcurrent")
                                }
                                if let from = inputYarnInfo.useKnittingNeedlesTo{
                                    if let needle = getKnittingNeedlesSize(by: from){
                                        Text(dispNeedleSizeLabel(from: needle))
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
                                        Grid {
                                            GridRow {
                                                Text("mm").fontWeight(.bold)
                                                Text("US").fontWeight(.bold)
                                                Text("UK").fontWeight(.bold)
                                                Text("JP").fontWeight(.bold)
                                            }
                                            ForEach(CrochetHookSizes, id: \.id) { needle in
                                                GridRow {
                                                    Text(needle.mmSize) + Text("mm")
                                                    Text(needle.usSize != "" ? needle.usSize : "-")
                                                    Text(needle.ukSize != "" ? needle.ukSize : "-")
                                                    Text(needle.jpSize != "" ? needle.jpSize : "-")
                                                }
                                                Divider()
                                            }
                                        }
                                    }
                                
                            ){
                                Picker("KEY_MIN_SIZE", selection: $inputYarnInfo.useCrochetHookFrom) {
                                    ForEach(CrochetHookSizes/*.filter { !$0.number.isEmpty }*/, id: \.id) { needle in
                                        Text(dispNeedleSizeIndex(from: needle)).tag(needle.id as Int?)
                                    }
                                }
                                Picker("KEY_MAX_SIZE", selection: $inputYarnInfo.useCrochetHookTo) {
                                    ForEach(CrochetHookSizes/*.filter { !$0.number.isEmpty }*/, id: \.id) { needle in
                                        Text(dispNeedleSizeIndex(from: needle)).tag(needle.id as Int?)
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
                                    if let needle = getCrochetHookSize(by: from){
                                        Text(dispNeedleSizeLabel(from: needle))
                                            .foregroundColor(.accentColor)
                                    }
                                }
                                if inputYarnInfo.useCrochetHookFrom != nil || inputYarnInfo.useCrochetHookTo != nil {
                                    Image(systemName: "alternatingcurrent")
                                }
                                if let from = inputYarnInfo.useCrochetHookTo{
                                    if let needle = getCrochetHookSize(by: from){
                                        Text(dispNeedleSizeLabel(from: needle))
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
//                            .frame(width : 60.0)
//                            .padding(6)
//                            .background(Color(UIColor.systemGray4))
//                            .cornerRadius(5)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused(self.$focus)
                        Text(weightUnit)
                    }
                    // 長さ
                    HStack {
                        Text("KEY_LENGTH")
                        Spacer()
                        TextField("000", value: $inputYarnInfo.length, format: .number)
//                            .frame(width : 60.0)
//                            .padding(6)
//                            .background(Color(UIColor.systemGray4))
//                            .cornerRadius(5)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused(self.$focus)
                        Text(lengthUnit)
                    }
                }
//                if selectFolder != nil {
                Section {
                    Picker("KEY_FOLDER", selection: $inputYarnInfo.folder){
                        Text("KEY_UNSELECTED").tag(nil as Folder?)
                        ForEach(folders.sorted(by: { $0.orderIndex < $1.orderIndex })) {folder in
                            Text(folder.name).tag(folder)
                        }
                    }
                }
//                }
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
                            .foregroundColor(buttonIsDisabled ? .secondary : .blue) // ボタンの色を変更
                    }
                    .disabled(buttonIsDisabled)
                }
                ToolbarItem(placement: .keyboard){
                    HStack{
                        Spacer()
                        Button{
                            focus = false
                            focusName = false
                        }label: {
//                            Image(systemName: "keyboard.chevron.compact.down")
                            Text("KEY_DONE")
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
            if isEntry {
                self.focusName = true
            }
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
                    inputYarnInfo.images.append(data)
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
    
    private func deleteImage(index: Int) {
//        withAnimation {
        inputYarnInfo.images.remove(at: index)
//        }
    }

//    private func deleteMaterial(at offsets: IndexSet) {
//        print("deleteMaterial")
//        inputYarnMaterials.remove(atOffsets: offsets)
//    }

}

#Preview {
    @Previewable @State var inputYarnInfo: InputYarnInfo = .init()
    @Previewable @State var inputYarnMaterials: [InputYarnMaterial] = [.init()]
    @Previewable @State var inputComplete = false
    @Previewable @State var isEntry = true
    @Previewable @State var selectFolder: Folder? = Folder(orderIndex: 0, name: "テストフォルダ", colorName: selectColors.randomElement()! )

    NavigationStack {
        YarnsEditView(
            inputYarnInfo: $inputYarnInfo,
            inputYarnMaterials: $inputYarnMaterials,
            //        inputYarnStocks: .constant([InputYarnStock()]),
            inputComplete: $inputComplete,
            isEntry: isEntry,
            selectFolder: selectFolder
        )
        .modelContainer(previewYarn)
    }
//        .modelContainer(previewFolderContainer)
    //        .environment(\.colorScheme, .dark)
//    ContentView()
//        .modelContainer(for: YarnInfo.self, inMemory: true)
//    .modelContainer(previewYarn)
}

//#Preview{
//}
