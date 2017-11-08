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
    
    override class func primaryKey() -> String? { return "title" }
    
}




extension JSON {
    
    func offenseModelValue() -> Any {
        return ["number": self["number"].stringValue,
                "code": self["code"].stringValue,
                "descriptionOffense": self["description"].stringValue,
                "title": self["tittle"].stringValue,
                "price": self["price"].stringValue,
                "law": self["law"].stringValue,
                "type": self["type"].stringValue,
                "classType": self["class"].stringValue,
                "note": self["note"].stringValue]
    }
}
