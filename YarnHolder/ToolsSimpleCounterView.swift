//
//  ToolsSimpleCounterView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/09/29.
//

import SwiftUI

struct ToolsSimpleCounterView: View {
    
    @AppStorage("simpleCounterCount") var simpleCounterCount:Int = 0
    @State var count:Int = 0
    @AppStorage("appColorTheme") var appColorTheme = 10
    
    @State private var showResetConfirmAlert = false
    @State private var showSetCountAlert = false
    @State private var tmpCount = 0
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none       // 桁区切りや小数点をローカル形式で表示
        formatter.maximumFractionDigits = 0    // 小数点以下を表示しない
        formatter.minimum = 0
//        formatter.maximum = 1000
        return formatter
    }
        
    var body: some View {
        VStack{
            // マイナス
            Button{
                withAnimation{
                    count -= 1
                }
                
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(getColorTheme(by: appColorTheme).sysName).opacity(0.75))
                    Image(systemName: "minus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.white)
                }
                .frame(height: 150)
            }
            .buttonStyle(.plain)
            .disabled(count == 0)
            .padding()

            // 罫線
            Rectangle()
                .frame(height: 10)
                .foregroundColor(Color(getColorTheme(by: appColorTheme).sysName).opacity(0.75))
            // プラス
            Button{
                withAnimation{
                    count += 1
                }
                
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(getColorTheme(by: appColorTheme).sysName).opacity(0.75))
                    Text("\(String(count))")
                        .font(.system(size: 100, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .contentTransition(.numericText(value: Double(count)))
//                        .animation(.easeInOut)
//                    Image(systemName: "plus")
//                        .resizable()
//                        .frame(width: 100, height: 100)
//                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(.plain)
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    showSetCountAlert = true
                    tmpCount = count
                } label: {
                    Label("KEY_SET", systemImage: "pencil")
                }
                Button {
                    showResetConfirmAlert = true
                } label: {
                    Text("KEY_RESET")
                }
            }
        }
        .navigationTitle("KEY_SIMPLE_COUNTER")
        .alert("KEY_RESET_COUNT", isPresented: $showResetConfirmAlert) {
            Button("KEY_RESET"){
                withAnimation{
                    count = 0
                }
            }
            Button("KEY_CANCEL", role: .cancel){
            }
        } message: {
            Text("KEY_CONFIRM_RESET_COUNT")
        }
        .alert("KEY_COUNT_SET", isPresented: $showSetCountAlert) {
            TextField("", value: $count.animation(), formatter: numberFormatter)
                .keyboardType(.numberPad)
            Button("KEY_SET"){
//                count = 0
            }
            Button("KEY_CANCEL", role: .cancel){
                withAnimation{
                    count = tmpCount
                }
            }
        }
        .onChange(of: count){
            simpleCounterCount = count
        }
        .onAppear{
            count = simpleCounterCount
        }
        .sensoryFeedback(.impact(flexibility: .soft), trigger: count)
    }
    
}

#Preview{
    ToolsSimpleCounterView()
}
