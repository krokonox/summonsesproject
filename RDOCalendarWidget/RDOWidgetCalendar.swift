//
//  Calendar.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 04.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation

struct RDOWidgetCalendar {
    var vacationDays: [Date]
    var payDays: [Date]
    var weekends: [Date]
    var individualVacationDays: [Date]
    
    init(scheduleManager: SheduleManager) {
        self.vacationDays = scheduleManager.getVocationDays()
        self.payDays = scheduleManager.getPayDaysForSelectedMonth(firstDayMonth: <#T##Date#>, lastDayMonth: <#T##Date#>)
        self.weekends = scheduleManager.getWeekends(firstDayMonth: <#T##Date#>, lastDate: <#T##Date#>)
        self.individualVacationDays = scheduleManager.getIVDdateForSelectedMonth(firstDayMonth: <#T##Date#>, lastDayMonth: <#T##Date#>)
    }
    
    init() {}
}
