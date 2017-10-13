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
    dynamic var tittle = ""
    dynamic var law = ""
    dynamic var note = ""
    dynamic var price = ""
    
    override class func primaryKey() -> String? { return "number" }
    
}




extension JSON {
    
    func offenseModelValue() -> Any {
        return ["number": self["number"].stringValue,
                "code": self["code"].stringValue,
                "descriptionOffense": self["description"].stringValue,
                "tittle": self["tittle"].stringValue,
                "price": self["price"].stringValue,
                "law": self["law"].stringValue,
                "note": self["note"].stringValue]
    }
}
