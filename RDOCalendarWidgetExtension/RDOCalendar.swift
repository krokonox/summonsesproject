//
//  RDOCalendar.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 05.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation

struct RDOCalendar {
    var vacationDays: [Date]
    var payDays: [Date]
    var weekends: [Date]
    var individualVacationDays: [Date]
    
    init(vacationDays: [Date], payDays: [Date], weekends: [Date], individualVacationDays: [Date]) {
        self.vacationDays = vacationDays
        self.payDays = payDays
        self.weekends = weekends
        self.individualVacationDays = individualVacationDays
    }
}
