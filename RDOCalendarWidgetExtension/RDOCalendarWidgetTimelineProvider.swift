//
//  RDOCalendarWidgetTimelineProvider.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 04.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation
import WidgetKit

struct RDOCalendarWidgetTimelineProvider: TimelineProvider {
    
    typealias Entry = RDOCalendarWidgetEntry
    let scheduleManager = SheduleManager.shared
 
    func placeholder(in context: Context) -> RDOCalendarWidgetEntry {
        RDOCalendarWidgetEntry.placeholder
    }
    
    func getSnapshot(in context: Context, completion: @escaping (RDOCalendarWidgetEntry) -> Void) {
        if context.isPreview {
            completion(RDOCalendarWidgetEntry.placeholder)
        } else {
            let entry = fetchCalendarDates()
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<RDOCalendarWidgetEntry>) -> Void) {
        let dayInterval = 60 * 60 * 24
        let entry = fetchCalendarDates()
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(TimeInterval(dayInterval))))
        completion(timeline)
    }
}

extension RDOCalendarWidgetTimelineProvider {
    private func fetchCalendarDates() -> RDOCalendarWidgetEntry {
        let monthStart = Date().getMonthStart()
        let monthEnd = Date().getMonthEnd()
        
        let payDays = scheduleManager.getPayDaysForSelectedMonth(firstDayMonth: monthStart, lastDayMonth: monthEnd)
        let vacationDays = scheduleManager.getVocationDays()
        let individualVacationDays = scheduleManager.getIVDdateForSelectedMonth(firstDayMonth: monthStart, lastDayMonth: monthEnd)
        let weekends = scheduleManager.getWeekends(firstDayMonth: monthStart, lastDate: monthEnd)
        
        var calendar = RDOCalendar(vacationDays: vacationDays, payDays: payDays, weekends: weekends, individualVacationDays: individualVacationDays)
        
        return RDOCalendarWidgetEntry(date: Date(), calendar: calendar)
    }
}
