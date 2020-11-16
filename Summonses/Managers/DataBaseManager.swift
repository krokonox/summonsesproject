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
      schemaVersion: 2,
      
      // Set the block which will be called automatically when opening a Realm with
      // a schema version lower than the one set above
      migrationBlock: { migration, oldSchemaVersion in
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < 2) {
          // Nothing to do!
          // Realm will automatically detect new properties and removed properties
          // And will update the schema on disk automatically
			migration.enumerateObjects(ofType: OvertimeRealmModel.className(), { (oldObject, newObject) in
				newObject!["myTour"] = false
			})
        }
        
    })
    config.deleteRealmIfMigrationNeeded = false
    let directory: NSURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.summonspartner.sp")! as NSURL
    let dbPath = directory.appendingPathComponent("summonses.realm")
    config.fileURL = dbPath
    // Tell Realm to use this new configuration object for the default Realm
    Realm.Configuration.defaultConfiguration = config
    //        Realm.Configuration.defaultConfiguration.encryptionKey = realmKey
    
    if TARGET_OS_SIMULATOR != 0 {
      // Save db to Mac Desktop
      let dbPath = String(format:"/Users/%@/Desktop/Summonses/", NSHomeDirectory().components(separatedBy: "/")[2])
      try! FileManager.default.createDirectory(at: URL(fileURLWithPath: dbPath), withIntermediateDirectories: true, attributes: nil)
      Realm.Configuration.defaultConfiguration.fileURL = URL(string: dbPath.appending("summonses.realm"))
    } else {
      
      //let directory: NSURL = FileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.it.fancypixel.Done")!
      //let dbPath = directory.path!.stringByAppendingPathComponent("db.realm")
      //Realm.Configuration.defaultConfiguration.fileURL = dbPath
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
  
  private func createOptions(object: DaysDisplayedModel) {
    do {
      try realm.write {
        let realmModel = OptionsRealmModel()
        Mappers.optionsModelToOptionsRealmModel.map(from: object, to: realmModel)
        realm.add(realmModel, update: true)
      }
    } catch let error {
      print(error)
    }
  }
  
  func createOvertime(object: OvertimeModel) {
    do {
      try realm.write {
				if object.createDate == nil {
					object.createDate = object.actualStartTime
                } 
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
  
  func createIndividualVocationDay(ivd: IVDModel) {
    do {
      try realm.write {
        let realmIVDModel = IVDRealmModel()
        Mappers.ivdModelToIVDRealmModelMapper.map(from: ivd, to: realmIVDModel)
        realm.add(realmIVDModel, update: true)
        IVDDaysDataDidChange()
      }
    } catch let error {
      print(error)
    }
  }
  
  
  func updateShowOptions(options: DaysDisplayedModel) {
    do {
      try realm.write {
        let realmOptions = realm.objects(OptionsRealmModel.self).first
        guard let realmModel = realmOptions else {
          realm.cancelWrite()
          createOptions(object: options)
          return
        }
        Mappers.optionsModelToOptionsRealmModel.map(from: options, to: realmModel)
        realm.add(realmModel, update: true)
      }
    } catch let error {
      print(error)
    }
  }
  
  func updateOvertime(overtime: OvertimeModel) {
    do {
      try realm.write {
        let ov = realm.objects(OvertimeRealmModel.self).filter("overtimeId = %@", overtime.overtimeId).first
        Mappers.overtimeModelToOvertimeRealmModelMapper.map(from: overtime, to: ov!)
        realm.add(ov!, update: true)
      }
    } catch let error {
      print(error)
    }
  }
  
  func updateVocationDays(vocationDays: VDModel) {
    do {
      try realm.write {
        let vdRealm = realm.objects(VDRealmModel.self).filter("id = %@", vocationDays.id).first
        Mappers.vdModelToVDRealmModelMapper.map(from: vocationDays, to: vdRealm!)
        realm.add(vdRealm!, update: true)
      }
    } catch let error {
      print(error.localizedDescription)
    }
  }
  
  func updateIndividualVocationDay(ivd: IVDModel) {
    do {
      try realm.write {
        let ivdRealm = realm.objects(IVDRealmModel.self).filter("id = %@", ivd.id).first
        Mappers.ivdModelToIVDRealmModelMapper.map(from: ivd, to: ivdRealm!)
        realm.add(ivdRealm!, update: true)
        IVDDaysDataDidChange()
      }
    } catch let error {
      print(error.localizedDescription)
    }
  }
  
  
  //MARK: Get Realm Objects
  
  func getShowOptions() -> DaysDisplayedModel {
    
    let optionsModel = DaysDisplayedModel()
    
    let optionsRealmModel = realm.objects(OptionsRealmModel.self).first
    
    guard let options = optionsRealmModel else {
      let newRealmModel = OptionsRealmModel()
      Mappers.optionsRealmModelToOptionsModelMapper.map(from: newRealmModel, to: optionsModel)
      return optionsModel
    }
    
    Mappers.optionsRealmModelToOptionsModelMapper.map(from: options, to: optionsModel)
    return optionsModel
  }
  
  func getOvertimes() -> [OvertimeModel] {
    var overtimeArray = [OvertimeModel]()
		let overtimeRealmModels = realm.objects(OvertimeRealmModel.self).sorted(byKeyPath: "createDate", ascending: true).filter("isDeleted != true")
    for model in overtimeRealmModels {
      let overtime = OvertimeModel()
      Mappers.overtimeRealmModelToOvertimeModelMapper.map(from: model, to: overtime)
      overtimeArray.append(overtime)
    }
    return overtimeArray
  }
	
	func getOvertimesHistory() -> [OvertimeModel] {
		var overtimeArray = [OvertimeModel]()
		let overtimeRealmModels = realm.objects(OvertimeRealmModel.self).filter("type = %@ OR type = %@", "Cash", "Time").sorted(byKeyPath: "createDate", ascending: true).filter("isDeleted != true")
		for model in overtimeRealmModels {
			let overtime = OvertimeModel()
			Mappers.overtimeRealmModelToOvertimeModelMapper.map(from: model, to: overtime)
			overtimeArray.append(overtime)
		}
        print(overtimeArray.count)
		return overtimeArray
	}
	
	func getOvertimesCash() -> [OvertimeModel] {
		var overtimeArray = [OvertimeModel]()
		let overtimeRealmModels = realm.objects(OvertimeRealmModel.self).filter("type = %@", "Paid Detail").sorted(byKeyPath: "createDate", ascending: true).filter("isDeleted != true")
		for model in overtimeRealmModels {
			let overtime = OvertimeModel()
			Mappers.overtimeRealmModelToOvertimeModelMapper.map(from: model, to: overtime)
			overtimeArray.append(overtime)
		}
		return overtimeArray
	}
  
  
  //MARK: - Vocation
  func getVocationDays() -> [VDModel] {
    var vocationDaysArray = [VDModel]()
    let vocationDaysRealmModels = realm.objects(VDRealmModel.self).filter("isDeleted != true")
    for model in vocationDaysRealmModels {
      let vocationDay = VDModel()
      Mappers.vdRealmModelToVDModelMapper.map(from: model, to: vocationDay)
      vocationDaysArray.append(vocationDay)
    }
    return vocationDaysArray
  }
  
  func getVocationDayByPeriod(datesOfPeriod dates: [Date]) -> [VDModel] {
    
    var vdArray = [VDModel]()
    
    let vdRealmModels: [VDRealmModel] = realm.objects(VDRealmModel.self).filter("isDeleted != true").filter { (realmModel) -> Bool in
      guard let startDate = realmModel.startDate else {return false}
      
      for datePeriod in dates {
        if Calendar.current.isDate(datePeriod, inSameDayAs: startDate) {
          return true
        }
      }
      return false
    }
    
    for realmModel in vdRealmModels {
      let vd = VDModel()
      Mappers.vdRealmModelToVDModelMapper.map(from: realmModel, to: vd)
      vdArray.append(vd)
    }
    
    return vdArray
  }
  
  func getIndividualVocationDay() -> [IVDModel] {
    var ivdArray = [IVDModel]()
    let ivdRealmModels = realm.objects(IVDRealmModel.self).filter("isDeleted != true")
    for model in ivdRealmModels {
      let ivd = IVDModel()
      Mappers.ivdRealmModelToIVDModelMapper.map(from: model, to: ivd)
      ivdArray.append(ivd)
    }
    return ivdArray
  }
  
  
  func getIndividualVocationDayByPeriod(datesOfPeriod dates: [Date]) -> [IVDModel] {
    
    var ivdArray = [IVDModel]()
    
    let ivdRealmModels: [IVDRealmModel] = realm.objects(IVDRealmModel.self).filter("isDeleted != true").filter { (realmModel) -> Bool in
      guard let date = realmModel.date else {return false}
      
      for datePeriod in dates {
        if Calendar.current.isDate(datePeriod, inSameDayAs: date) {
          return true
        }
      }
      return false
    }
    
    for realmModel in ivdRealmModels {
      let ivd = IVDModel()
      Mappers.ivdRealmModelToIVDModelMapper.map(from: realmModel, to: ivd)
      ivdArray.append(ivd)
    }
    
    return ivdArray
  }


  //MARK: Remove Realm Objects
  func removeOvertime(overtimeId: String) {
    let ov = realm.objects(OvertimeRealmModel.self).filter("overtimeId = %@", overtimeId).first
    do {
      try realm.write {
				ov?.isDeleted = true
//        realm.delete(ov!)
      }
    } catch let error {
      print(error)
    }
  }
  
  func removeVocationDays(object: VDModel) {
    let vd = realm.objects(VDRealmModel.self).filter("id = %@", object.id).first
    do {
      try realm.write {
				vd?.isDeleted = true
//        realm.delete(vd!)
      }
    } catch let error {
      print(error)
    }
  }
  
  func removeIndividualVocationDay(object: IVDModel) {
    let ivd = realm.objects(IVDRealmModel.self).filter("id = %@", object.id).first
    do {
      try realm.write {
				ivd?.isDeleted = true
//        realm.delete(ivd!)
        IVDDaysDataDidChange()
      }
    } catch let error {
      print(error)
    }
  }
  
  
  private func IVDDaysDataDidChange() {
    DispatchQueue.main.async {
      NotificationCenter.default.post(name: Notification.Name.IVDDataDidChange, object: nil)
    }
  }
  
}
