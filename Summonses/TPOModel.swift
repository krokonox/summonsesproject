//
//  TPOModel.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 12/17/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class TPOModel: Object {
  @objc dynamic var id = 0
  @objc dynamic var name = ""
  @objc dynamic var descriptionTPO = ""
  
  override static func primaryKey() -> String? {
    return "id"
  }
}

extension JSON {
  
  func tpoModelValue() -> Any {
    return [
      "name": self["name"].stringValue,
      "descriptionTPO": self["description"].stringValue
    ]
  }
}
