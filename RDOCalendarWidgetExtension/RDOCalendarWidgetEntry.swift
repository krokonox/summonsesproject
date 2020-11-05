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
    public let date: Date
    var calendar: RDOCalendar
}

extension RDOCalendarWidgetEntry {

    static var stub: RDOCalendarWidgetEntry {
        RDOCalendarWidgetEntry(date: Date(), calendar: RDOCalendar(vacationDays: [], payDays: [], weekends: [], individualVacationDays: []))
    }
    
    static var placeholder: RDOCalendarWidgetEntry {
        RDOCalendarWidgetEntry(date: Date(), calendar: RDOCalendar(vacationDays: [], payDays: [], weekends: [], individualVacationDays: []))
    }
}
