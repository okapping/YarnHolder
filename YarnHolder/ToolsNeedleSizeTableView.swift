//
//  ToolsNeedleSizeTableView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/10/07.
//

import SwiftUI

struct ToolsNeedleSizeTableView: View {
    
    var body: some View {
        List{
            Section(
                header:
                    HStack{
                        Text("mm").fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                        Text("US").fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                        Text("UK").fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                        Text("JP").fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 8)
                    .foregroundStyle(.primary)
                    .font(.system(.title3, design: .rounded))
            ) {
                ForEach(KnittingNeedlesSizes, id: \.id) { needle in
                    HStack(spacing: 0){
                        Text("\(needle.mmSize)mm")
                            .font(.system(.body, design: .rounded))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                        Text(needle.usSize != "" ? needle.usSize : "-")
                            .frame(maxWidth: .infinity)
                        
                        Text(needle.ukSize != "" ? needle.ukSize : "-")
                            .frame(maxWidth: .infinity)
                        
                        Text(needle.jpSize != "" ? needle.jpSize : "-")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .listStyle(.plain)
//        ScrollView {
//            LazyVStack(pinnedViews: [.sectionHeaders]) {
//            }
//        }
        .navigationTitle("KEY_NEEDLE_SIZE_CHART")
    }
}


#Preview {
    ToolsNeedleSizeTableView()
}
