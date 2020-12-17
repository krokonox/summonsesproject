//
//  OptionsRealmModel.swift
//  Summonses
//
//  Created by Smikun Denis on 27.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import RealmSwift

class OptionsRealmModel: Object {
  
  //@objc dynamic var id = ""
  @objc dynamic var id = ""
  @objc dynamic var department = 0
  @objc dynamic var squad = 0
  @objc dynamic var showPayDays = false
  @objc dynamic var showVacationDays = false
  
  override class func primaryKey() -> String? { return "id" }
}

