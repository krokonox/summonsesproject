//
//  OvertimeModel.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 1/8/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import Foundation

class OvertimeModel: NSObject {
  
  var overtimeId = UUID().uuidString
  var scheduledStartTime: Date?
  var scheduledEndTime: Date?
  var actualStartTime: Date?
  var actualEndTime: Date?
  var createDate: Date?
	var totalActualTime: Int = 0
  var totalOvertimeWorked: Int = 0
  /// Can be Cash or Time or Paid Detail
  var type = "Cash"
  var rdo = false
  
  var isPaid = false
  
  //travel Time
  var typeTravelTime: String?
  var travelMinutes: Int = 0
  
  //cash & time split
  var splitCashMinutes: Int = 0
  var splitTimeMinutes: Int = 0
  
  //notes
  var notes: String = ""
}
