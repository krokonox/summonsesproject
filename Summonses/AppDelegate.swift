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
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NCWidgetProviding {
  
  var window: UIWindow?
  lazy var raalm = DataBaseManager.shared.realm

	var syncEngine: SyncEngine?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    //window?.backgroundColor = UIColor.white
//		registerForPushNotifications()
    DataBaseManager.shared.setupDatabase()
    DataBaseManager.shared.setupOffenseIfNeeds()
    DataBaseManager.shared.setupTpoIfNeeds()
    // Override point for customization after application launch.
    setupAppearance()
		
//		Defaults[.proBaseVersion] = true
//		Defaults[.proRDOCalendar] = true
//		Defaults[.proOvertimeCalculator] = true
		IAPHandler.shared.fetchAvailableProducts()

		syncEngine = SyncEngine(objects: [
			SyncObject<OvertimeRealmModel>(),
			SyncObject<VDRealmModel>(),
			SyncObject<IVDRealmModel>()
		])
		
		if Defaults[.proRDOCalendar] {
			NCWidgetController().setHasContent(true, forWidgetWithBundleIdentifier: "com.summonspartner.sp.RDO-Calendar")
		} else {
			NCWidgetController().setHasContent(false, forWidgetWithBundleIdentifier: "com.summonspartner.sp.RDO-Calendar")
		}
		
    return true
  }
	
	func registerForPushNotifications() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
			print("Permission granted: \(granted)")
			guard granted else { return }
			self?.getNotificationSettings()
		}
	}
		
		func getNotificationSettings() {
			UNUserNotificationCenter.current().getNotificationSettings { settings in
				guard settings.authorizationStatus == .authorized else { return }
				DispatchQueue.main.async {
					UIApplication.shared.registerForRemoteNotifications()
				}
			}
		}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
		let token = tokenParts.joined()
		print("Device Token: \(token)")
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("Failed to register: \(error)")
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		
		let dict = userInfo as! [String: NSObject]
		let notification = CKNotification(fromRemoteNotificationDictionary: dict)
		if (notification.subscriptionID == IceCreamConstant.cloudKitSubscriptionID) {
			NotificationCenter.default.post(name: Notifications.cloudKitDataDidChangeRemotely.name, object: nil, userInfo: userInfo)
		}
		
		completionHandler(.newData)
	}

	
  func setupAppearance() {
    let cancelButtonAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: UIColor.darkBlue]
    
    UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
    
    UINavigationBar.appearance().tintColor = UIColor.darkBlue
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkBlue]
    //UINavigationBar.appearance().shadowImage = UIImage()
  }
  
  func applicationWillResignActive(_ application: UIApplication) {}
  
  func applicationDidEnterBackground(_ application: UIApplication) {}
  
  func applicationWillEnterForeground(_ application: UIApplication) {}
  
  func applicationDidBecomeActive(_ application: UIApplication) {}
  
  func applicationWillTerminate(_ application: UIApplication) {}
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    return true
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
  
}

