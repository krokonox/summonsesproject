//
//  RDOCalendarDate.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 05.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import SwiftUI

struct RDOCalendarWidgetDate {
    var date: Date
    
    var isPayDay: Bool = false
    var isToday: Bool = false
    var isWeekend: Bool = false
    var isVacationDay: Bool = false
    var isIndividualVacationDay: Bool = false
    
    var appearance = RDOCalendarWidgetAppearanceSettings()
    
    init(date: Date, isPayDay: Bool, isToday: Bool, isWeekend: Bool, isVacationDay: Bool) {
        self.date = date
        self.isPayDay = isPayDay
        self.isToday = isToday
        self.isWeekend = isWeekend
        self.isVacationDay = isVacationDay
    }
    
    func getText() -> String {
        let day = formatDate(date: date, calendar: Calendar.current)
        return day
    }
    
    func getTextColor() -> Color {
        var textColor = Color.black
        
        if isVacationDay {
            textColor = appearance.vacationDayTextLabelColor
        }
        if isWeekend {
            textColor = appearance.weekendDayTextLabelColor
        }
        if isIndividualVacationDay {
            textColor = appearance.ivdTextLabelColor
        }
        return textColor
    }
    
    func getBackgroundColor() -> Color {
        var backgroundColor = Color.clear
        
        if isVacationDay {
            backgroundColor = appearance.vacationPayDayViewBackgroundColor
        }
        if isWeekend {
            backgroundColor = appearance.weekendDayBackgroundViewColor
        }
        if isIndividualVacationDay {
            backgroundColor = appearance.ivdBackgroundViewColor
        }
        return backgroundColor
    }
    
    
    // MARK: - Date Formats
    
    func formatDate(date: Date, calendar: Calendar) -> String {
        let formatter = dateFormatter()
        return stringFrom(date: date, formatter: formatter, calendar: calendar)
    }
    
    func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "d"
        return formatter
    }
    
    func stringFrom(date: Date, formatter: DateFormatter, calendar: Calendar) -> String {
        if formatter.calendar != calendar {
            formatter.calendar = calendar
        }
        return formatter.string(from: date)
    }
}
