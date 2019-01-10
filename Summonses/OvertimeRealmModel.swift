//
//  OvertimeModel.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 1/8/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class OvertimeRealmModel: Object {
  @objc dynamic var overtimeId = ""
  @objc dynamic var scheduledStartTime: Date?
  @objc dynamic var scheduledEndTime: Date?
  @objc dynamic var actualStartTime: Date?
  @objc dynamic var actualEndTime: Date?
  @objc dynamic var createDate: Date?
  @objc dynamic var totalOvertimeWorked: String?
  @objc dynamic var type = "Cash"
  @objc dynamic var rdo = false
  
  @objc dynamic var isPaid = false
  
  //travel Time
  @objc dynamic var typeTravelTime: String?
  @objc dynamic var travelHH: String?
  @objc dynamic var travelMM: String?
  
  //cash & time split
  @objc dynamic var splitCashHH: String?
  @objc dynamic var splitCashMM: String?
  @objc dynamic var splitTimeHH: String?
  @objc dynamic var splitTimeMM: String?
  
  //notes
  @objc dynamic var notes: String = ""
  
  override class func primaryKey() -> String? { return "overtimeId" }
}
