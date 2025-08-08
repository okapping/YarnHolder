//
//  StocksEditView.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/04/10.
//

import Foundation
import SwiftUI
import SwiftData
import AudioToolbox
import PhotosUI

struct StocksEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var inputYarnStock: InputYarnStock
//    @Binding var inputYarnMaterials: [InputYarnMaterial]
    @Binding var inputComplete: Bool
//    @State private var buttonIsDisabled = true
    @State var isEntry: Bool
    
    // 色見本関連
    @State private var selectedColor: Color = .gray
//    @State private var showColorPicker = false

    // 在庫状況関連
    @State private var isPlusButtonPressed: Bool = false
    @State private var isMinusButtonPressed: Bool = false
    //  フォーカス
    @FocusState var focus: Bool
    
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

    
    var body: some View {
        NavigationStack {
            List{
                Section (){
                    HStack {
                        Spacer()
                        if let imageData = inputYarnStock.image {
                            if let uiImage = UIImage(data: imageData) {
                                Menu {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            inputYarnStock.image = nil
                                            selectedPhoto = nil
                                        }
                                    } label: {
                                        Label("KEY_DELETE", systemImage: "trash")
                                    }
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
                                //                                                inputYarnStock.image = nil
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
                                    .fill(Color.gray.opacity(0.2)) // 色を指定
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
                            if inputYarnStock.image != nil {
                                ListTitleButtonView(title: "KEY_CHANGE_IMAGE")
                            } else {
                                ListTitleButtonView(title: "KEY_ADD_IMAGE")
                            }
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }

                Section(header: Text("KEY_BASIC_INFO")) {
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
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black.opacity(0.3), lineWidth: 0.5)
                            )
                    }
                    HStack {
                        Text("KEY_COLOR_CODE")
                        Spacer()
                        TextField("00", text: $inputYarnStock.colorCode)
                            .multilineTextAlignment(.trailing)
                            .focused(self.$focus)
                    }
                    HStack {
                        Text("KEY_LOT_NUMBER")
                        Spacer()
                        TextField("AB00", text: $inputYarnStock.lotNumber)
                            .multilineTextAlignment(.trailing)
                            .focused(self.$focus)
                    }

                    
                }
                Section(header: Text("KEY_STOCK_INFO")) {
                    HStack {
                        Text("KEY_STOCK_QUANTITY")
                        Spacer()
                        Button {
                            UISelectionFeedbackGenerator().selectionChanged()
                            inputYarnStock.inventory -= 1
                        } label: {
                            Image(systemName: "minus.square.fill")
                                .font(.title)
                                .symbolRenderingMode(.multicolor)
                        }
                        .padding(.horizontal, 20)
                        .buttonStyle(.plain)
                        .disabled(inputYarnStock.inventory == 0)
                        //                        .symbolEffect(.bounce.down.byLayer, options: .nonRepeating, value: isMinusButtonPressed)
                        Text(String(inputYarnStock.inventory))
                            .font(.title2)
                        Button {
                            UISelectionFeedbackGenerator().selectionChanged()
                            inputYarnStock.inventory += 1
                        } label: {
                            Image(systemName: "plus.square.fill")
                                .font(.title)
                                .symbolRenderingMode(.multicolor)
                        }
                        .padding(.horizontal, 20)
                        .buttonStyle(.plain)
                        //                        .symbolEffect(.bounce.up.byLayer, options: .nonRepeating, value: isPlusButtonPressed)
                    }
                }
                Section() {
                    TextField("KEY_MEMO",
                              text: $inputYarnStock.memo,
                              axis: .vertical
                    )
                    .focused(self.$focus)
                }
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
//                            .foregroundColor(buttonIsDisabled ? .gray : .blue) // ボタンの色を変更
                    }
//                    .disabled(buttonIsDisabled)
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
            inputYarnStock.image = image.pngData()
        }
    }

}
#Preview {
    StocksEditView(inputYarnStock: .constant(.init()),inputComplete: .constant(false), isEntry: true)
}

