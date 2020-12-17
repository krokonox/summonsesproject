//
//  RDOCalendarDate.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 05.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import SwiftUI

struct RDOCalendarWidgetDate: Hashable {
    var date: Date
    
    var isPayDay: Bool = false
    var isToday: Bool = false
    var isWeekend: Bool = false
    var isVacationDay: Bool = false
    var isIndividualVacationDay: Bool = false
    
    var appearance = RDOCalendarWidgetAppearanceSettings()
        
    init(date: Date, isPayDay: Bool, isToday: Bool, isWeekend: Bool, isVacationDay: Bool, isIndividualVacationDay: Bool) {
        self.date = date
        self.isPayDay = isPayDay
        self.isToday = isToday
        self.isWeekend = isWeekend
        self.isVacationDay = isVacationDay
        self.isIndividualVacationDay = isIndividualVacationDay
    }
    
    // Empty RDODate
    
    init() {
        self.date = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
        self.isPayDay = false
        self.isToday = false
        self.isWeekend = false
        self.isVacationDay = false
        self.isIndividualVacationDay = false
    }
    
    public static func == (lhs: RDOCalendarWidgetDate, rhs: RDOCalendarWidgetDate) -> Bool {
        return
            lhs.date == rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
    }
    
    func getText() -> String {
        let day = formatDate(date: date, calendar: Calendar.current)
        return day
    }
    
    func getTextColor() -> Color {
        var textColor: Color = Color("baseTextColor")
        
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
            backgroundColor = Color("vacationDayBackgroundColor")
        }
        if isWeekend {
            backgroundColor = appearance.weekendDayBackgroundViewColor
        }
        if isIndividualVacationDay {
            backgroundColor = appearance.ivdBackgroundViewColor
        }
        return backgroundColor
    }
    
    func getPayDayBackgroundColor() -> Color {
        var backgroundColor = Color.clear
        
        if isPayDay {
            backgroundColor = appearance.payDayViewBackgroundColor
        }
        
        if (isWeekend && isPayDay) || (isIndividualVacationDay && isPayDay) {
            backgroundColor = appearance.whitePayDayViewBackgroundColor
        }
        
        return backgroundColor
    }
    
    func getCornerRadius() -> CGFloat {
        var cornerRadius = CGFloat(0)
        
        if !isWeekend || !isVacationDay || !isIndividualVacationDay {
            cornerRadius = CGFloat(10)
        }
        return cornerRadius
    }
    
    func getBorderColor() -> Color {
        var borderColor = Color.clear
        
        if isToday {
            borderColor = Color("borderColor")
        }
        
        if isToday && isWeekend {
            borderColor = Color("weekendBorderColor")
        }
        return borderColor
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

struct RDOCalendarWidgetDate_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
