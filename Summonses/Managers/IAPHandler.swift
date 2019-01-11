//
//  IAPHandler.swift
//  Summonses
//
//  Created by Pavel Budankov on 7/31/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyUserDefaults

fileprivate enum NonConsumableType: String {
  case upgradeToPro = "com.summonspartner.sp.upgradeToPro"
}

class IAPHandler: NSObject {
  
  static let shared = IAPHandler()
  
  fileprivate var productID = ""
  fileprivate var productsRequest = SKProductsRequest()
  fileprivate var iapProducts = [SKProduct]()
  
  
  fileprivate(set) var proUserPurchaseMade: Bool = Defaults[.proPurchaseMade] {
    didSet {
      NotificationCenter.default.post(name: K.Notifications.purchaseDidUpdate, object: nil)
    }
  }
  
  
  // MARK: - CAN MAKE
  fileprivate var canMakePurchases: Bool {  return SKPaymentQueue.canMakePayments()  }
  
  // MARK: - FETCH AVAILABLE IAP PRODUCTS
  func fetchAvailableProducts(){
    
    // Put here your IAP Products ID's
    let productIdentifiers = NSSet(objects: NonConsumableType.upgradeToPro.rawValue)
    
    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
    productsRequest.delegate = self
    productsRequest.start()
  }
  
  // MARK: - RESTORE PURCHASE
  
  func restorePro() {
    restorePurchase(.upgradeToPro)
  }
  
  func upgratePro() {
    guard canMakePurchases else { return }
    guard let product = iapProducts.first(where: { return $0.productIdentifier == NonConsumableType.upgradeToPro.rawValue }) else { return }
    makePayment(for: product)
  }
  
  fileprivate func restorePurchase(_ type: NonConsumableType) {
    guard iapProducts.contains(where: { return $0.productIdentifier == type.rawValue }) else { return }
    SKPaymentQueue.default().add(self)
    SKPaymentQueue.default().restoreCompletedTransactions()
    productID = type.rawValue
  }
  
  fileprivate func makePayment(for product: SKProduct) {
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(self)
    SKPaymentQueue.default().add(payment)
    productID = payment.productIdentifier
  }
  
}

extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver {
  
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    transactions.forEach {
      switch $0.transactionState {
      case .restored, .purchased:
        SKPaymentQueue.default().finishTransaction($0)
        switch productID {
        case NonConsumableType.upgradeToPro.rawValue:
          proUserPurchaseMade = true
          Defaults[.proPurchaseMade] = true
        default: break
        }
      case .failed:
        SKPaymentQueue.default().finishTransaction($0)
      default:
        ()
      }
    }
  }
  
  func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
    
  }
  
  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    guard !response.products.isEmpty else { return }
    iapProducts = response.products
  }
  
  func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
    fetchAvailableProducts()
  }
  
}

