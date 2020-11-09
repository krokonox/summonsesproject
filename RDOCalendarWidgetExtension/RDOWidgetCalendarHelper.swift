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
        let calendar = fetchCalendarDates()
        let today = Date()
        
        var rdoDates: [RDOCalendarWidgetDate] = []
        var dates: [Date] = []
        
        addRDODate(isPayDay: false, isToday: false, isVacation: true, isIVD: false, isWeekend: false, dates: &dates, rdoDates: &rdoDates)
        addRDODate(isPayDay: false, isToday: false, isVacation: false, isIVD: true, isWeekend: false, dates: &dates, rdoDates: &rdoDates)
        addRDODate(isPayDay: false, isToday: false, isVacation: false, isIVD: false, isWeekend: true, dates: &dates, rdoDates: &rdoDates)
        
        for payDay in calendar.payDays {
            if !dates.contains(obj: payDay) {
                dates.append(payDay)
                rdoDates.append(RDOCalendarWidgetDate(date: payDay, isPayDay: true, isToday: false, isWeekend: false, isVacationDay: false, isIndividualVacationDay: false))
            } else {
                guard let index = dates.firstIndex(of: payDay) else { return rdoDates }
                rdoDates[index].isPayDay = true
            }
        }
        
        if dates.contains(obj: Date()) {
            guard let index = dates.firstIndex(of: today) else { return rdoDates}
            rdoDates[index].isToday = true
        }
        
        print(rdoDates.count)
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
}

extension RDOWidgetCalendarHelper {
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
    
    static func addRDODate(isPayDay: Bool, isToday: Bool, isVacation: Bool, isIVD: Bool, isWeekend: Bool, dates: inout [Date], rdoDates: inout [RDOCalendarWidgetDate]) {
        for date in dates {
            dates.append(date)
            let rdoDate = RDOCalendarWidgetDate(date: date, isPayDay: isPayDay, isToday: isToday, isWeekend: isWeekend, isVacationDay: isVacation, isIndividualVacationDay: isIVD)
            rdoDates.append(rdoDate)
        }
    }
}

extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

