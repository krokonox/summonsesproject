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

enum NonConsumableType: String {
	case otCalculator = "ot_calculator"
	case rdoCalendar = "rdo_calendar"
	case fullSummonses = "full_summonses"
}

class IAPHandler: NSObject {
	
  static let shared = IAPHandler()
	
	var callback: (()->())?
  
  fileprivate var productID = ""
  fileprivate var productsRequest = SKProductsRequest()
	var iapProducts = [SKProduct]()
	
	fileprivate(set) var proBaseVersion: Bool = Defaults[.proBaseVersion] {
		didSet {
			NotificationCenter.default.post(name: K.Notifications.proBaseVersion, object: nil)
		}
	}
	
  fileprivate(set) var otCalculator: Bool = Defaults[.proOvertimeCalculator] {
    didSet {
      NotificationCenter.default.post(name: K.Notifications.proOvertimeCalculator, object: nil)
    }
  }
	
	fileprivate(set) var rdoCalendar: Bool = Defaults[.proRDOCalendar] {
		didSet {
			NotificationCenter.default.post(name: K.Notifications.proRDOCalendar, object: nil)
		}
	}
	
	func getProducts(_ type: NonConsumableType) -> SKProduct? {
		guard let product = iapProducts.first(where: { return $0.productIdentifier == type.rawValue }) else { return nil}
		return product
	}
	
  // MARK: - CAN MAKE
  fileprivate var canMakePurchases: Bool {  return SKPaymentQueue.canMakePayments()  }
  
  // MARK: - FETCH AVAILABLE IAP PRODUCTS
  func fetchAvailableProducts(){
    
    // Put here your IAP Products ID's
    let productIdentifiers = NSSet(objects: NonConsumableType.otCalculator.rawValue, NonConsumableType.rdoCalendar.rawValue, NonConsumableType.fullSummonses.rawValue)
    
    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
    productsRequest.delegate = self
    productsRequest.start()
  }
  
  // MARK: - RESTORE PURCHASE
  
  func restorePro(_ type: NonConsumableType) {
    restorePurchase(.otCalculator)
  }
  
  func upgratePro(_ type: NonConsumableType) {
    guard canMakePurchases else { return }
    guard let product = iapProducts.first(where: { return $0.productIdentifier == type.rawValue }) else { return }
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
	
	func showIAPVC(_ type: NonConsumableType, completionHandler: (@escaping (_ vc:InAppPurchaseVC?) -> Void)) {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		if let vc = storyboard.instantiateViewController(withIdentifier: "InAppPurchaseVC") as? InAppPurchaseVC {
			vc.typeIAP = type
			if IAPHandler.shared.iapProducts.count != 0 {
				completionHandler(vc)
			} else {
				completionHandler(nil)
			}
		}
	}
  
}

extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver {
  
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    transactions.forEach {
      switch $0.transactionState {
      case .restored, .purchased:
        SKPaymentQueue.default().finishTransaction($0)
        switch productID {
        case NonConsumableType.otCalculator.rawValue:
          otCalculator = true
          Defaults[.proOvertimeCalculator] = true
				case NonConsumableType.rdoCalendar.rawValue:
					rdoCalendar = true
					Defaults[.proRDOCalendar] = true
				case NonConsumableType.fullSummonses.rawValue:
					proBaseVersion = true
					Defaults[.proBaseVersion] = true
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
		for i in response.products {
			print(i.localizedTitle)
			print(i.localizedDescription)
			print(i.price)
		}
    iapProducts = response.products
		callback?()
  }
  
  func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
    fetchAvailableProducts()
  }
  
}

