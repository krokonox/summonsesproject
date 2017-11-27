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

class OffenseModel: Object {
    dynamic var id = ""
    dynamic var number = ""
    dynamic var code = ""
    dynamic var descriptionOffense = ""
    dynamic var title = ""
    dynamic var law = ""
    dynamic var note = ""
    dynamic var price = ""
    dynamic var type = ""
    dynamic var classType = ""
    dynamic var isFavourite = false
    dynamic var testimony = ""
    
    override class func primaryKey() -> String? { return "id" }
}




extension JSON {
    
    func offenseModelValue() -> Any {
        return ["id": self["id"].stringValue,
                "number": self["section"].stringValue,
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
