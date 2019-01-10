//
//  OvertimeModelToOvertimeRealmModelMapper.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 1/8/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import Foundation

class OvertimeModelToOvertimeRealmModelMapper: Mapper <OvertimeModel, OvertimeRealmModel> {
  
  override func map(from: OvertimeModel, to: OvertimeRealmModel) {
    to.overtimeId = from.overtimeId
    to.scheduledStartTime = from.scheduledStartTime
    to.scheduledEndTime = from.scheduledEndTime
    to.actualStartTime = from.actualStartTime
    to.actualEndTime = from.actualEndTime
    to.createDate = from.createDate
    to.totalOvertimeWorked = from.totalOvertimeWorked
    to.type = from.type
    to.rdo = from.rdo
    to.isPaid = from.isPaid
    //travel Time
    to.typeTravelTime = from.typeTravelTime
    to.travelHH = from.travelHH
    to.travelMM = from.travelMM
    //cash & time split
    to.splitCashHH = from.splitCashHH
    to.splitCashMM = from.splitCashMM
    to.splitTimeHH = from.splitTimeHH
    to.splitTimeMM = from.splitTimeMM
    //notes
    to.notes = from.notes
  }
  
}
