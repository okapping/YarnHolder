//
//  ImagePreviewView.swift
//  YarnHolder
//
//  Created by 岡山直也 on 2026/03/21.
//

import SwiftUI
import Zoomable

struct ImagePreviewView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var imageData: Data?
    @Binding var sourceId: String
    var namespace: Namespace.ID
    var body: some View {
        if let data = imageData, let uiImage = UIImage(data: data){
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .navigationTransition(.zoom(sourceID: sourceId, in: namespace))
                .zoomable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            //                .background{
            //                    Color(UIColor.systemBackground)
            //                }
                .overlay{
                    Button{
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                        //                                .foregroundColor(.white)
                            .symbolRenderingMode(.hierarchical)
                    }
                    .modifier{ content in
                        if #available(iOS 26.0, *) {
                            content.glassEffect()
                        } else {
                            content
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                }
        }
        
    }
}
