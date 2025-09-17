//
//  TagsEditView.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/07/28.
//

import Foundation
import SwiftUI
import SwiftData

//struct TagsEditView: View {
//    @Binding var selectTags: [Tag]
//    var body: some View {
//        NavigationStack {
//            TagsSelectView(selectTags: $selectTags)
//        }
//    }
//}
struct TagsEditView: View {
//    @Environment(\.modelContext) var context
//    @Query private var tags: [Tag]
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var inputTag: InputTag
    @Binding var inputComplete: Bool
    @State var isEntry: Bool

    @State private var buttonIsDisabled = true
    
    @FocusState private var focus

    var body: some View {
        NavigationStack {
            List {
//                HStack {
//                    Spacer()
//                    Image(systemName: "tag.fill")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 60, height: 60)
//                        .foregroundColor(inputTag.color)
//                        
//                    Spacer()
//                }
//                .listRowBackground(Color.clear)
                Section {
                    TextField("KEY_NAME", text: $inputTag.name)
                        .font(.title)
                        .padding(4)
                        .multilineTextAlignment(.center)
                        .focused(self.$focus)
                }
                Section {
                    HStack {
                        Text("KEY_COLOR")
                        Spacer()
                        ColorPicker("", selection: $inputTag.color, supportsOpacity: false)
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

                }
            }
//            .navigationTitle(isEntry ? "KEY_ADD_TAG" : "KEY_EDIT_TAG")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("\(Image(systemName: "number"))\(inputTag.name)")
                            .fontWeight(.bold)
                            .foregroundColor(inputTag.color.isLight ? .black : .white)
                    }
                    .font(.footnote)
                    .padding(6)
                    .background(inputTag.color)
                    .cornerRadius(12)
                }
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
//                ToolbarItem(placement: .keyboard){
//                    HStack{
//                        Spacer()
//                        Button{
//                            focus = false
//                        }label: {
//                            Image(systemName: "keyboard.chevron.compact.down")
//                Text("KEY_DONE")
//                        }
//                    }
//                }
                
            }
            .onChange(of: inputTag.name) { _, _ in
                checkButtonIsDisabled()
            }


        }
        .onAppear{
            checkButtonIsDisabled()
            self.focus = true
        }

    }
    private func checkButtonIsDisabled() {
        buttonIsDisabled = inputTag.name.isEmpty
    }

}
#Preview {
    TagsEditView(inputTag: .constant(.init()), inputComplete: .constant(false), isEntry: true)
}

