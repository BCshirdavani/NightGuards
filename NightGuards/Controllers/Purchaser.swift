//
//  Purchaser.swift
//  NightGuards
//
//  Created by shiMac on 1/11/21.
//

import Foundation
import StoreKit

final class Purchaser: NSObject, SKPaymentTransactionObserver {
    var item: String?
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    // MARK: in-app purchase method
    func buyHero(hero: String) {
        print("buy hero: \(hero)")
        item = K.PROD_ID + "." + hero
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = K.PROD_ID + "." + hero
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("user cannot make payments")
        }
    }
        
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print(" - - - paymentQueue method")
        for transaction in transactions {
            print(" - - transaction identifier: \(transaction.transactionIdentifier)")
            if transaction.transactionState == .purchased {
                print(" - - - user payment successful")
                if let prodID = transaction.original?.payment.productIdentifier {
                    UserDefaults.standard.set(true, forKey: prodID)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .failed {
                print(" - - - payment failed")
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print(" - - - payment failed: \(errorDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .restored {
                print(" - - - transaction restored")
                if let prodID = transaction.original?.payment.productIdentifier {
                    UserDefaults.standard.set(true, forKey: prodID)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
        
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print(" - - - restore failed: \(error)")
    }
    
    func isPurchased(itemName: String) -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: K.PROD_ID + "." + itemName)
        if purchaseStatus {
            print(" - - - \(itemName) previously purchased")
            Heroes.heroDict[itemName]?.heroUnlocked = true
            return true
        } else {
            print(" - - - \(itemName) never purchased")
            return false
        }
    }
    
    func restore() {
        print(" - restore pressed")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print(" - - restore completed")
    }
    
}
