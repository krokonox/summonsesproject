//
//  AppDelegate.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/13/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupDatabase()
        // Override point for customization after application launch.
        return true
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

    // MARK: - Database
    
    class func realm() -> Realm {
        do {
            let realm = try Realm()
            
            return realm
        } catch let error as NSError {
            // If the encryption key is wrong, `error` will say that it's an invalid database
            fatalError("Error opening realm: \(error)")
        }
    }
    
    func setupDatabase () {
        //        var realmKey: Data
        //        if let key = keychain.getData(K.KeychainKeys.realmKey) {
        //            realmKey = key
        //        } else {
        //            var key = Data(count: 64)
        //            _ = key.withUnsafeMutableBytes { bytes in
        //                SecRandomCopyBytes(kSecRandomDefault, 64, bytes)
        //            }
        //
        //            keychain.set(key, forKey: K.KeychainKeys.realmKey)
        //
        //            realmKey = key
        //        }
        
        var config = Realm.Configuration (
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            
            // PRODFIX: Check it before Production (set schema version the same as app build number)
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
                
        })
        config.deleteRealmIfMigrationNeeded = true
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        //        Realm.Configuration.defaultConfiguration.encryptionKey = realmKey
        
 //       if K.Platform.isSimulator {
            // Save db to Mac Desktop
            let dbPath = String(format:"/Users/%@/Desktop/Summonses/", NSHomeDirectory().components(separatedBy: "/")[2])
            try! FileManager.default.createDirectory(at: URL(fileURLWithPath: dbPath), withIntermediateDirectories: true, attributes: nil)
            Realm.Configuration.defaultConfiguration.fileURL = URL(string: dbPath.appending("summonses.realm"))
 //       }
    }
    
}

