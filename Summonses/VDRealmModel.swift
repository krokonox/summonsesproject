//
//  VDModel.swift
//  Summonses
//
//  Created by Smikun Denis on 09.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import RealmSwift
import IceCream

class VDRealmModel: Object {
  
  @objc dynamic var id = ""
  @objc dynamic var startDate: Date?
  @objc dynamic var endDate: Date?
	
	@objc dynamic var isDeleted = false
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
}

extension VDRealmModel: CKRecordConvertible {
	// Yep, leave it blank!
}

extension VDRealmModel: CKRecordRecoverable {
	// Leave it blank, too.
}
