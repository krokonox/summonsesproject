//
//  RDOWidgetCalendarHelper.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 07.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation

class RDOCalendarRDODateManager {
    
    public static let shared = RDOCalendarRDODateManager()
    
    var displayOptions: DaysDisplayedModel!
    var calendar: RDOCalendar!
        
    static let weekDayFromSunday = ["S", "M", "T", "W", "T", "F", "S"]
    static let weekDayFromMonday = ["M", "T", "W", "T", "F", "S", "S"]
    
    init() {
        DataBaseManager.shared.setupDatabase()
    }
    
    func generateRDODates() -> [RDOCalendarWidgetDate] {
        setupOptions()
        
        calendar = fetchCalendarDates()
        
        let today = Date().get(.day) - 1
        let days = Date().getAllDays()
        var rdoDates: [RDOCalendarWidgetDate] = []
        var dates: [Date] = []
        

        addRDODate(isPayDay: false, isToday: false, isVacation: false, isIVD: true, isWeekend: false, dates: &dates, rdoDates: &rdoDates, calendarDates: calendar.individualVacationDays)
        addRDODate(isPayDay: false, isToday: false, isVacation: true, isIVD: false, isWeekend: false, dates: &dates, rdoDates: &rdoDates, calendarDates: calendar.vacationDays)
        addRDODate(isPayDay: false, isToday: false, isVacation: false, isIVD: false, isWeekend: true, dates: &dates, rdoDates: &rdoDates, calendarDates: calendar.weekends)
        
        getPayDays(dates: &dates, rdoDates: &rdoDates)
        getNoneDays(dates: &dates, rdoDates: &rdoDates, days: days)
        
        rdoDates.sort(by: { $0.date.compare($1.date) == ComparisonResult.orderedAscending})
        rdoDates[today].isToday = true
        
        return rdoDates
    }
    
    private func fetchCalendarDates() -> RDOCalendar {
        let monthStart = Date().firstDayOfTheMonth()
        let monthEnd = Date().lastDayOfMonth()
        var vacationDays: [Date] = []
        var ivd: [Date] = []
        
        if displayOptions.showVocationDays {
             vacationDays = getVacationDays(start: monthStart, end: monthEnd)
             ivd = SheduleManager.shared.getIVDdateForSelectedMonth(firstDayMonth: monthStart, lastDayMonth: monthEnd).filter {$0.isBetween(monthStart, and: monthEnd)}
        }
        
        let payDays = SheduleManager.shared.getPayDaysForSelectedMonth(firstDayMonth: monthStart, lastDayMonth: monthEnd).filter {$0.isBetween(monthStart, and: monthEnd)}
        let weekends = SheduleManager.shared.getWeekends(firstDayMonth: monthStart, lastDate: monthEnd).filter {$0.isBetween(monthStart, and: monthEnd)}
        let calendar = RDOCalendar(vacationDays: vacationDays, payDays: payDays, weekends: weekends, individualVacationDays: ivd)
        return calendar
    }
}

extension RDOCalendarRDODateManager {
    func generateDateRange(from startDate: Date, to endDate: Date) -> [Date] {
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

extension RDOCalendarRDODateManager {
    private func getVacationDays(start: Date, end: Date) -> [Date] {
        var vacationDates: [Date] = []
        
        if displayOptions.showVocationDays {
            let vdmodels = SheduleManager.shared.getVocationDaysForSelectMonth(firstDayMonth: start, lastDayMonth: end)
            
            for model in vdmodels {
                guard let startDate = model.startDate, let endDate = model.endDate else { return vacationDates }
                let dates = generateDateRange(from: startDate, to: endDate)
                vacationDates.append(contentsOf: dates)
            }
        }
        return vacationDates
    }
    
    private func getPayDays(dates: inout [Date], rdoDates: inout [RDOCalendarWidgetDate]) {
        if displayOptions.showPayDays {
            for payDay in calendar.payDays {
                if !dates.contains(obj: removeTimeStamp(fromDate: payDay)) {
                    dates.append(removeTimeStamp(fromDate: payDay))
                    rdoDates.append(RDOCalendarWidgetDate(date: payDay, isPayDay: true, isToday: false, isWeekend: false, isVacationDay: false, isIndividualVacationDay: false))
                } else {
                    guard let index = dates.firstIndex(of: removeTimeStamp(fromDate: payDay)) else { return }
                    rdoDates[index].isPayDay = true
                }
            }
        }
    }

    private func getNoneDays(dates: inout [Date], rdoDates: inout [RDOCalendarWidgetDate], days: [Date]) {
        for day in days {
            if !dates.contains(obj: removeTimeStamp(fromDate: day)) {
                dates.append(removeTimeStamp(fromDate: day))
                rdoDates.append(RDOCalendarWidgetDate(date: day, isPayDay: false, isToday: false, isWeekend: false, isVacationDay: false, isIndividualVacationDay: false))
            }
        }
    }
}

extension RDOCalendarRDODateManager {
    private func addRDODate(isPayDay: Bool, isToday: Bool, isVacation: Bool, isIVD: Bool, isWeekend: Bool, dates: inout [Date], rdoDates: inout [RDOCalendarWidgetDate], calendarDates: [Date]) {
        for date in calendarDates {
            if !dates.contains(obj: removeTimeStamp(fromDate: date)) {
                dates.append(removeTimeStamp(fromDate: date))
                let rdoDate = RDOCalendarWidgetDate(date: date, isPayDay: isPayDay, isToday: isToday, isWeekend: isWeekend, isVacationDay: isVacation, isIndividualVacationDay: isIVD)
                rdoDates.append(rdoDate)
            }
        }
    }
}

extension RDOCalendarRDODateManager {
    public func removeTimeStamp(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
}

extension RDOCalendarRDODateManager {
    private func setupOptions() {
        displayOptions = DataBaseManager.shared.getShowOptions()
        SheduleManager.shared.department = DepartmentModel(departmentType: displayOptions.department, squad: displayOptions.squad)
    }
}
