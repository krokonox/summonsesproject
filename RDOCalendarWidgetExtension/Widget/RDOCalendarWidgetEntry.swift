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
    
    var shouldStartFromMonday: Bool {
        if let userDefaults = UserDefaults(suiteName: "group.com.summonspartner.sp") {
           return userDefaults.bool(forKey: "firstDayWeekKey")
        } else { return false }
    }
    
    var today: RDOCalendarWidgetDate {
        let index = Date().get(.day) - 1
        if rdoDates.count <= index { return RDOCalendarWidgetDate() } else { return rdoDates[index] }
    }
    
    var firstDayIndex: Int {
        if rdoDates.count == 0 { return 0 } else {
            if shouldStartFromMonday {
                return rdoDates[0].date.getDayIndexForMonday()
            }
            else {
                return (Calendar.current.dateComponents([.weekday], from: rdoDates[0].date).weekday ?? 0) - 1
            }
        }
    }
}


extension RDOCalendarWidgetEntry {
    
    static var stub: RDOCalendarWidgetEntry {
        RDOCalendarWidgetEntry(date: Date(), rdoDates: RDOCalendarRDODateManager.shared.generateRDODates(), overtime: RDOCalendarOvertimeManager.shared.fetchTotalOvertime())
    }
    
    static var placeholder: RDOCalendarWidgetEntry {
        RDOCalendarWidgetEntry(date: Date(), rdoDates: RDOCalendarRDODateManager.shared.generateRDODates(), overtime: RDOCalendarOvertimeManager.shared.fetchTotalOvertime())
    }
}
