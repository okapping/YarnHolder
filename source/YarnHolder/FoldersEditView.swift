//
//  FoldersEditView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/08/12.
//

import SwiftUI
import Flow

struct FoldersEditView: View {
    //    @Environment(\.modelContext) var context
    //    @Query private var tags: [Tag]
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var inputFolder: InputFolder
    @Binding var inputComplete: Bool
    @State var isEntry: Bool
    
    @State private var buttonIsDisabled = true
    
    @FocusState var focus: Bool
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Spacer()
                    Image(systemName: "folder.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
//                        .foregroundColor(inputFolder.color)
                        .foregroundColor(Color(inputFolder.colorName))
                        .symbolEffect(.bounce, value: inputFolder.colorName)
                    Spacer()
                }
                .listRowBackground(Color.clear)
                Section {
                    TextField("KEY_NAME", text: $inputFolder.name)
                        .font(.title)
                        .padding(4)
                        .multilineTextAlignment(.center)
                        .focused(self.$focus)
                }
                Section{
                    HFlow(spacing: 8, justified: true){
                        ForEach(selectColors, id: \.self){ colorName in
                            ZStack {
                                Circle()
                                    .foregroundColor(Color(colorName))
                                    .frame(width: 44, height: 44)
                                if inputFolder.colorName == colorName {
                                    Circle()
                                        .foregroundColor(Color(UIColor.systemBackground))
                                        .frame(width: 18, height: 18)
                                }
                            }
                            .onTapGesture {
                                inputFolder.colorName = colorName
                            }
                        }
                    }
                }

            }
            .navigationTitle(isEntry ? "KEY_NEW_FOLDER" : "KEY_FOLDER_INFO")
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
            .onChange(of: inputFolder.name) { _, _ in
                checkButtonIsDisabled()
            }
            
            
        }
        .onAppear{
            checkButtonIsDisabled()
            self.focus = true
        }
        
    }
    private func checkButtonIsDisabled() {
        buttonIsDisabled = inputFolder.name.isEmpty
    }
    
}

#Preview{
//    FoldersEditView()
}
