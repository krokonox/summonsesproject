//
//  IVDRealmModel.swift
//  Summonses
//
//  Created by Smikun Denis on 10.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import RealmSwift
import IceCream

class IVDRealmModel: Object {
  
  @objc dynamic var id = ""
  @objc dynamic var date: Date?
	
	@objc dynamic var isDeleted = false
	
  override static func primaryKey() -> String? {
    return "id"
  }
  
}

extension IVDRealmModel: CKRecordConvertible {
	// Yep, leave it blank!
}

extension IVDRealmModel: CKRecordRecoverable {
	// Leave it blank, too.
}
