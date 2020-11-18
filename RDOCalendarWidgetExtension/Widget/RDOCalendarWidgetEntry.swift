//
//  RDOCalendarWidgetEntity.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 04.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation
import WidgetKit

struct RDOCalendarWidgetEntry: TimelineEntry {
    let date: Date
    var rdoDates: [RDOCalendarWidgetDate] = RDOCalendarRDODateManager.shared.generateRDODates()
    var overtime = RDOCalendarOvertimeManager.shared.fetchTotalOvertime()
    
    var today: RDOCalendarWidgetDate {
        let index = Date().get(.day) - 1
        if rdoDates.count <= index { return RDOCalendarWidgetDate() } else { return rdoDates[index] }
    }
    var firstDayIndex: Int {
        if rdoDates.count == 0 { return 0 } else { return rdoDates[0].date.get(.day)}
    }
}


extension RDOCalendarWidgetEntry {
    
    static var stub: RDOCalendarWidgetEntry {
//        RDOCalendarWidgetEntry(date: Date(), rdoDates: Array(repeating: RDOCalendarWidgetDate(date: Date(), isPayDay: false, isToday: false, isWeekend: true, isVacationDay: false, isIndividualVacationDay: false), count: 30))
        RDOCalendarWidgetEntry(date: Date(), rdoDates: Array(repeating: RDOCalendarWidgetDate(), count: 30))
    }
    
    static var placeholder: RDOCalendarWidgetEntry {
        RDOCalendarWidgetEntry(date: Date(), rdoDates: Array(repeating: RDOCalendarWidgetDate(), count: 30))
//        RDOCalendarWidgetEntry(date: Date(), rdoDates: Array(repeating: RDOCalendarWidgetDate(date: Date(), isPayDay: false, isToday: false, isWeekend: true, isVacationDay: false, isIndividualVacationDay: false), count: 30))
    }
}
