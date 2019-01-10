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
    DispatchQueue.global().async {
      var offences: [OffenseModel] = []
      let tmpRealm = try! Realm()
      do {
        if let file = Bundle.main.url(forResource: "Contents", withExtension: "json") {
          let data = try Data(contentsOf: file)
          let jsonValue = try JSON(data: data)
          let oldOffensesID =  tmpRealm.objects(OffenseModel.self).filter{$0.isFavourite == true}.map({$0.id})
          
          for subJson in jsonValue.arrayValue {
            //                        print(subJson)
            let offence = OffenseModel(value: subJson.offenseModelValue())
            if oldOffensesID.contains(offence.id) {
              offence.isFavourite = true
            }
            //                        print(offence)
            offences.append(offence)
          }
          do {
            try tmpRealm.write {
              tmpRealm.add(offences, update: true)
            }
          }
        } else {
          print("no file")
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  func getFavouriresOffence() -> Array<Any> {
    return Array(realm.objects(OffenseModel.self)).sorted {$0.isFavourite.hashValue > $1.isFavourite.hashValue}
  }
  
  //TPO
  
  func setupTpoIfNeeds() {
    DispatchQueue.global().async {
      var tpoArray: [TPOModel] = []
      let tmpRealm = try! Realm()
      do {
        if let file = Bundle.main.url(forResource: "tpo", withExtension: "json") {
          let data = try Data(contentsOf: file)
          let jsonValue = try JSON(data: data)
          for (index, subJson) in jsonValue.arrayValue.enumerated() {
            //                        print(subJson)
            let tpo = TPOModel(value: subJson.tpoModelValue())
            tpo.id = index
            tpoArray.append(tpo)
          }
          do {
            try tmpRealm.write {
              tmpRealm.add(tpoArray, update: true)
            }
          }
        } else {
          print("no file")
        }
      } catch {
        print(error)
      }
    }
    
  }
  
  //MARK: Create and Update Realm Objects
  
  func createOvertime(object: OvertimeModel) {
    do {
      try realm.write {
        //        object.createDate = Date()
        object.createDate = object.actualStartTime;
        let realmModel = OvertimeRealmModel()
        Mappers.overtimeModelToOvertimeRealmModelMapper.map(from: object, to: realmModel)
        realm.add(realmModel, update: true)
      }
    } catch let error {
      print(error)
    }
  }
  
  
  func createVocationDays(object: VDModel) {
    do {
      try realm.write {
        let realmVDModel = VDRealmModel()
        Mappers.vdModelToVDRealmModelMapper.map(from: object, to: realmVDModel)
        realm.add(realmVDModel, update: true)
      }
    } catch let error {
      print(error)
    }
  }
  
  func createIVD(object: IVDModel) {
    do {
      try realm.write {
        let realmIVDModel = IVDRealmModel()
        Mappers.ivdModelToIVDRealmModelMapper.map(from: object, to: realmIVDModel)
        realm.add(realmIVDModel, update: true)
      }
    } catch let error {
      print(error)
    }
  }


  //MARK: Get Realm Objects
  
  func getOvertimes() -> [OvertimeModel] {
    var overtimeArray = [OvertimeModel]()
    let overtimeRealmModels = realm.objects(OvertimeRealmModel.self)
    for model in overtimeRealmModels {
      let overtime = OvertimeModel()
      Mappers.overtimeRealmModelToOvertimeModelMapper.map(from: model, to: overtime)
      overtimeArray.append(overtime)
    }
    return overtimeArray
  }
  
  func getVocationDays() -> [VDModel] {
    var vocationDaysArray = [VDModel]()
    let vocationDaysRealmModels = realm.objects(VDRealmModel.self)
    for model in vocationDaysRealmModels {
      let vocationDay = VDModel()
      Mappers.vdRealmModelToVDModelMapper.map(from: model, to: vocationDay)
      vocationDaysArray.append(vocationDay)
    }
    return vocationDaysArray
  }
  
  func getIVD() -> [IVDModel] {
    var ivdArray = [IVDModel]()
    let ivdRealmModels = realm.objects(IVDRealmModel.self)
    for model in ivdRealmModels {
      let ivd = IVDModel()
      Mappers.ivdRealmModelToIVDModelMapper.map(from: model, to: ivd)
      ivdArray.append(ivd)
    }
    return ivdArray
  }
  
  //MARK: Remove Realm Objects
  
  func removeOvertime(overtimeId: String) {
    let ov = realm.objects(OvertimeRealmModel.self).filter("overtimeId = %@", overtimeId).first
    do {
      try realm.write {
        realm.delete(ov!)
      }
    } catch {
      
    }
  }
  
  func removeVocationDays(object: VDModel) {
    let vd = realm.objects(VDRealmModel.self).filter("id = %@", object.id).first
    do {
      try realm.write {
        realm.delete(vd!)
      }
    } catch let error {
      print(error)
    }
  }
  
  func removeIndividualVocationDays(object: IVDModel) {
    let ivd = realm.objects(IVDRealmModel.self).filter("id = %@", object.id).first
    do {
      try realm.write {
        realm.delete(ivd!)
      }
    } catch let error {
      print(error)
    }
  }
  
  
  
}
