//
//  RDOWidgetCalendarHelper.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 07.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation

class RDOCalendarRDODateManager {
    
    static let fullWeekDayNames = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    static let shortWeekDayNames = ["S", "M", "T", "W", "T", "F", "S"]
    
    static func generateRDODates() -> [RDOCalendarWidgetDate] {
        let calendar = fetchCalendarDates()
        let today = Date().get(.day) - 1
        let days = Date().getAllDays()
        var rdoDates: [RDOCalendarWidgetDate] = []
        var dates: [Date] = []
    
        addRDODate(isPayDay: false, isToday: false, isVacation: true, isIVD: false, isWeekend: false, dates: &dates, rdoDates: &rdoDates, calendarDates: calendar.vacationDays)
        addRDODate(isPayDay: false, isToday: false, isVacation: false, isIVD: true, isWeekend: false, dates: &dates, rdoDates: &rdoDates, calendarDates: calendar.individualVacationDays)
        addRDODate(isPayDay: false, isToday: false, isVacation: false, isIVD: false, isWeekend: true, dates: &dates, rdoDates: &rdoDates, calendarDates: calendar.weekends)
        
        for payDay in calendar.payDays {
            if !dates.contains(obj: payDay) {
                dates.append(payDay)
                rdoDates.append(RDOCalendarWidgetDate(date: payDay, isPayDay: true, isToday: false, isWeekend: false, isVacationDay: false, isIndividualVacationDay: false))
            } else {
                guard let index = dates.firstIndex(of: payDay) else { return rdoDates }
                rdoDates[index].isPayDay = true
            }
        }
        
        for day in days {
            if !dates.contains(obj: day) {
                dates.append(day)
                rdoDates.append(RDOCalendarWidgetDate(date: day, isPayDay: false, isToday: false, isWeekend: false, isVacationDay: false, isIndividualVacationDay: false))
            }
        }
        
        rdoDates.sort(by: { $0.date.compare($1.date) == ComparisonResult.orderedAscending})
        rdoDates[today].isToday = true
        return rdoDates
    }
    
    static func fetchCalendarDates() -> RDOCalendar {
        let monthStart = Date().firstDayOfTheMonth()
        let monthEnd = Date().lastDayOfMonth()
        
        let payDays = SheduleManager.shared.getPayDaysForSelectedMonth(firstDayMonth: monthStart, lastDayMonth: monthEnd).filter {$0.isBetween(monthStart, and: monthEnd)}
        let vacationDays = getVacationDays(start: monthStart, end: monthEnd)
        let individualVacationDays = SheduleManager.shared.getIVDdateForSelectedMonth(firstDayMonth: monthStart, lastDayMonth: monthEnd).filter {$0.isBetween(monthStart, and: monthEnd)}
        let weekends = SheduleManager.shared.getWeekends(firstDayMonth: monthStart, lastDate: monthEnd).filter {$0.isBetween(monthStart, and: monthEnd)}
        
        let calendar = RDOCalendar(vacationDays: vacationDays, payDays: payDays, weekends: weekends, individualVacationDays: individualVacationDays)
        return calendar
    }
}

extension RDOCalendarRDODateManager {
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
    
    static func addRDODate(isPayDay: Bool, isToday: Bool, isVacation: Bool, isIVD: Bool, isWeekend: Bool, dates: inout [Date], rdoDates: inout [RDOCalendarWidgetDate], calendarDates: [Date]) {
        for date in calendarDates {
            dates.append(date)
            let rdoDate = RDOCalendarWidgetDate(date: date, isPayDay: isPayDay, isToday: isToday, isWeekend: isWeekend, isVacationDay: isVacation, isIndividualVacationDay: isIVD)
            rdoDates.append(rdoDate)
        }
    }
}
