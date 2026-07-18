//
//  PurchaseView.swift
//  YarnStocker
//
//  Created by 岡山直也 on 2025/11/16.
//

import SwiftUI
import StoreKit

struct PurchaseView: View {
    @AppStorage("unlockFeature") var unlockFeature: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            ProductView(id: "site.nattoKing.yarnHolder.unlockFeature")
                .productViewStyle(.large)
                .onInAppPurchaseCompletion { product, result in
                    if case .success(.success(_)) = result {
                        print("success")
                        unlockFeature = true
                        // 課金が成功した場合の処理
                    } else {
                        // 課金が失敗した場合の処理
                        print("error")
                        print("\(result)")
                    }
                }
            Button("復元はこちら") {
                Task {
                    do {
                        try await AppStore.sync()
                        let verificationResult = await Transaction.currentEntitlement(for: "site.nattoKing.yarnHolder.unlockFeature")
                        if case .verified = verificationResult {
                            // 復元が成功した場合の処理
                            unlockFeature = true
                        } else {
                            // 復元が失敗した場合の処理
                        }
                    } catch {
                        // 復元が失敗した場合の処理
                    }
                }
            }
        }
    }
}


#Preview {
    PurchaseView()
}
