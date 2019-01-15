//
//  SettingsManager.swift
//  Summonses
//
//  Created by Smikun Denis on 20.12.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import Foundation

enum KeysSettings: String {
  case patrolKey
  case srgKey
  case customRdoKey
  case payDaysKey
  case vocationDaysKey
  case rdoOvertime
  case paidDetail
}

class SettingsManager: NSObject {
  
  public static let shared = SettingsManager()
  
  var permissionShowPatrol : Bool {
    get {
      return UserDefaults.standard.bool(forKey: KeysSettings.patrolKey.rawValue)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: KeysSettings.patrolKey.rawValue)
      UserDefaults.standard.synchronize()
    }
  }
  
  var permissionShowSRG : Bool {
    get {
      return UserDefaults.standard.bool(forKey: KeysSettings.srgKey.rawValue)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: KeysSettings.srgKey.rawValue)
      UserDefaults.standard.synchronize()
    }
  }
  
  var permissionShowCustomRDO : Bool {
    get {
      return UserDefaults.standard.bool(forKey: KeysSettings.customRdoKey.rawValue)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: KeysSettings.customRdoKey.rawValue)
      UserDefaults.standard.synchronize()
    }
  }
  
  var permissionShowPayDays : Bool {
    get {
      return UserDefaults.standard.bool(forKey: KeysSettings.payDaysKey.rawValue)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: KeysSettings.payDaysKey.rawValue)
      UserDefaults.standard.synchronize()
    }
  }
  
  var permissionShowVocationsDays : Bool {
    get {
      return UserDefaults.standard.bool(forKey: KeysSettings.vocationDaysKey.rawValue)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: KeysSettings.vocationDaysKey.rawValue)
      UserDefaults.standard.synchronize()
    }
  }
  
  
  //MARK: - Vertime
  //CheckBox paid detail in Settings
  var isHidePaidDetail: Bool {
    get {
      return UserDefaults.standard.bool(forKey: KeysSettings.paidDetail.rawValue)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: KeysSettings.paidDetail.rawValue)
      UserDefaults.standard.synchronize()
    }
  }
}
