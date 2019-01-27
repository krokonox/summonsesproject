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
  @objc dynamic var totalOvertimeWorked: Int = 0
	@objc dynamic var totalActualTime: Int = 0
  @objc dynamic var type = "Cash"
  @objc dynamic var rdo = false
  
  @objc dynamic var isPaid = false
  
  //travel Time
  @objc dynamic var typeTravelTime: String?
  @objc dynamic var travelMinutes: Int = 0
  
  //cash & time split
  @objc dynamic var splitCashMinutes: Int = 0
  @objc dynamic var splitTimeMinutes: Int = 0
  
  //notes
  @objc dynamic var notes: String = ""
  
  override class func primaryKey() -> String? { return "overtimeId" }
}
