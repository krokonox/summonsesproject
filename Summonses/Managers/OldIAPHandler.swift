////
////  IAPHandler.swift
////  Summonses
////
////  Created by Pavel Budankov on 7/31/18.
////  Copyright © 2018 neoviso. All rights reserved.
////
//
//import UIKit
//import StoreKit
//import SwiftyUserDefaults
//import NotificationCenter
//
////enum PurchaseType: String {
////    case otCalculator = "ot_calculator"
////    case rdoCalendar = "rdo_calendar"
////    case endlessAccess = "endless_access"
////    case fullAccess = "full_access"
////    case fullSummonses = "full_summonses"
////}
//
//
//class OldIAPHandler: NSObject, NCWidgetProviding {
//
//  static let shared = IAPHandler()
//
//    var callback: (()->())?
//
//    private var sharedSecret = ""
//
//    fileprivate var productID = ""
//    fileprivate var productsRequest = SKProductsRequest()
//    var iapProducts = [SKProduct]()
//
//    fileprivate(set) var proBaseVersion: Bool = Defaults[.proBaseVersion] {
//        didSet {
////            NotificationCenter.default.post(name: K.Notifications.proBaseVersion, object: nil)
//            Defaults[.proBaseVersion] = proBaseVersion
//        }
//    }
//
//    fileprivate(set) var otCalculator: Bool = Defaults[.proOvertimeCalculator] {
//        didSet {
////            NotificationCenter.default.post(name: K.Notifications.proOvertimeCalculator, object: nil)
//            Defaults[.proOvertimeCalculator] = otCalculator
//        }
//    }
//
//    fileprivate(set) var rdoCalendar: Bool = Defaults[.proRDOCalendar] {
//        didSet {
////            NotificationCenter.default.post(name: K.Notifications.proRDOCalendar, object: nil)
//            Defaults[.proRDOCalendar] = rdoCalendar
//        }
//    }
//
//    fileprivate(set) var endlessVersion: Bool = Defaults[.endlessVersion] {
//            didSet {
//    //            NotificationCenter.default.post(name: K.Notifications.proRDOCalendar, object: nil)
//                Defaults[.endlessVersion] = endlessVersion
//        }
//    }
//
//    fileprivate(set) var yearSubscription: Bool = Defaults[.yearSubscription] {
//            didSet {
//    //            NotificationCenter.default.post(name: K.Notifications.proRDOCalendar, object: nil)
//                Defaults[.yearSubscription] = yearSubscription
//        }
//    }
//
//    func getProducts(_ type: PurchaseType) -> SKProduct? {
//        guard let product = iapProducts.first(where: { return $0.productIdentifier == type.rawValue }) else { return nil}
//        return product
//    }
//
//    override init() {
//        super.init()
//        SKPaymentQueue.default().add(self)
//    }
//
//    func begin(){
//
//        //TODO: - delete before update
//
//        let def = false
//
//        Defaults[.proBaseVersion] = def
//        Defaults[.proRDOCalendar] = def
//        Defaults[.proOvertimeCalculator] = def
//    }
//
//  fileprivate var canMakePurchases: Bool {  return SKPaymentQueue.canMakePayments()  }
//
//  func fetchAvailableProducts() {
//    let productIdentifiers = NSSet(objects: PurchaseType.fullSummonses.rawValue, PurchaseType.fullAccess.rawValue, PurchaseType.endlessAccess.rawValue)//PurchaseType.otCalculator.rawValue, PurchaseType.rdoCalendar.rawValue)
//
//    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
//    productsRequest.delegate = self
//    productsRequest.start()
//  }
//
//  func restorePro(_ type: PurchaseType) {
//    restorePurchase(type)
//  }
//
//  func upgratePro(_ type: PurchaseType) {
//    guard canMakePurchases else { return }
//    guard let product = iapProducts.first(where: { return $0.productIdentifier == type.rawValue }) else { return }
//    makePayment(for: product)
//  }
//
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
//
//    func showIAPVC(_ type: PurchaseType, completionHandler: (@escaping (_ vc:NewInAppPurchaseVC?) -> Void)) {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        if let vc = storyboard.instantiateViewController(withIdentifier: "NewInAppPurchaseVC") as? NewInAppPurchaseVC {
//            vc.typeIAP = type
//            if IAPHandler.shared.iapProducts.count != 0 {
//                completionHandler(vc)
//            } else {
//                completionHandler(nil)
//            }
//        }
//    }
//
//}
//
//extension OldIAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver {
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
//                        rdoCalendar = true
//                        proBaseVersion = true
//                        NCWidgetController().setHasContent(true, forWidgetWithBundleIdentifier: "com.summonspartner.sp.RDO-Calendar")
//                    case PurchaseType.rdoCalendar.rawValue:
//                        rdoCalendar = true
//                        otCalculator = true
//                        proBaseVersion = true
//                        NCWidgetController().setHasContent(true, forWidgetWithBundleIdentifier: "com.summonspartner.sp.RDO-Calendar")
//                    case PurchaseType.fullSummonses.rawValue:
//                        proBaseVersion = true
//                    case PurchaseType.endlessAccess.rawValue:
//                        proBaseVersion = true
//                        otCalculator = true
//                        rdoCalendar = true
//                        endlessVersion = true
//                        NCWidgetController().setHasContent(true, forWidgetWithBundleIdentifier: "com.summonspartner.sp.RDO-Calendar")
//                    case PurchaseType.fullAccess.rawValue:
//                        proBaseVersion = true
//                        yearSubscription = true
//                        otCalculator = true
//                        rdoCalendar = true
//                        NCWidgetController().setHasContent(true, forWidgetWithBundleIdentifier: "com.summonspartner.sp.RDO-Calendar")
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
//
