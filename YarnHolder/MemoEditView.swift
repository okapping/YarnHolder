//
//  MemoEditView.swift
//  YarnHolder
//
//  Created by 岡山直也 on 2026/04/23.
//


//
//  MemoEditView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/07/19.
//

import SwiftUI

struct MemoEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var inputMemo: String
    @Binding var inputComplete: Bool
    
    //  フォーカス
    @FocusState var focus: Bool
    
    var body: some View {
        NavigationStack {
            List{
                //**********************************************
//                **********************************************
                Section {
                    TextField("KEY_MEMO",
                              text: $inputMemo,
                              axis: .vertical
                    )
                    .frame(maxHeight: .infinity)
                    .focused(self.$focus)
                }
            }
            .navigationTitle("KEY_EDIT")
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
                    }
                }
                ToolbarItem(placement: .keyboard){
                    HStack{
                        Spacer()
                        Button{
                            focus = false
                        }label: {
                            Text("KEY_DONE")
                        }
                    }
                }
                
            }
        }
        .onAppear{
            focus = true
        }
    }
}

#Preview {
    MemoEditView(inputMemo: .constant(""),inputComplete: .constant(false))
}
