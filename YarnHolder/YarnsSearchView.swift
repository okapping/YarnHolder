//
//  YarnsSearchView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/08/27.
//

import SwiftUI
import SwiftData
import Flow

struct YarnsSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    
//    contains
    @Binding var searchData: YarnsSearchContainer
    @Query var tags: [Tag]
    
    @FocusState private var nameFocus: Bool
    
    @State private var feedbackForReset: Bool = false
    
    var body: some View {
        NavigationStack {
            List{
                Section {
                    ZStack {
                        TextField("KEY_NAME", text: $searchData.name)
                            .focused($nameFocus)
                        HStack {
                            Spacer()
                            Button{
                                searchData.name = ""
                            } label: {
                                Image(systemName: "xmark.app.fill")
                                    .font(.body)
                                    .foregroundStyle(.secondary.opacity(0.8))
                                    .symbolEffect(.appear, isActive: searchData.name == "")
                            }
                            .buttonStyle(.plain)
                        }

                    }
                }
                Section {
                    HFlow {
                        ForEach(tags.sorted(by: { $0.orderIndex < $1.orderIndex })){ tag in
                                HStack {
                                    Image(systemName: searchData.tags.contains(tag) ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(.blue)
                                        .contentTransition(.symbolEffect(.replace.offUp))
                                    Text(tag.name)
                                        .foregroundColor(tag.color.color.isLight ? .black : .white)
                                }
                                .font(.body)
                                .padding(8)
                                .background(tag.color.color)
                                .cornerRadius(16)
                                .onTapGesture{
                                    withAnimation{
                                        if let index = searchData.tags.firstIndex(of: tag){
                                            searchData.tags.remove(at: index)
                                        } else {
                                            searchData.tags.append(tag)
                                        }
                                    }
                                    
                                }
                        }
                    }
                }
                .sensoryFeedback(.selection, trigger: searchData.tags)
                Section{
                    Button{
                        searchData = .init()
                        feedbackForReset.toggle()
                    } label: {
                        HStack{
                            Spacer()
                            Text("KEY_RESET")
                            Spacer()
                        }
                    }
                }
                .sensoryFeedback(.warning, trigger: feedbackForReset)
            }
            //            .navigationTitle(isEntry ? "KEY_ADD_TAG" : "KEY_EDIT_TAG")
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
        }
//        .onAppear{
//            self.nameFocus = true
//        }
    }
}


#Preview{
    @Previewable @State var searchData: YarnsSearchContainer = .init()
    
    YarnsSearchView(searchData: $searchData)
        // .modelContainer(previewYarn)
}
