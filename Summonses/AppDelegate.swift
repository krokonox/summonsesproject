//
//  AppDelegate.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/13/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyUserDefaults
import JTAppleCalendar
import EventKit
import CloudKit
import IceCream
import NotificationCenter
import SwiftyStoreKit


struct ShortcutItems {
    let id: Int
    let name: String
    let description: String
    let imageName: String
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NCWidgetProviding {
	
	var window: UIWindow?
	lazy var raalm = DataBaseManager.shared.realm
	
	var syncEngine: SyncEngine?
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //window?.backgroundColor = UIColor.white
        
        DataBaseManager.shared.setupDatabase()
		DataBaseManager.shared.setupOffenseIfNeeds()
		DataBaseManager.shared.setupTpoIfNeeds()
		// Override point for customization after application launch.
		setupAppearance()
        
		IAPHandler.shared.completeTransactions()
        IAPHandler.shared.getPurchasesInfo()
		IAPHandler.shared.fetchAvailableProducts()
        
        //OldIAPHandler.shared.fetchAvailableProducts() 
        //IAPHandler.shared.begin()
        
       
		syncEngine = SyncEngine(objects: [
			SyncObject<OvertimeRealmModel>(),
			SyncObject<VDRealmModel>(),
			SyncObject<IVDRealmModel>()
		])
		application.registerForRemoteNotifications()
		
		if Defaults[.proRDOCalendar] {
            NCWidgetController().setHasContent(true, forWidgetWithBundleIdentifier: "com.summonspartner.sp.RDO-Calendar")
		} else {
			NCWidgetController().setHasContent(false, forWidgetWithBundleIdentifier: "com.summonspartner.sp.RDO-Calendar")
		}
        
        if let firstOpenDay = UserDefaults.standard.object(forKey: "firstOpenDate") as? Date {
            print("The app was first open on: \(firstOpenDay)")
        } else {
            UserDefaults.standard.setValue(Date(), forKey: "firstOpenDate")
        }
        
        Defaults[.numberOfVisits] += 1
        
		return true
	}
	
	func setupAppearance() {
		let cancelButtonAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: UIColor.darkBlue]
		
		UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
		
		UINavigationBar.appearance().tintColor = UIColor.darkBlue
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkBlue]
		//UINavigationBar.appearance().shadowImage = UIImage()
	}
	
	func applicationWillResignActive(_ application: UIApplication) {
        if Defaults[.proOvertimeCalculator] {
            let currentDate = Date()
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: currentDate)
            let currentMonth = calendar.component(.month, from: currentDate)
            let overtimeArray = DataBaseManager.shared.getOvertimesHistory().filter { (overtime) -> Bool in
                return overtime.createDate?.getYear() == "\(currentYear)"
              
            }
            
            let monthData = OvertimeHistoryManager.shared.getTotalCashInMonth(month: "\(currentMonth)", overtimes: overtimeArray)
            let cashInHours = monthData.cash.getTimeFromMinutes()
            let timeInHours = monthData.time.getTimeFromMinutes()
            let totalInHours = (monthData.cash + monthData.time).getTimeFromMinutes()
//            application.shortcutItems = [UIApplicationShortcutItem(type: "FavoriteAction",
//            localizedTitle: "Cash: " + "\(cashInHours)h Time: " + "\(timeInHours)h Total: " + "\(cashInHours + timeInHours)h",
//            localizedSubtitle: "Cash: " + "\(cashInHours)h Time: " + "\(timeInHours)h Total: " + "\(cashInHours + timeInHours)h",
//            icon: nil,
//            userInfo: nil)]
            application.shortcutItems = [UIApplicationShortcutItem(type: "OpenOvertimeHistory",
                                                              localizedTitle: "Cash:",
                                                              localizedSubtitle: "\(cashInHours) hours",
                                                              icon: UIApplicationShortcutIcon(templateImageName: "cash"),
                                                              userInfo: nil),
                                    UIApplicationShortcutItem(type: "OpenOvertimeHistory",
                                                              localizedTitle: "Time:",
                                                              localizedSubtitle: "\(timeInHours) hours",
                                                              icon: UIApplicationShortcutIcon(templateImageName: "time"),
                                                              userInfo: nil),
                                    UIApplicationShortcutItem(type: "OpenOvertimeHistory",
                                                              localizedTitle: "Total:",
                                                              localizedSubtitle: "\(totalInHours) hours",
                                                              icon: UIApplicationShortcutIcon(templateImageName: "ic_check"),
                                                              userInfo: nil)
                                    /*UIApplicationShortcutItem(type: "OpenOvertimeCalculator",
                                                              localizedTitle: "Add Overtime",
                                                              localizedSubtitle: "",
                                                              icon: UIApplicationShortcutIcon(templateImageName: "ic_plus"),
                                                              userInfo: nil)*/]
        } else {
            application.shortcutItems?.removeAll()
        }
        
        if Defaults[.proRDOCalendar] {
            NCWidgetController().setHasContent(true, forWidgetWithBundleIdentifier: "com.summonspartner.sp.RDO-Calendar")
        } else {
            NCWidgetController().setHasContent(false, forWidgetWithBundleIdentifier: "com.summonspartner.sp.RDO-Calendar")
        }
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "OpenOvertimeHistory" {
            SettingsManager.shared.needsOpenOvertimeHistory = true
        } else {
            SettingsManager.shared.needsOpenOvertimeCalculator = true
        }
    }
    
	func applicationDidEnterBackground(_ application: UIApplication) {}
	
	func applicationWillEnterForeground(_ application: UIApplication) {}
	
	func applicationDidBecomeActive(_ application: UIApplication) {}
	
	func applicationWillTerminate(_ application: UIApplication) {}
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // Process the URL.
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true)
              else {
                print("Invalid URL. Host, path and query params are expected")
                return false
              }
        
        if components.scheme == "widget-deeplink" {
            SettingsManager.shared.needsOpenRDOCalendar = true
        }
        
        return true
    }
}
    
    //    func changeRootViewController(with identifier: String, storyboard name: String, isDown: Bool = false) {
    //        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
    //        let desiredViewController = storyboard.instantiateViewController(withIdentifier: identifier)
    //
	//        let snapshot:UIView = (self.window?.snapshotView(afterScreenUpdates: true))!
	//        desiredViewController.view.addSubview(snapshot);
	//
	//        self.window?.rootViewController = desiredViewController
	//        self.window?.makeKeyAndVisible()
	//
	//        UIView.animate(withDuration: 0.3, animations: {() in
	//            snapshot.layer.opacity = 0
	//            snapshot.layer.transform = CATransform3DMakeScale(isDown ? 0.5 : 1.5, isDown ? 0.5 : 1.5, isDown ? 0.5 : 1.5);
	//        }, completion: {
	//            (value: Bool) in
	//            snapshot.removeFromSuperview()
	//        });
	//    }
	//
	

