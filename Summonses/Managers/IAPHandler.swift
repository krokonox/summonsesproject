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
import NotificationCenter
import SwiftyStoreKit

enum PurchaseType: String {
    case otCalculator = "ot_calculator"
    case rdoCalendar = "rdo_calendar"
    case endlessAccess = "endless_access"
    case fullAccess = "full_access"
    case fullSummonses = "full_summonses"
}

public typealias SuccessBlock = () -> Void
public typealias FailureBlock = (Error?) -> Void

class IAPHandler: NSObject, NCWidgetProviding {

  static let shared = IAPHandler()

    var callback: (()->())?
    var tabbarCallback: (()->())?
    var tpoReloadCallBack: (()->())?
    var splashCallBack: (()->())?
    
    private var sharedSecret = "6b261cf11d5244fa89708712dd2e7709"

    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    var isFirstTime : Bool = true

    fileprivate(set) var proBaseVersion: Bool = Defaults[.proBaseVersion] {
        didSet {
//            NotificationCenter.default.post(name: K.Notifications.proBaseVersion, object: nil)
            Defaults[.proBaseVersion] = proBaseVersion
            print("proBaseVersion: ", proBaseVersion)
        }
    }

    fileprivate(set) var otCalculator: Bool = Defaults[.proOvertimeCalculator] {
        didSet {
//            NotificationCenter.default.post(name: K.Notifications.proOvertimeCalculator, object: nil)
            Defaults[.proOvertimeCalculator] = otCalculator
            print("otCalculator: ", otCalculator)
        }
    }

    fileprivate(set) var rdoCalendar: Bool = Defaults[.proRDOCalendar] {
        didSet {
//            NotificationCenter.default.post(name: K.Notifications.proRDOCalendar, object: nil)
            Defaults[.proRDOCalendar] = rdoCalendar
            print("rdoCalendar: ", rdoCalendar)
        }
    }

    fileprivate(set) var endlessVersion: Bool = Defaults[.endlessVersion] {
            didSet {
    //            NotificationCenter.default.post(name: K.Notifications.proRDOCalendar, object: nil)
                Defaults[.endlessVersion] = endlessVersion
                print("endlessVersion: ", endlessVersion)
        }
    }

    fileprivate(set) var yearSubscription: Bool = Defaults[.yearSubscription] {
            didSet {
    //            NotificationCenter.default.post(name: K.Notifications.proRDOCalendar, object: nil)
                Defaults[.yearSubscription] = yearSubscription
                print("yearSubscription: ", yearSubscription)
        }
    }

    func getProducts(_ type: PurchaseType) -> SKProduct? {
        guard let product = iapProducts.first(where: { return $0.productIdentifier == type.rawValue }) else { return nil}
        return product
        
       
    }

    override init() {
        super.init()
        //SKPaymentQueue.default().add(self)
    }

    func begin() {
        if isFirstTime {
            isFirstTime = true
            
            let def = true
            Defaults[.proBaseVersion] = def
            Defaults[.proRDOCalendar] = def
            Defaults[.proOvertimeCalculator] = def
        }
        //TODO: - delete before update

        
    }

  fileprivate var canMakePurchases: Bool {  return SKPaymentQueue.canMakePayments()  }

  func fetchAvailableProducts() {
    
    verifyPurchases()
    
    //productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
    //productsRequest.delegate = self
    //productsRequest.start()
  }

    func getPurchasesInfo() {
        let productIdentifiers = NSSet(objects: PurchaseType.fullSummonses.rawValue, PurchaseType.fullAccess.rawValue, PurchaseType.endlessAccess.rawValue)
        
        SwiftyStoreKit.retrieveProductsInfo(productIdentifiers as! Set<String>) {result in
            for product in result.retrievedProducts {
                switch product.productIdentifier {
                    case PurchaseType.fullSummonses.rawValue:
                        SettingsManager.shared.summonsesPrice =  "$ \(product.price ) "
                        break;
                    case PurchaseType.fullAccess.rawValue:
                        SettingsManager.shared.subscriptionPrice = "$ \(product.price )"
                        break;
                    case PurchaseType.endlessAccess.rawValue:
                        SettingsManager.shared.fullPrice = "$ \(product.price )"
                        break;
                    default:
                        break;
                }
            }
        }
    }
    
