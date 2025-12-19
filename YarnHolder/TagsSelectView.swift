//
//  TagsSelectView.swift
//  YarnStocker
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
    @State private var tmpEditTag: Tag? = nil
    @State private var inputTag: InputTag = .init()

    @Binding var inputComplete: Bool
    
    @State private var showTagAddSheet = false
    @State private var showTagEditSheet = false
    @State private var tagEditViewComplete: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(tags.sorted(by: { $0.orderIndex < $1.orderIndex })) { tag in
                        HStack {
                            Image(systemName: selectTags.contains(tag) ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                                .foregroundColor(.blue)
                            TaglabelView(tag: tag)
//                            Image(systemName: "number.circle.fill")
//                                .font(.title3)
//                                .foregroundColor(tag.color.color)
//                            Text(tag.name)
                            Spacer()
//                            Text("\(tag.orderIndex)")
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
                                tmpEditTag = tag
                                inputTag.name = tag.name
                                inputTag.color = tag.color.color
                                showTagEditSheet = true
                            } label: {
                                Label("KEY_EDIT", systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                        
                    }
                    .onMove(perform: moveTag)
                }
            }
            .navigationTitle("KEY_TAG_SELECTION")
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
                        showTagAddSheet = true
                        //                        showAddTagAlert = true
                    } label: {
                        Label("KEY_ADD", systemImage: "plus.square")
                    }
                }
            }

            // タグ新規作成シート
            .sheet(isPresented: $showTagAddSheet, onDismiss: {
                addTag()
            }, content: {
                TagsEditView(
                    inputTag: $inputTag,
                    inputComplete: $tagEditViewComplete,
                    isEntry: true
                )
            })
            // タグ編集シート
            .sheet(isPresented: $showTagEditSheet, onDismiss: {
                editTag()
            }, content: {
                TagsEditView(
                    inputTag: $inputTag,
                    inputComplete: $tagEditViewComplete,
                    isEntry: false
                )
            })
        }
    }
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
                orderIndex: tags.count,
                name: inputTag.name,
                color: colorComponents
            )
            modelContext.insert(newTag)
        }
    }
    private func editTag() {
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
            
            if let tag = tmpEditTag {
                tag.name = inputTag.name
                tag.color = colorComponents
            }
            try? modelContext.save()
        }
    }
    private func moveTag(from source: IndexSet, to destination: Int) {
        var updatedTags = tags.sorted(by: { $0.orderIndex < $1.orderIndex })
        updatedTags.move(fromOffsets: source, toOffset: destination)
        withAnimation {
            for (index, item) in updatedTags.enumerated() {
                item.orderIndex = index
            }
            try? modelContext.save()
        }
    }

    private func deleteTag(deleteTag: Tag) {
        modelContext.delete(deleteTag)
    }
}

//#Preview {
//    TagsSelectView(selectTags: .constant([.init()]), inputComplete: .constant(false))
//    TagsSelectView(selectTags: .constant([.init()]), inputComplete: .constant(false))
//        // .modelContainer(previewYarn)
//}
