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
        
        let payDays = SheduleManager.shared.getPayDaysForSelectedMonth(firstDayMonth: monthStart, lastDayMonth: monthEnd)
        let vacationDays = getVacationDays(start: monthStart, end: monthEnd)
        let individualVacationDays = SheduleManager.shared.getIVDdateForSelectedMonth(firstDayMonth: monthStart, lastDayMonth: monthEnd)
        let weekends = SheduleManager.shared.getWeekends(firstDayMonth: monthStart, lastDate: monthEnd)
        
        let calendar = RDOCalendar(vacationDays: vacationDays, payDays: payDays, weekends: weekends, individualVacationDays: individualVacationDays)
        
        return RDOCalendarWidgetEntry(date: Date(), calendar: calendar)
    }
    
    public func generateDateRange(from startDate: Date, to endDate: Date) -> [Date] {
        if startDate > endDate { return [] }
        var returnDates: [Date] = []
        var currentDate = startDate
        let calendar: Calendar = Calendar.current
        repeat {
            returnDates.append(currentDate)
            currentDate = calendar.startOfDay(for: calendar.date(
                byAdding: .day, value: 1, to: currentDate)!)
        } while currentDate <= endDate
        return returnDates
    }
    
    public func getVacationDays(start: Date, end: Date) -> [Date] {
        var vacationDates: [Date] = []
        
        let vdmodels = SheduleManager.shared.getVocationDaysForSelectMonth(firstDayMonth: start, lastDayMonth: end)
        
        for model in vdmodels {
            guard let startDate = model.startDate, let endDate = model.endDate else { return vacationDates }
            let dates = generateDateRange(from: startDate, to: endDate)
            vacationDates.append(contentsOf: dates)
        }
        
        return vacationDates
    }
}
