//
//  YarnStockStatusListView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/08/18.
//

import SwiftUI
import SwiftData

struct YarnStockStatusListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var statuses: [YarnStockStatus]
    
    @State private var showAddStatusAlert: Bool = false
    @State private var showEditStatusAlert: Bool = false
    @State private var showDeleteStatusAlert: Bool = false
    @State private var inputStatusName = ""
    @State private var editStatus: YarnStockStatus? = nil
    @State private var deleteStatus: YarnStockStatus? = nil
    
    @State private var showChangeDefaultAlert: Bool = false
    
    @Namespace private var namespace
    
    var body: some View {
        List() {
            ForEach(statuses.sorted(by: {$0.orderIndex < $1.orderIndex})) { status in
                HStack {
                    Text(status.name)
                    if status.isDefault {
                        Spacer()
                        Text("KEY_DEFAULT")
                            .font(.caption.bold())
                            .padding(8)
                            .background(
                                Capsule()
                                    .fill(.gray.opacity(0.25))
                            )
                    }
                }
                .animation(.easeInOut, value: status)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    // スワイプ＞削除
                    if !status.isDefault {
                        Button(role: .destructive) {
                            deleteStatus = status
                            showDeleteStatusAlert = true
                        } label: {
                            Label("KEY_DELETE", systemImage: "trash.fill")
                        }
                        .tint(.red)
                        Button() {
                            editStatus = status
                            showChangeDefaultAlert = true
                        } label: {
                            Label("KEY_SET_DEFAULT", systemImage: "star.fill")
                        }
                        .tint(.cyan)
                        
                    } else {
                    }
                    // スワイプ＞更新
                    Button {
                        editStatus = status
                        inputStatusName = status.name
                        showEditStatusAlert = true
                    } label: {
                        Label("KEY_EDIT", systemImage: "pencil")
                    }
                    .tint(.orange)
                }
                
            }
            .onMove(perform: moveStatus)
        }
        .navigationTitle(Text("KEY_INDEX_INVENTORY_STATUS"))
        .toolbar {
            ToolbarItemGroup {
                Button {
                    showAddStatusAlert = true
                } label: {
                    Label("KEY_ADD", systemImage: "plus.square")
                }
                .alert("KEY_NEW_STATUS", isPresented: $showAddStatusAlert) {
                    TextField("KEY_STATUS_NAME", text: $inputStatusName)
                    Button("KEY_COMPLETE"){
                        addStatus()
                    }
                    Button("KEY_CANCEL", role: .cancel){
                        inputStatusName = ""
                    }
                }
            }
        }
        .alert("KEY_EDIT_STATUS", isPresented: $showEditStatusAlert) {
            TextField("KEY_STATUS_NAME", text: $inputStatusName)
            Button("KEY_COMPLETE"){
                if let status = editStatus {
                    status.name = inputStatusName
                }
                try? modelContext.save()
                inputStatusName = ""
                editStatus = nil
            }
            Button("KEY_CANCEL", role: .cancel){
                inputStatusName = ""
            }
        }
        .alert("KEY_DEFAULT_STATUS", isPresented: $showChangeDefaultAlert) {
            Button("KEY_CHANGE"){
                if let status = editStatus {
                    changeDefaultStatus(defaultStatus: status)
                }
                editStatus = nil
            }
            Button("KEY_CANCEL", role: .cancel){
                editStatus = nil
            }
        } message: {
            Text("KEY_CHANGE_DEFAULT_STATUS")
        }
        .alert("KEY_DELETE_STATUS", isPresented: $showDeleteStatusAlert) {
            Button("KEY_DELETE"){
                if let status = deleteStatus {
                    deleteStatus(deleteStatus: status)
                }
                deleteStatus = nil
            }
            Button("KEY_CANCEL", role: .cancel){
                deleteStatus = nil
            }
        } message: {
            Text("KEY_DELETE_STATUS_CONFIRM")
        }
        
        
    }
    
    private func addStatus() {
        defer {
            inputStatusName = ""
        }
        //
        if inputStatusName.isEmpty {
            return
        }
        let newStatus = YarnStockStatus(orderIndex: statuses.count,name:inputStatusName)
        modelContext.insert(newStatus)
    }
    
    private func deleteStatus(deleteStatus: YarnStockStatus) {
        let defaultStatus = statuses.first(where: { $0.isDefault })
        withAnimation {
            if let wrappedDetails = deleteStatus.details {
                for detail in wrappedDetails {
                    detail.status = defaultStatus!
                    try? modelContext.save()
                }
                modelContext.delete(deleteStatus)
            }
        }
    }
    
    private func changeDefaultStatus(defaultStatus: YarnStockStatus) {
        //        let oldDefault = statuses.first(where: { $0.isDefault })
        let oldDefaults = statuses.filter{ $0.isDefault }
        withAnimation {
            for old in oldDefaults{
                old.isDefault = false
            }
            defaultStatus.isDefault = true
            try? modelContext.save()
        }
    }
    private func moveStatus(from source: IndexSet, to destination: Int) {
        var updatedStatuses = statuses.sorted(by: {$0.orderIndex < $1.orderIndex})
        updatedStatuses.move(fromOffsets: source, toOffset: destination)
        withAnimation {
            for (index, item) in updatedStatuses.enumerated() {
                item.orderIndex = index
            }
            try? modelContext.save()
        }
    }
    
}

//#Preview {
//    NavigationStack {
//        YarnStockStatusListView()
//             .modelContainer(previewYarn)
//    }
//
//}
