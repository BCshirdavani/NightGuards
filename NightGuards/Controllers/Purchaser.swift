//
//  Purchaser.swift
//  NightGuards
//
//  Created by shiMac on 1/11/21.
//

import Foundation
import StoreKit

final class Purchaser: NSObject, SKPaymentTransactionObserver {
    
    // MARK: in-app purchase method
    func buyHero(hero: String) {
            print("buy hero: \(hero)")
            if SKPaymentQueue.canMakePayments() {
                let paymentRequest = SKMutablePayment()
                paymentRequest.productIdentifier = K.PROD_ID + "." + hero
                SKPaymentQueue.default().add(paymentRequest)
            } else {
                print("user cannot make payments")
            }
        }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                print("user payment successful")
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .failed {
                print("payment failed")
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("payment failed: \(errorDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    func isPurchased(itemName: String) -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: K.PROD_ID + "." + itemName)
        if purchaseStatus {
            print("previously purchased")
            return true
        } else {
            print("never purchased")
            return false
        }
    }
    
    
}
