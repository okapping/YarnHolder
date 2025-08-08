//
//  ScalableImageView.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/07/23.
//

//
//import SwiftUI
//
//struct SVGImage: UIViewControllerRepresentable {
//    let controller: Coordinator
//    
//    init(name: String) {
//        controller = Coordinator(name: name)
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        controller
//    }
//    
//    func makeUIViewController(context: UIViewControllerRepresentableContext<SVGImage>) -> UIViewController {
//        UIViewController()
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<SVGImage>) {
//        uiViewController.view = controller.imageView
//    }
//    
//    func scaledToFill() -> Self {
//        controller.contentMode(.scaleAspectFill)
//        return self
//    }
//    
//    func scaledToFit() -> Self {
//        controller.contentMode(.scaleAspectFit)
//        return self
//    }
//    
//    func renderingMode(_ renderingMode: Image.TemplateRenderingMode?) -> Self {
//        switch renderingMode {
//        case .original:
//            controller.renderingMode(.alwaysOriginal)
//        case .template:
//            controller.renderingMode(.alwaysTemplate)
//        default:
//            controller.renderingMode(.automatic)
//        }
//        return self
//    }
//    
//    func imageColor(_ color: Color) -> Self {
////        imageColor(color.uiColor())
//        imageColor(UIColor(color))
//    }
//    
//    func imageColor(_ color: UIColor) -> Self {
//        controller.imageColor(color)
//        return self
//    }
//    
//    class Coordinator {
//        let name: String
//        let imageView = UIImageView()
//        
//        init(name: String) {
//            self.name = name
//            imageView.image = UIImage(named: name)
//        }
//        
//        func contentMode(_ mode: UIView.ContentMode) {
//            imageView.contentMode = mode
//        }
//        
//        func renderingMode(_ renderingMode: UIImage.RenderingMode) {
//            imageView.image = imageView.image?.withRenderingMode(renderingMode)
//        }
//        
//        func imageColor(_ color: UIColor) {
//            imageView.tintColor = color
//            renderingMode(.alwaysTemplate)
//        }
//    }
//}
//
