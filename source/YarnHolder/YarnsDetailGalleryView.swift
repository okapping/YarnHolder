//
//  YarnsDetailGalleryView.swift
//  YarnHolder
//
//  Created by 岡山直也 on 2026/02/26.
//


import SwiftUI
import Flow
import PhotosUI
import ImageIO
import Zoomable

@Observable class CameraPhotoPickerModel {
    // 写真関連
    // 最初のきっかけ
    var showPhotoSheet: Bool = false
    var showCameraSheet: Bool = false
    
    // PhotoPickerで選択した画像
    var selectedPhoto: PhotosPickerItem? = nil
    // カメラから取得、もしくはPhotoPickerで取得したPhotosPickerItemを
    // UIImageに変換したものを格納する
    var getUImage: UIImage? = nil
    //アルバムorカメラから画像が取得されれば、トリミングへ
    var showImageCropper = false
}
@Observable class ImagePreviewModel {
    var image: Data?
    var showSheet: Bool = false
    var sourceId: String = ""
}
extension UIImage {
    func rotated(by radians: CGFloat) -> UIImage {
        // 回転後のサイズを計算
        let rotatedSize = CGRect(
            origin: CGPoint.zero,
            size: self.size
        ).applying(CGAffineTransform(rotationAngle: radians)).size
        
        // UIGraphicsを用いて描画
        UIGraphicsBeginImageContext(rotatedSize)
        let context = UIGraphicsGetCurrentContext()!
        
        // 回転の中心を移動
        context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        context.rotate(by: radians)
        
        // 元の画像を描画
        context.translateBy(x: -self.size.width / 2, y: -self.size.height / 2)
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        
        // 新しい画像を取得
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }
    
    func flippedHorizontally() -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()!
        
        // 左右反転
        context.translateBy(x: self.size.width, y: 0)
        context.scaleBy(x: -1, y: 1)
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        
        let flippedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return flippedImage
    }
    
    func flippedVertically() -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()!
        
        // 上下反転
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1, y: -1)
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        
        let flippedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return flippedImage
    }
}

struct ResizedImage: View {
    var data: Data
    
    var body: some View {
        if let uIImage = UIImage(data: data) {
            //        if let downSampledImage = resizeImage(data) {
            Image(uiImage: uIImage)
                .resizable()
                .scaledToFill()
        }
    }
    
    private func resizeImage(_ data: Data) -> UIImage? {
        let maxPixelSize: CGFloat = 1024
        // CGDataProviderを作成
        guard let provider = CGDataProvider(data: data as CFData) else {
            return nil
        }
        
        // CGImageSourceを作成
        guard let imageSource = CGImageSourceCreateWithDataProvider(provider, nil) else {
            return nil
        }
        
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
            kCGImageSourceShouldCacheImmediately: true
        ]
        
        // CGImageを取得 (インデックス0の画像を取得)
        guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, options as CFDictionary) else {
            //            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            return nil
        }
        
        // Exifメタデータから向きを取得
        let orientation = getOrientationFromData(data: data)
        print("向き1: \(orientation)")
        // UIImageを作成し、orientationを考慮して返す
        let image = UIImage(cgImage: cgImage)
        //        return image
        return fixImageOrientation(image: image, orientation: orientation)
        
        return UIImage(cgImage: cgImage, scale: 1, orientation: orientation)
        //        return UIImage(cgImage: cgImage)
        
    }
    private func getOrientationFromData(data: Data) -> UIImage.Orientation {
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
            return .up
        }
        
        if let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any],
           let orientationValue = properties[kCGImagePropertyOrientation as String] as? NSNumber {
            return UIImage.Orientation(rawValue: orientationValue.intValue) ?? .up
        }
        return .up
    }
    
    private func fixImageOrientation(image: UIImage, orientation: UIImage.Orientation) -> UIImage {
        guard orientation != .up else {
            return image // 向きが正常な場合
        }
        
        // 向きに基づいて回転や反転処理
        var rotatedImage: UIImage = image
        
        // 向きごとの処理
        switch orientation {
        case .up:
            break  // 正常
        case .down:
            rotatedImage = image.rotated(by: .pi)// 180度回転
        case .left:
            rotatedImage = image.rotated(by: -.pi / 2)// 左90度回転
        case .right:
            rotatedImage = image.rotated(by: .pi / 2) // 右90度回転
        case .upMirrored:
            rotatedImage = image.flippedHorizontally()// 上反転
        case .downMirrored:
            rotatedImage = image.flippedVertically() // 下反転
        case .leftMirrored:
            rotatedImage = image.rotated(by: -.pi / 2).flippedHorizontally()// 左90度回転して反転
        case .rightMirrored:
            rotatedImage = image.rotated(by: .pi / 2).flippedHorizontally() // 右90度回転して反転
        default:
            break
        }
        
        return rotatedImage
    }
    
}
extension Data {
    var uniqueID: UUID {
        return UUID() // ランダムなUUIDを生成
    }
}

