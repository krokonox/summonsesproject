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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var raalm = DataBaseManager.shared.realm
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DataBaseManager.shared.setupDatabase()
        DataBaseManager.shared.setupOffenseIfNeeds()
        // Override point for customization after application launch.
        setupAppearance()
        Defaults[.proPurchaseMade] = false
        
        if IAPHandler.shared.proUserPurchaseMade {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destVC = storyboard.instantiateViewController(withIdentifier: "NavTabBarController")
            self.window?.rootViewController = destVC
            self.window?.makeKeyAndVisible()
        }
        return true
    }
    
    func setupAppearance() {
  //      UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
        let cancelButtonAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        
        UINavigationBar.appearance().barTintColor = .customGray
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        UIApplication.shared.statusBarStyle = .lightContent
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

