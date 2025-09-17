//
//  SwatchesEditView.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/07/19.
//

import Foundation
import SwiftUI
import SwiftData
import AudioToolbox
import PhotosUI

struct SwatchesEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var inputSwatch: InputSwatch
    @Binding var inputComplete: Bool
    //    @State private var buttonIsDisabled = true
    @State var isEntry: Bool
    
    // 写真関連
    @State var selectedPhoto: PhotosPickerItem? = nil
    @State var selectedImage: UIImage? = nil
    @State var showPhotoSheet: Bool = false

    // 写真関連
    //UIImageに変換したアイテムを格納する
    @State var getUImage: UIImage?
    //トリミングされた画像があれば表示
//    @State var CreppedUImage: UIImage?
    //アルバムorカメラから画像が取得されれば、トリミングへ
    @State private var showImageCropper = false
    //カメラ表示
    @State var showCameraSheet: Bool = false

    
    //  フォーカス
    @FocusState var focus: Bool
    
    var body: some View {
        NavigationStack {
            List{
                //**********************************************
                Section (){
                    HStack {
                        Spacer()
                        if let imageData = inputSwatch.image {
                            if let uiImage = UIImage(data: imageData) {
                                Menu {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            inputSwatch.image = nil
                                            selectedPhoto = nil
                                        }
                                    } label: {
                                        Label("KEY_DELETE", systemImage: "trash")
                                    }
                                    .tint(.red)
                                } label:{
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 10)) // 角を丸くした四角形
                                        .frame(height:150)

                                }
//                                Image(uiImage: uiImage)
//                                    .resizable()
//                                    .scaledToFit()
//                                    .clipShape(RoundedRectangle(cornerRadius: 10)) // 角を丸くした四角形
//                                    .frame(height:150)
//                                    .contextMenu(menuItems: {
//                                        Button(role: .destructive) {
//                                            withAnimation {
//                                                inputSwatch.image = nil
//                                                selectedPhoto = nil
//                                            }
//                                        } label: {
//                                            Label("KEY_DELETE", systemImage: "trash")
//                                        }
//                                    })
                            }
                        } else {
                            ZStack{
                                Rectangle()
                                    .fill(Color(UIColor.tertiarySystemFill)) // 色を指定
                                    .frame(width: 150, height: 150) // サイズを指定
                                    .cornerRadius(10)
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.primary)
                            }

                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    HStack {
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
                            if inputSwatch.image != nil {
                                Label("KEY_CHANGE_IMAGE", systemImage: "plus")
                                    .fontWeight(.bold)
//                                ListTitleButtonView(title: "KEY_CHANGE_IMAGE")
                            } else {
                                Label("KEY_ADD_IMAGE", systemImage: "plus")
                                    .fontWeight(.bold)
//                                ListTitleButtonView(title: "KEY_ADD_IMAGE")
                            }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .buttonBorderShape(.capsule)

                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
                //**********************************************
                Section(
//                    header: ListTitleView(title: "基本情報")
                ){
                    Picker("EY_NEEDLE_TYPE", selection: $inputSwatch.needleType) {
                        Text("KEY_KNITTING_NEEDLE").tag(0)
                        Text("KEY_HOOK").tag(1)
                        Text("KEY_OTHER").tag(9)
                    }
                    if inputSwatch.needleType == 0 {
                        Picker("KEY_NEEDLE_SIZE", selection: $inputSwatch.needleSize) {
                            ForEach(KnittingNeedlesSizes, id: \.id) { needle in
                                Text(needle.dispSizeJp).tag(needle.id as Int)
                            }
                        }
                    } else if inputSwatch.needleType == 1 {
                        Picker("KEY_NEEDLE_SIZE", selection: $inputSwatch.needleSize) {
                            ForEach(CrochetHookSizes/*.filter { !$0.number.isEmpty }*/, id: \.id) { needle in
                                Text(needle.dispSizeJp).tag(needle.id as Int)
                            }
                        }
                    } else if inputSwatch.needleType == 9 {
                        HStack {
                            Text("KEY_NEEDLE_SIZE")
                            Spacer()
                            TextField("00", value: $inputSwatch.needleSize, format: .number)
                                .frame(width : 80.0)
                                .padding(5)
                                .background(Color(UIColor.tertiarySystemFill))
                                .cornerRadius(5)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .focused(self.$focus)
                        }
                    }
                    HStack {
                        Text("KEY_STITCH_COUNT")
                        Spacer()
                        TextField("00", value: $inputSwatch.stitches, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .focused(self.$focus)
                    }
                    HStack {
                        Text("KEY_ROW_COUNT")
                        Spacer()
                        TextField("00", value: $inputSwatch.rows, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .focused(self.$focus)
                    }
                    HStack {
                        Text("KEY_WEIGHT")
                        Spacer()
                        TextField("00", value: $inputSwatch.weight, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .focused(self.$focus)
                    }

                }
            }
            .navigationTitle(isEntry ? "KEY_ADD_SWATCH" : "KEY_EDIT_SWATCH")
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
                        }label: {
//                            Image(systemName: "keyboard.chevron.compact.down")
                            Text("KEY_DONE")
                        }
                    }
                }
                
            }

        }
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
            //            selection: $getUImage,
            selection: $selectedPhoto,
            //                        maxSelectionCount: 5,
            //                        selectionBehavior: .ordered,
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: selectedPhoto){
            Task {
                guard let data = try await selectedPhoto?.loadTransferable(type: Data.self) else { return }
                guard let uiImage = UIImage(data:data) else {return}
                selectedPhoto = nil
                getUImage = uiImage
//                withAnimation {
//                    inputSwatch.image = data
//                }
            }
        }

        //写真を撮る時に表示
        .fullScreenCover(isPresented:$showCameraSheet){
            CameraView(image: $getUImage).ignoresSafeArea()
        }
        //画像を得た時
        .onChange(of:getUImage){
            showImageCropper = true
        }
        //得た画像を編集する時に表示
        .sheet(isPresented: $showImageCropper) {
            ImageCropper(image: self.$getUImage, visible: self.$showImageCropper, done: imageCropped)
        }
    }
    //トリミングが終わった後に呼ばれる
    func imageCropped(image: UIImage){
//        CreppedUImage = image
        withAnimation {
//            guard let uiImage = uiImage else { return }
//            imageData = image.pngData()
            inputSwatch.image = image.pngData()
        }
    }
}

#Preview {
    SwatchesEditView(inputSwatch: .constant(.init()),inputComplete: .constant(false), isEntry: true)
//    SwatchesEditView(inputSwatch: .constant(.init()))
}
