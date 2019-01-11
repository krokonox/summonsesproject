//
//  OvertimeRealmModelToOvertimeModelMapper.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 1/8/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import Foundation

class OvertimeRealmModelToOvertimeModelMapper: Mapper <OvertimeRealmModel, OvertimeModel> {
  
  override func map(from: OvertimeRealmModel, to: OvertimeModel) {
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
    to.travelMinutes = from.travelMinutes
    //cash & time split
    to.splitTimeMinutes = from.splitTimeMinutes
    to.splitCashMinutes = from.splitCashMinutes
    //notes
    to.notes = from.notes
  }
  
}
