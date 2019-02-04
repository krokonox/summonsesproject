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
	case fiveMinuteIncrements
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
  var paidDetail: Bool {
    get {
      return UserDefaults.standard.bool(forKey: KeysSettings.paidDetail.rawValue)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: KeysSettings.paidDetail.rawValue)
      UserDefaults.standard.synchronize()
    }
  }
	
	var fiveMinuteIncrements: Bool {
		get {
			return UserDefaults.standard.bool(forKey: KeysSettings.fiveMinuteIncrements.rawValue)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: KeysSettings.fiveMinuteIncrements.rawValue)
			UserDefaults.standard.synchronize()
		}
	}
  
  
  func getRDOSettingsItemValueOfType(type: ItemSettingsModel.ItemType) -> Bool {
    
    switch type {
    case .patrol:
      return permissionShowPatrol
    case .SRG:
      return permissionShowSRG
    case .customRDO:
      return permissionShowCustomRDO
    case .payDays:
      return permissionShowPayDays
    case .vocationDays:
      return permissionShowVocationsDays
    }
  }
  
  func setRDOSettingsItemValueOfType(type: ItemSettingsModel.ItemType, isOn: Bool) {
    switch type {
    case .patrol:
      permissionShowPatrol = isOn
      permissionShowSRG = !isOn
    case .SRG:
      permissionShowSRG = isOn
      permissionShowPatrol = !isOn
    case .customRDO:
      permissionShowCustomRDO = isOn
    case .payDays:
      permissionShowPayDays = isOn
    case .vocationDays:
      permissionShowVocationsDays = isOn
    }
  }
}
