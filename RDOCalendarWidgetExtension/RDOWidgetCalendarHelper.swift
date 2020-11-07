//
//  RDOWidgetCalendarHelper.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 07.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation

class RDOWidgetCalendarHelper {

    static func generateRDODates() -> [RDOCalendarWidgetDate] {
        var calendar = fetchCalendarDates()
        var rdoDates: [RDOCalendarWidgetDate] = []
        
        for vDay in calendar.vacationDays {}
        
        for IVDay in calendar.vacationDays {}
        
        for current in calendar.vacationDays {}
        
        for weekend in calendar.vacationDays {}
        
        for payDay in calendar.vacationDays {}
        
        return rdoDates
    }
    
    static func fetchCalendarDates() -> RDOCalendar {
        let monthStart = Date().getMonthStart()
        let monthEnd = Date().getMonthEnd()
        
        let payDays = SheduleManager.shared.getPayDaysForSelectedMonth(firstDayMonth: monthStart, lastDayMonth: monthEnd)
        let vacationDays = getVacationDays(start: monthStart, end: monthEnd)
        let individualVacationDays = SheduleManager.shared.getIVDdateForSelectedMonth(firstDayMonth: monthStart, lastDayMonth: monthEnd)
        let weekends = SheduleManager.shared.getWeekends(firstDayMonth: monthStart, lastDate: monthEnd)
        
        let calendar = RDOCalendar(vacationDays: vacationDays, payDays: payDays, weekends: weekends, individualVacationDays: individualVacationDays)
        
        return calendar
    }
    
    static func getVacationDays(start: Date, end: Date) -> [Date] {
        var vacationDates: [Date] = []
        
        let vdmodels = SheduleManager.shared.getVocationDaysForSelectMonth(firstDayMonth: start, lastDayMonth: end)
        
        for model in vdmodels {
            guard let startDate = model.startDate, let endDate = model.endDate else { return vacationDates }
            let dates = generateDateRange(from: startDate, to: endDate)
            vacationDates.append(contentsOf: dates)
        }
        
        return vacationDates
    }
    
    static func generateDateRange(from startDate: Date, to endDate: Date) -> [Date] {
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
}