    func verifyPurchases() {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: self.sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                self.otCalculator = false
                self.rdoCalendar = false
                self.proBaseVersion = false
                self.endlessVersion = false
                self.yearSubscription = false
                
                let productIdentifiers = [PurchaseType.fullAccess.rawValue, PurchaseType.endlessAccess.rawValue, PurchaseType.otCalculator.rawValue, PurchaseType.rdoCalendar.rawValue, PurchaseType.fullSummonses.rawValue]
                var flag = false
                
                for productId in productIdentifiers {
                    if flag {
                        break
                    }
                    
                // Verify the purchase of Consumable or NonConsumable
                    if productId != PurchaseType.fullAccess.rawValue {
                        let purchaseResult = SwiftyStoreKit.verifyPurchase(
                            productId: productId,
                            inReceipt: receipt)

                        switch purchaseResult {
                            case .purchased(let receiptItem):
                                print("\(productId) is purchased: \(receiptItem)")
                                self.updateDefault(productId)
                                flag = true
                            case .notPurchased:
                                print("The user has never purchased \(productId)")
                        }
                    } else {
                        let purchaseResult = SwiftyStoreKit.verifySubscription(
                                ofType: .autoRenewable,
                                productId: productId,
                                inReceipt: receipt)
                        
                            switch purchaseResult {
                                case .purchased(let expiryDate, let receiptItems):
                                    print("Product is valid until \(expiryDate)")
                                    self.updateDefault(productId)
                                    flag = true
                                case .expired(let expiryDate, let receiptItems):
                                    print("Product is expired since \(expiryDate)")
                                    self.lockSubscription()
                                case .notPurchased:
                                    print("This product has never been purchased")
                                    self.lockSubscription()
                                }
                    }
                }
                
                let dateWhenAppBecomeFree = 1594173600.0 //2020-07-08 02:00
                
                // Check if App was purchased
                for item in receipt {
                    if item.key == "receipt" {
                        if let dict = item.value as? NSDictionary {
                            if let originalPurchaseDateMS = dict.value(forKey: "original_purchase_date_ms") as? String {
                                if var timestamp = Double(originalPurchaseDateMS) {
                                    timestamp /= 1000
                                    if timestamp <= dateWhenAppBecomeFree {
                                        print("App was purchased")
                                        self.updateDefault(PurchaseType.fullSummonses.rawValue)
                                    }
                                }
                            }
                            break
                        }
                    }
                }
                
                //self.tpoReloadCallBack?()
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
            self.splashCallBack?()
        }
    }
    
    private func lockSubscription() {
        self.proBaseVersion = false
        self.yearSubscription = false
        self.otCalculator = false
        self.rdoCalendar = false
        NCWidgetController().setHasContent(false, forWidgetWithBundleIdentifier: "com.summonspartner.sp.RDO-Calendar")
    }
    
    private func updateDefault(_ productId : String) {
        switch productId {
            case PurchaseType.otCalculator.rawValue:
                self.otCalculator = true
                self.rdoCalendar = true
                self.proBaseVersion = true
                NCWidgetController().setHasContent(true, forWidgetWithBundleIdentifier: "com.summonspartner.sp.RDO-Calendar")
            case PurchaseType.rdoCalendar.rawValue:
                self.rdoCalendar = true
                self.otCalculator = true
                self.proBaseVersion = true
                NCWidgetController().setHasContent(true, forWidgetWithBundleIdentifier: "com.summonspartner.sp.RDO-Calendar")
            case PurchaseType.fullSummonses.rawValue:
                self.proBaseVersion = true
            case PurchaseType.endlessAccess.rawValue:
                self.proBaseVersion = true
                self.otCalculator = true
                self.rdoCalendar = true
                self.endlessVersion = true
                NCWidgetController().setHasContent(true, forWidgetWithBundleIdentifier: "com.summonspartner.sp.RDO-Calendar")
            case PurchaseType.fullAccess.rawValue:
                self.proBaseVersion = true
                self.yearSubscription = true
                self.otCalculator = true
                self.rdoCalendar = true
                NCWidgetController().setHasContent(true, forWidgetWithBundleIdentifier: "com.summonspartner.sp.RDO-Calendar")
            default:
                break
        }
        self.callback?()
    }
    
    func completeTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        
    }
    
  func restorePro() {
    SwiftyStoreKit.restorePurchases(atomically: true) { results in
        if results.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(results.restoreFailedPurchases)")
            Alert.show(title: "", subtitle: "Restore Failed!")
        }
        else if results.restoredPurchases.count > 0 {
            print("Restore Success: \(results.restoredPurchases)")
            Alert.show(title: "", subtitle: "Restore Success!")
            self.fetchAvailableProducts()
        }
        else {
            print("Nothing to Restore")
            Alert.show(title: "", subtitle: "Nothing to Restore")
        }
    }
  }
    
    func upgratePro(_ type: PurchaseType) {
        guard canMakePurchases else { return }
        
        SwiftyStoreKit.purchaseProduct(type.rawValue, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                if type == .fullAccess {
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    
                    let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: self.sharedSecret)
                    SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
                        
                        if case .success(let receipt) = result {
                            let purchaseResult = SwiftyStoreKit.verifySubscription(
                                ofType: .autoRenewable,
                                productId: type.rawValue,
                                inReceipt: receipt)
                            
                            switch purchaseResult {
                            case .purchased(let expiryDate, let receiptItems):
                                print("Product is valid until \(expiryDate)")
                            case .expired(let expiryDate, let receiptItems):
                                print("Product is expired since \(expiryDate)")
                            case .notPurchased:
                                print("This product has never been purchased")
                            }
                            
                        } else {
                            // receipt verification error
                        }
                    }
                }
                
                self.fetchAvailableProducts()
                print("Purchase Success: \(purchase.productId)")
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
        
        //    guard let product = iapProducts.first(where: { return $0.productIdentifier == type.rawValue }) else { return }
