//
//  TagsSelectView.swift
//  ItomakiKeitoKun
//
//  Created by 岡山直也 on 2025/07/17.
//


import Foundation
import SwiftUI
import SwiftData

struct TagsSelectView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var tags: [Tag]
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selectTags: [Tag]
    @State private var showAddTagAlert: Bool = false
    @State private var showEditTagAlert: Bool = false
    @State private var inputTagName = ""
    @State private var editTag: Tag? = nil
    @State private var inputTag: InputTag = .init()

    @Binding var inputComplete: Bool
    
    @State private var showTagEditSheet = false
    @State private var tagEditViewComplete: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(tags) { tag in
                        HStack {
                            Image(systemName: selectTags.contains(tag) ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Image(systemName: "tag.fill")
                                .font(.title3)
                                .foregroundColor(tag.color.color)
                            Text(tag.name)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if let index = selectTags.firstIndex(of: tag) {
                                selectTags.remove(at:index)
                            } else {
                                selectTags.append(tag)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            // スワイプ＞削除
                            Button(role: .destructive) {
                                if let index = selectTags.firstIndex(of: tag) {
                                    selectTags.remove(at:index)
                                }
                                deleteTag(deleteTag: tag)
                            } label: {
                                Label("KEY_DELETE", systemImage: "trash.fill")
                            }
                            .tint(.red)
                            // スワイプ＞更新
                            Button {
                                editTag = tag
                                inputTagName = tag.name
                                showEditTagAlert = true
                            } label: {
                                Label("KEY_EDIT", systemImage: "rectangle.and.pencil.and.ellipsis")
                            }
                            .tint(.orange)
                        }
                        
                    }
                }
            }
            .navigationTitle(Text("KEY_TAG_SELECTION"))
            .toolbarTitleDisplayMode(.inline)
            //        .scrollContentBackground(.hidden)
            //        .background(ColorManager.listBackground) // 背景色を設定
            .toolbar {
                //                ToolbarItemGroup {
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
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button {
                        showTagEditSheet = true
                        //                        showAddTagAlert = true
                    } label: {
                        Label("KEY_ADD", systemImage: "plus.square")
                    }
                    //                    .alert("新規タグ", isPresented: $showAddTagAlert) {
                    //                        TextField("名前", text: $inputTagName)
                    //                        Button("保存"){
                    //                            addTag()
                    //                        }
                    //                        Button("KEY_CANCEL", role: .cancel){
                    //                            inputTagName = ""
                    //                        }
                    //                    } message: {
                    //                        Text("タグの名前を入力します。")
                    //                    }
                }
            }

//            .alert("タグ編集", isPresented: $showEditTagAlert) {
//                TextField("タグ名の編集", text: $inputTagName)
//                Button("保存"){
//                    if let tag = editTag {
//                        tag.name = inputTagName
//                    }
//                    try? modelContext.save()
//                    inputTagName = ""
//                }
//                Button("KEY_CANCEL", role: .cancel){
//                    inputTagName = ""
//                }
//            } message: {
//                Text("タグの名前を変更します。")
//            }
            // タグ新規作成シート
            .sheet(isPresented: $showTagEditSheet, onDismiss: {
                addTag()
            }, content: {
                TagsEditView(
                    inputTag: $inputTag,
                    inputComplete: $tagEditViewComplete,
                    isEntry: true
                )
            })
        }
    }
//    private func addTag() {
//        defer {
//            inputTagName = ""
//        }
//        //
//        if inputTagName.isEmpty {
//            return
//        }
//        let newTag = Tag(name:inputTagName)
//        //        let tagService = TagService(context: context)
//        //        tagService.addTag(tag: newTag)
//        print("new tag = \(inputTagName)")
//        modelContext.insert(newTag)
//    }
    private func addTag() {
        defer {
            inputTag = .init()
            tagEditViewComplete = false
        }
        //
        if !tagEditViewComplete {
            return
        }
        
        withAnimation {
            let colorComponents = ColorComponents.fromColor(inputTag.color)
            
            let newTag = Tag(
                name: inputTag.name,
                color: colorComponents
            )
            modelContext.insert(newTag)
        }

//        let newTag = Tag(name:inputTagName)
        //        let tagService = TagService(context: context)
        //        tagService.addTag(tag: newTag)
//        print("new tag = \(inputTagName)")
//        context.insert(newTag)
    }

    private func deleteTag(deleteTag: Tag) {
//        let tagService = TagService(context: context)
//        tagService.deleteTag(tag: deleteTag)
        modelContext.delete(deleteTag)
    }
}

//#Preview {
//    TagsSelectView(selectTags: .constant([.init()]), inputComplete: .constant(false))
//    TagsSelectView(selectTags: .constant([.init()]), inputComplete: .constant(false))
//        .modelContainer(previewYarn)
//}
