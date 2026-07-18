//
//  PartsView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/07/25.
//
import SwiftUI

struct YarnInfoSymbolView: View {
    var symbol: YarnSymbol
    var body: some View {
        if symbol.groupId == 1 {
            Image(symbol.name)
                .resizable()
                .scaledToFit()
                .frame(width: 28,height: 28)
                .foregroundColor(.blue)
        } else if symbol.groupId == 2{
            Image(systemName: symbol.name)
                .resizable()
                .scaledToFit()
                .frame(width: 28,height: 28)
                .foregroundColor(.blue)
        } else {
            Image(systemName: "xmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 28)
                .foregroundColor(.blue)
        }

    }
}

struct UpperTabView: View {
    @Binding var selectedTab: Int
    @State var title: String
    @State var index: Int
    var body: some View {
        Button {
            withAnimation {
                selectedTab = index
            }
        } label: {
            VStack(spacing: 0) {
//                Divider()
                Spacer()
                Text(LocalizedStringKey(title))
                    .foregroundColor(index == selectedTab ? .primary : .gray)
                Spacer()
                Rectangle()
                    .fill(index == selectedTab ? .gray : .clear)
                    .frame(height: 3, alignment: .bottom)
                
            }
        }
    }
}

struct ListTitleView: View {
    @State var title: String
    
    var body: some View {
        Text(LocalizedStringKey(title))
            .font(.headline)
            .foregroundColor(.primary)
    }
}

struct ListTitleButtonView: View {
    @State var title: String
    @State var symbol: String = "plus"
    @State var color: Color = .secondary
    
    var body: some View {
        HStack {
            Image(systemName: symbol)
            Text(LocalizedStringKey(title))
                .foregroundStyle(.primary)
                .font(.subheadline)
                .fontWeight(.bold)
                
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.2))
        .cornerRadius(12)
//        .foregroundColor(color)
//        .opacity(0.2)
    }
}

struct TaglabelView: View {
    @State var tag: Tag
    var body: some View {
        HStack {
//            Image(systemName: "number")
//                .foregroundColor(tag.color.color.isLight ? .black : .white)
            Text("\(Image(systemName: "number"))\(tag.name)")
                .fontWeight(.bold)
                .foregroundColor(tag.color.color.isLight ? .black : .white)
        }
        .font(.footnote)
        .padding(6)
        .background(tag.color.color)
        .cornerRadius(30)
    }
}
// 洗濯表示の画像表示
struct LaundrySymbolImageView: View {
    let symbolId: Int
    @State var showPopover = false
    var body: some View {
        if let symbol = getLaundrySymbol(by: symbolId){
            Image(symbol.name)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.primary)
                .foregroundColor(.blue.opacity(0.5))
                .onTapGesture {
                    showPopover = true
                }
                .popover(isPresented: $showPopover, arrowEdge: .bottom) {
                    PopoverContainer {
                        Text(symbol.detail)
                            .foregroundColor(.primary)
                            .padding()
                            .presentationCompactAdaptation(PresentationAdaptation.popover)
                    }
                }
        }
    }
}

struct PopoverContainer: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let popoverPadding: CGFloat = 40 // これがpopover側にあげる余裕
        guard subviews.count == 1 else {
            fatalError("You need to implement your layout!")
        }
        print(#function, proposal)
        var p = proposal
        p.width = p.width ?? (UIScreen.main.bounds.width - popoverPadding)
        p.height = p.height ?? (UIScreen.main.bounds.height - popoverPadding)
        print(p, subviews[0].sizeThatFits(p))
        return subviews[0].sizeThatFits(p) // negotiates possible size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        print(#function, proposal)
        // entrusts default
    }
}

#Preview{
    ListTitleButtonView(title: "KEY_ADD", color: Color.random)
//    TaglabelView(tag: Tag(name: "テストタグ",color: ColorComponents(red: Float.random(in: 0.0...1.0), green: Float.random(in: 0.0...1.0), blue: Float.random(in: 0.0...1.0))))
}