//    makePayment(for: product)
  }

//  fileprivate func restorePurchase(_ type: PurchaseType) {
//    guard iapProducts.contains(where: { return $0.productIdentifier == type.rawValue }) else { return }
//    SKPaymentQueue.default().add(self)
//    SKPaymentQueue.default().restoreCompletedTransactions()
//  }
//
//  fileprivate func makePayment(for product: SKProduct) {
//    let payment = SKPayment(product: product)
//
//    SKPaymentQueue.default().add(self)
//    SKPaymentQueue.default().add(payment)
//    productID = payment.productIdentifier
//  }

    func showIAPVC(_ type: PurchaseType, completionHandler: (@escaping (_ vc:NewInAppPurchaseVC?) -> Void)) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = storyboard.instantiateViewController(withIdentifier: "NewInAppPurchaseVC") as? NewInAppPurchaseVC {
            vc.typeIAP = type
            completionHandler(vc)
//            if IAPHandler.shared.iapProducts.count != 0 {
//                completionHandler(vc)
//            } else {
//                completionHandler(nil)
//            }
        }
    }

}

//extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver {
//
//    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
//        guard canMakePurchases else { return false }
//        return true
//    }
//
//  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//    transactions.forEach {
//      switch $0.transactionState {
//      case .restored, .purchased:
//        switch $0.payment.productIdentifier {
//                    case PurchaseType.otCalculator.rawValue:
//                        otCalculator = true
//                        proBaseVersion = true
//                    case PurchaseType.rdoCalendar.rawValue:
//                        rdoCalendar = true
//                        proBaseVersion = true
//                        NCWidgetController().setHasContent(true, forWidgetWithBundleIdentifier: "com.summonspartner.sp.RDO-Calendar")
//                    case PurchaseType.fullSummonses.rawValue:
//                        proBaseVersion = true
//                    case PurchaseType.endlessAccess.rawValue:
//                        proBaseVersion = true
//                        otCalculator = true
//                        rdoCalendar = true
//                        endlessVersion = true
//                    case PurchaseType.fullAccess.rawValue:
//                        proBaseVersion = true
//                        yearSubscription = true
//                        otCalculator = true
//                        rdoCalendar = true
//                    default:
//                        break
//                }
//                callback?()
//                SKPaymentQueue.default().finishTransaction($0)
//      case .failed:
//                print("failed")
//        SKPaymentQueue.default().finishTransaction($0)
//                break
//      default:
//                break;
//      }
//    }
//  }
//
//  func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
//        if (queue.transactions.count == 0) {
//            callback?()
//        }
//    }
//
//  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//    guard !response.products.isEmpty else { return }
//    iapProducts = response.products
//  }
//
//  func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
//    fetchAvailableProducts()
//  }
//
//}

