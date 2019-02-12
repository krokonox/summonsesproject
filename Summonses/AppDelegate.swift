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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
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
		
		Defaults[.proBaseVersion] = true
		Defaults[.proRDOCalendar] = true
		Defaults[.proOvertimeCalculator] = true
		IAPHandler.shared.fetchAvailableProducts()
    //        if IAPHandler.shared.proUserPurchaseMade {
    //            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    //            let destVC = storyboard.instantiateViewController(withIdentifier: "NavTabBarController")
    //            self.window?.rootViewController = destVC
    //            self.window?.makeKeyAndVisible()
    //        }
		
		
//		syncEngine = SyncEngine(objects: [
//				SyncObject<OffenseModel>(),
//				SyncObject<OvertimeRealmModel>(),
//				SyncObject<IVDRealmModel>()
//			])
//		application.registerForRemoteNotifications()
		
    return true
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

