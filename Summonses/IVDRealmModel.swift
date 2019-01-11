//
//  IVDRealmModel.swift
//  Summonses
//
//  Created by Smikun Denis on 10.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import RealmSwift

class IVDRealmModel: Object {
  
  @objc dynamic var id = ""
  @objc dynamic var date: Date?
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
}
