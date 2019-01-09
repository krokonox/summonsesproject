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
  var totalOvertimeWorked: String?
  var type = "Cash"
  var rdo = false
  
  //travel Time
  var typeTravelTime: String?
  var travelHH: String?
  var travelMM: String?
  
  //cash & time split
  var splitCashHH: String?
  var splitCashMM: String?
  var splitTimeHH: String?
  var splitTimeMM: String?
  
  //notes
  var notes: String = ""
}
