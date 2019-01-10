//
//  VDModel.swift
//  Summonses
//
//  Created by Smikun Denis on 09.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import RealmSwift

class VDModel: Object {

    var id = UUID().uuidString
    var startDate: Date?
    var endDate: Date?
    
}