struct ImageData: Identifiable {
    let id = UUID() // 一意のID
    let data: Data // 画像データ
}

struct YarnsDetailGalleryView: View {
    @Environment(\.modelContext) private var modelContext
    //    var yarn: YarnInfo
    @Environment(YarnInfo.self) var yarn
    
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    // 画像拡大用（つかってない）
    //    @State private var showFullImage = false
    //    @State private var showImages: [showImageContainer] = []
    //    @State private var showImageIndex: Int = 0
    
    @State private var ipModel:ImagePreviewModel = .init()
    //    @State private var showImagePreviewImage: Data?
    //    @State private var showImagePreviewSheet: Bool = false
    //    @State private var showImagePreviewSourceId: String = ""
    @Namespace private var namespace
    
    @State private var cppModel: CameraPhotoPickerModel = .init()
    
    @State private var infoImageDatas: [ImageData] = []
    @State private var stocksImageDatas: [[ImageData]] = []
    
    private func deleteLastImage(){
        withAnimation{
            yarn.images.removeLast()
            try? modelContext.save()
        }
    }
    //    let strings: [String] = ["うなぎ", "うなぎ", "うなぎ", "うなぎ", "うなぎ"]
    
    init(){
        //        self.yarn = yarn
        //        self._infoImageDatas = State(initialValue: yarn.images.map { ImageData(data: $0) })
        //        self._stocksImageDatas = State(initialValue: yarn.stocks?.sorted(by: { $0.orderIndex < $1.orderIndex }).map { stock in
        //            stock.images.map { ImageData(data: $0) }
        //        } ?? [])
    }
    var body: some View {
        ScrollView{
            //            Button("削除"){
            //                if !yarn.images.isEmpty{
            //                    deleteLastImage()
            //                }
            //            }
            //            LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
            //                ForEach(strings, id: \.self) { string in
            //                    Rectangle()
            //                        .fill(Color.gray)
            //                        .aspectRatio(1, contentMode: .fit)
            //                        .overlay(
            //                            Text(string)
            //                        )
            //                }
            //            }
            LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                ForEach(Array(infoImageDatas.enumerated()), id: \.element.id) { i, image in
                    //                    ForEach(Array(yarn.images.enumerated()), id: \.element.hashValue) { i, image in
                    RoundedRectangle(cornerRadius: 10)
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(
                            ResizedImage(data: image.data)
                        )
                        .clipShape(.rect(cornerRadius: 10))
                        .matchedGeometryEffect(id: "\(image.id)", in: namespace)
                        .matchedTransitionSource(id: "\(image.id)", in: namespace)
                        .contextMenu{
                            Button(role: .destructive){
                                withAnimation{
                                    infoImageDatas.remove(at: i)
                                    yarn.images.remove(at: i)
                                    try? modelContext.save()
                                }
                            } label: {
                                Label("KEY_DELETE", systemImage: "trash.fill")
                            }
                        }
                        .onTapGesture {
                            ipModel.sourceId = "\(image.id)"
                            ipModel.image = image.data
                            ipModel.showSheet = true
                        }
                }
                //
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.25))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        Menu {
                            // カメラ表示
                            Button{
                                cppModel.showCameraSheet = true
                            }label:{
                                Label("KEY_CAMERA", systemImage: "camera")
                            }
                            // アルバム表示
                            Button{
                                cppModel.showPhotoSheet = true
                            }label:{
                                Label("KEY_ALBUM", systemImage: "photo.on.rectangle.angled")
                            }
                        } label: {
                            Image(systemName: "plus")
                                .font(Font.largeTitle.bold())
                                .foregroundStyle(.secondary)
                        }
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    )
            }
            .padding()
            // 次の行
            if let wrappedStocks = yarn.stocks{
                ForEach(Array(wrappedStocks.sorted(by: { $0.orderIndex < $1.orderIndex }).enumerated()), id: \.element) {i, stock in
                    if !stock.images.isEmpty {
                        HStack(alignment: .lastTextBaseline){
                            RoundedRectangle(cornerRadius: 10)
                                .fill(stock.sampleColor.color)
                                .frame(width: 30, height:30)
                            VStack(alignment: .leading) {
                                Text("KEY_COLOR_CODE")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(stock.colorCode)
                            }
                            Text(" / ")
                            VStack(alignment: .leading) {
                                Text("KEY_LOT_NUMBER")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(stock.lotNumber)
                            }
                        }
                        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                            if stocksImageDatas.indices.contains(i) {
                                ForEach(Array(stocksImageDatas[i].enumerated()), id: \.element.id) { j, image in
                                    //                                ForEach(Array(stock.images.enumerated()), id: \.element) { j, image in
                                    RoundedRectangle(cornerRadius: 10)
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay(
                                            ResizedImage(data: image.data)
                                        )
                                        .clipShape(.rect(cornerRadius: 10))
                                        .matchedGeometryEffect(id: "\(image.id)", in: namespace)
                                        .matchedTransitionSource(id: "\(image.id)", in: namespace)
                                    // 2026/03/26 削除機能は保留（めんどい）
                                    //                                    .contextMenu{
                                    //                                        Button(role: .destructive){
                                    //                                            withAnimation{
                                    //                                                stocksImageDatas[i].remove(at: j)
                                    //                                                yarn.stocks[i].images.remove(at: j)
                                    //                                                try? modelContext.save()
                                    //                                            }
                                    //                                        } label: {
                                    //                                            Label("KEY_DELETE", systemImage: "trash.fill")
                                    //                                        }
                                    //                                    }
                                        .onTapGesture {
                                            ipModel.sourceId = "\(image.id)"
                                            ipModel.image = image.data
                                            ipModel.showSheet = true
                                        }
                                }
                                
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear{
            infoImageDatas = yarn.images.map { ImageData(data: $0) }
            stocksImageDatas = yarn.stocks?.sorted(by: { $0.orderIndex < $1.orderIndex }).map { stock in
                stock.images.map { ImageData(data: $0) }
            } ?? []
            
            print("stocksImageDatas = {\(stocksImageDatas)}")
        }
        .photosPicker (
            isPresented: $cppModel.showPhotoSheet,
            //            selection: $getUImage,
            selection: $cppModel.selectedPhoto,
            //                        maxSelectionCount: 5,
            //                        selectionBehavior: .ordered,
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: cppModel.selectedPhoto){
            Task {
                guard let data = try await cppModel.selectedPhoto?.loadTransferable(type: Data.self) else { return }
                guard let uiImage = UIImage(data:data) else {return}
                cppModel.selectedPhoto = nil
                cppModel.getUImage = uiImage
            }
        }
        
        //写真を撮る時に表示
        .fullScreenCover(isPresented:$cppModel.showCameraSheet){
            CameraView(image: $cppModel.getUImage).ignoresSafeArea()
        }
        //画像を得た時
        .onChange(of:cppModel.getUImage){
            // トリミングへ
            //            cppModel.showImageCropper = true
            // トリミングせずに保存
            if let uiImage = cppModel.getUImage, let imageData = uiImage.jpegData(compressionQuality: 0.3) {
                withAnimation{
                    yarn.images.append(imageData)
                    try? modelContext.save()
                    infoImageDatas.append(ImageData(data: imageData))
                }
            }
        }
        //得た画像を編集する時に表示
        //        .sheet(isPresented: $cppModel.showImageCropper) {
        //            ImageCropper(image: self.$cppModel.getUImage, visible: self.$cppModel.showImageCropper, done: cppModel.imageCropped)
        //        }
        .fullScreenCover(isPresented:$ipModel.showSheet){
            ImagePreviewView(imageData: $ipModel.image, sourceId: $ipModel.sourceId, namespace: namespace)
        }
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(previewYarn)
//}
//struct ContextMenuSmp: View {
//    @State private var toggle = true
//    @State private var showSheet = false
//
//    var body: some View {
//
//        Image(toggle ? "test.stock" : "test.swatch")
//            .resizable()
//            .scaledToFill()
//            .frame(width: 200, height: 200)
//            .contextMenu {
//                // ボタンでトグルの状態を変更する
//                Button {
//                    toggle.toggle()
//                } label: {
//                    Label("画像切り替え", systemImage: "rectangle.2.swap")
//                }
////            } preview: {
//                // toggleの状態によって画像を切り替える
////                Image(toggle ? "test.stock" : "test.swatch")
//            }
//            .onTapGesture {
//                showSheet.toggle()
//            }
////        Menu {
////            Button {
////                withAnimation{
////                    toggle.toggle()
////                }
////            } label: {
////                Label("画像切り替え", systemImage: "rectangle.2.swap")
////            }
////        } label: {
////            Image(toggle ? "test.stock" : "test.swatch")
////                .resizable()
////                .scaledToFill()
////                .frame(width: 200, height: 200)
////        } primaryAction: {
////            withAnimation{
////                showSheet.toggle()
////            }
////        }
//        .fullScreenCover(isPresented:$showSheet){
//            Image(toggle ? "test.stock" : "test.swatch")
//            Button {
//                showSheet.toggle()
//            } label: {
//                Label("とじる", systemImage: "rectangle.2.swap")
//            }
//        }
//    }
//}
//#Preview {
//    ContextMenuSmp()
//}
