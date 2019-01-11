//
//  VDModel.swift
//  Summonses
//
//  Created by Smikun Denis on 09.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import RealmSwift

class VDRealmModel: Object {
  
  @objc dynamic var id = ""
  @objc dynamic var startDate: Date?
  @objc dynamic var endDate: Date?
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
}
