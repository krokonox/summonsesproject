//
//  OffenseModel.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/13/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
import IceCream

class OffenseModel: Object {
  @objc dynamic var id = ""
  @objc dynamic var number = ""
  @objc dynamic var code = ""
  @objc dynamic var descriptionOffense = ""
  @objc dynamic var title = ""
  @objc dynamic var law = ""
  @objc dynamic var note = ""
  @objc dynamic var price = ""
  @objc dynamic var type = ""
  @objc dynamic var classType = ""
  @objc dynamic var isFavourite = false
  @objc dynamic var testimony = ""
	@objc dynamic var isDeleted = false
	
  override class func primaryKey() -> String? { return "id" }
}

extension JSON {
  
  func offenseModelValue() -> Any {
    return ["id": self["id"].stringValue,
            "number": self["violation"].stringValue,
            "code": self["code"].stringValue,
            "descriptionOffense": self["description"].stringValue,
            "title": self["tittle"].stringValue,
            "price": self["price"].stringValue,
            "law": self["law"].stringValue,
            "type": self["class"].stringValue,
            "classType": self["type"].stringValue,
            "note": self["note"].stringValue,
            "testimony": self["testimony"].stringValue]
  }
}

extension OffenseModel: CKRecordConvertible {
	// Yep, leave it blank!
}

extension OffenseModel: CKRecordRecoverable {
	// Leave it blank, too.
}
