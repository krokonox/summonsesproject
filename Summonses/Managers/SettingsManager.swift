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
    case firstDayWeekKey
	case srgKey
	case customRdoKey
    case steadyRdoKey
    case weekendsSteadyRDO
	case payDaysKey
	case vocationDaysKey
	case rdoOvertime
	case paidDetail
	case fiveMinuteIncrements
	case overtimeRate
	case paidDetailRate
	case typeSquad
    case currentDate
    case OVHistoryCurrentDate
    case needsOpenOvertimeHistory
    case needsOpenOvertimeCalculator
    case expandedCalendar
    case summonsesPrice
    case subscriptionPrice
    case fullPrice
}

class SettingsManager: NSObject {
	
	public static let shared = SettingsManager()
    
    var summonsesPrice : String {
        get {
            return UserDefaults.standard.string(forKey: KeysSettings.summonsesPrice.rawValue) ?? "$ 3.99"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KeysSettings.summonsesPrice.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    var subscriptionPrice : String {
        get {
            return UserDefaults.standard.string(forKey: KeysSettings.subscriptionPrice.rawValue) ?? "$ 4.99"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KeysSettings.subscriptionPrice.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    var fullPrice : String {
        get {
            return UserDefaults.standard.string(forKey: KeysSettings.fullPrice.rawValue) ?? "$ 19.99"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KeysSettings.fullPrice.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
	
    var currentDate : String {
        get {
            return UserDefaults.standard.string(forKey: "currentDate") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentDate")
            UserDefaults.standard.synchronize()
        }
    }
    
    var OVHistoryCurrentDate : String {
        get {
            return UserDefaults.standard.string(forKey: "OVHistoryCurrentDate") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "OVHistoryCurrentDate")
            UserDefaults.standard.synchronize()
        }
    }
    
    var isCalendarExpanded : Bool {
        get {
            return UserDefaults.standard.bool(forKey: KeysSettings.expandedCalendar.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KeysSettings.expandedCalendar.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    var needsOpenOvertimeHistory : Bool {
        get {
            return UserDefaults.standard.bool(forKey: KeysSettings.needsOpenOvertimeHistory.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KeysSettings.needsOpenOvertimeHistory.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    var needsOpenOvertimeCalculator : Bool {
        get {
            return UserDefaults.standard.bool(forKey: KeysSettings.needsOpenOvertimeCalculator.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KeysSettings.needsOpenOvertimeCalculator.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    
	var permissionShowPatrol : Bool {
		get {
			return UserDefaults.standard.bool(forKey: KeysSettings.patrolKey.rawValue)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: KeysSettings.patrolKey.rawValue)
			UserDefaults.standard.synchronize()
		}
	}
    
    var isMondayFirstDay : Bool {
        get {
            return UserDefaults.standard.bool(forKey: KeysSettings.firstDayWeekKey.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KeysSettings.firstDayWeekKey.rawValue)
            UserDefaults.standard.synchronize()
            if let userDefaults = UserDefaults (suiteName: "group.com.summonspartner.sp") {
                userDefaults.set(newValue as Bool, forKey: "firstDayWeekKey")
            }
            
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
	
	var typeSquad: Int {
		get {
			return UserDefaults.standard.integer(forKey: KeysSettings.typeSquad.rawValue)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: KeysSettings.typeSquad.rawValue)
			UserDefaults.standard.synchronize()
		}
	}
    
    var permissionShowSteadyRDO : Bool {
        get {
            return UserDefaults.standard.bool(forKey: KeysSettings.steadyRdoKey.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KeysSettings.steadyRdoKey.rawValue)
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
	
	var overtimeRate: Double {
		get {
			let rate = UserDefaults.standard.double(forKey: KeysSettings.overtimeRate.rawValue)
			return rate
		}
		set {
			UserDefaults.standard.set(newValue, forKey: KeysSettings.overtimeRate.rawValue)
			UserDefaults.standard.synchronize()
		}
	}
	
	var paidDetailRate: Double {
		get {
			let rate = UserDefaults.standard.double(forKey: KeysSettings.paidDetailRate.rawValue)
			return rate
		}
		set {
			UserDefaults.standard.set(newValue, forKey: KeysSettings.paidDetailRate.rawValue)
			UserDefaults.standard.synchronize()
		}
	}
	
	func getRDOSettingsItemValueOfType(type: ItemSettingsModel.ItemType) -> Bool {
		
		switch type {
		case .patrol:
			return permissionShowPatrol
		case .SRG:
			return permissionShowSRG
        case .steadyRDO:
            return permissionShowSteadyRDO
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
            permissionShowSteadyRDO = !isOn
            permissionShowCustomRDO = !isOn
		case .SRG:
			permissionShowPatrol = !isOn
            permissionShowSRG = isOn
            permissionShowSteadyRDO = !isOn
            permissionShowCustomRDO = !isOn
        case .steadyRDO:
            permissionShowPatrol = !isOn
            permissionShowSRG = !isOn
            permissionShowSteadyRDO = isOn
            permissionShowCustomRDO = !isOn
		case .customRDO:
			permissionShowPatrol = !isOn
            permissionShowSRG = !isOn
            permissionShowSteadyRDO = !isOn
            permissionShowCustomRDO = isOn
		case .payDays:
			permissionShowPayDays = isOn
		case .vocationDays:
			permissionShowVocationsDays = isOn
		}
	}
}
