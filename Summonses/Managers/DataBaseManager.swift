//
//  DataBaseManager.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/13/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class DataBaseManager: NSObject {
    
    static let shared = DataBaseManager()
    
    lazy var realm: Realm = {
        do {
            let realm = try Realm()
            
            return realm
        } catch let error as NSError {
            // If the encryption key is wrong, `error` will say that it's an invalid database
            fatalError("Error opening realm: \(error)")
        }
    }()
    
    
    func setupDatabase () {
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
        
        if TARGET_OS_SIMULATOR != 0 {
            // Save db to Mac Desktop
            let dbPath = String(format:"/Users/%@/Desktop/Summonses/", NSHomeDirectory().components(separatedBy: "/")[2])
            try! FileManager.default.createDirectory(at: URL(fileURLWithPath: dbPath), withIntermediateDirectories: true, attributes: nil)
            Realm.Configuration.defaultConfiguration.fileURL = URL(string: dbPath.appending("summonses.realm"))
        }
    }

    
    func setupOffenseIfNeeds() {
        let oldCount = realm.objects(OffenseModel.self).count
        var offences: [OffenseModel] = []
        do {
            if let file = Bundle.main.url(forResource: "Contents", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let jsonValue = try JSON(data: data)
                for subJson in jsonValue.arrayValue {
                    let offence = OffenseModel(value: subJson.offenseModelValue())
                    print(offence)
                    offences.append(offence)
                }
                let tempRealm = realm
                if offences.count > oldCount {
                    do {
                        try tempRealm.write {
                            tempRealm.deleteAll()
                            tempRealm.add(offences, update: true)
                        }
                    }
                }
            } else {
                print("no  file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getFavouriresOffence() -> Array<Any> {
        return Array(realm.objects(OffenseModel.self)).sorted {$0.isFavourite.hashValue > $1.isFavourite.hashValue}
    }

}
