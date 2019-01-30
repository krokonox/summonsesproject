//
//  CalendarSyncManager.swift
//  Summonses
//
//  Created by Smikun Denis on 28.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import EventKit

enum CalendarType {
  case vacationDays
  case individualVacation
}

class CalendarSyncManager: NSObject {
  

  
  public static let shared = CalendarSyncManager()
  let eventStore = EKEventStore()
  var currentCalendar: EKCalendar?
  
}

func insertEvent(event: EventModel, calendar: CalendarType) {
  
  
  
}

func getCalendar(of type: CalendarType) -> EKCalendar {
  
  
  return EKCalendar()
}
