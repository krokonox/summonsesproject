//
//  Date+Ex.swift
//  Summonses
//
//  Created by Admin on 09.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation

enum DateName {
    case month
    case day
}

extension Date {
    mutating func addDays(n: Int) {
        let cal = Calendar.current
        self = cal.date(byAdding: .day, value: n, to: self)!
    }
    
    func firstDayOfTheMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
    
    func lastDayOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func getAllDays() -> [Date] {
        var days = [Date]()
        
        let calendar = Calendar.current
        
        let range = calendar.range(of: .day, in: .month, for: self)!
        
        var day = firstDayOfTheMonth()
        
        for _ in 1...range.count {
            days.append(day)
            day.addDays(n: 1)
        }
        
        return days
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    func trimTime() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self))!
    }
    
    func getMonthStart() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }
    
    func getMonthEnd() -> Date {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    var visibleStartDate: Date? {
        get {
            let firstYear = self.getVisibleYears().first!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MM yyyy"
            let date = dateFormatter.date(from: "01 01 \(firstYear)")
            
            return date!
        }
    }
    
    var visibleEndDate: Date? {
        get {
            let lastYear = self.getVisibleYears().last!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MM yyyy"
            let date = dateFormatter.date(from: "31 12 \(lastYear)")
            
            return date!
        }
    }
    
    func getVisibleStartDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        let firstYear = self.getVisibleYears().first!
        let date = dateFormatter.date(from: "01 01 \(firstYear)")
        return date!
    }
    
    func getVisibleEndDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        let lastYear = self.getVisibleYears().last!
        let date = dateFormatter.date(from: "31 12 \(lastYear)")
        return date!
    }
    
    func getVisibleYears() -> [String] {
        
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate)
        
        let previousYear = currentYear - 1
        let nextYear = currentYear + 1
        
        let yearsArray = ["\(previousYear)", "\(currentYear)", "\(nextYear)"]
        
        return yearsArray
    }
    
    func getVisibleYearsForOvertimes() -> [String] {
        var visibleYearsCount = 25
        
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate)
    
        var yearsArray = [String]()
        
        visibleYearsCount -= 1
        
        var startYear = 2017
        let endYear = currentYear
        
        if endYear - startYear  > visibleYearsCount {
            startYear = endYear - visibleYearsCount
        }
        
        for year in startYear...endYear  {
            let array = DataBaseManager.shared.getOvertimesHistory().filter { (overtime) -> Bool in
                return overtime.createDate?.getYear() == "\(year)"
            }
            if !array.isEmpty {
                yearsArray.append("\(year)")
            }
        }
        if yearsArray.isEmpty {
            yearsArray.append("\(endYear)")
        }
        
        return yearsArray
    }
    
    func getmonthNames() -> [String] {
        return ["January", "February", "March", "April", "May",
                        "June", "July", "August", "September", "October", "November", "December"]
    }
    
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM.dd.yy"
        return dateFormatter.string(from: self)
    }
    
    func getTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func getYear() -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        return String(year)
    }
    
    func getMonth() -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        return String(month)
    }

    func getDateName(_ dateType: DateName) -> String {
        let nameFormatter = DateFormatter()
        
        switch dateType {
        case .day:
            nameFormatter.dateFormat = "EEEE"
        case .month:
            nameFormatter.dateFormat = "MMMM"
        }
  
        let name = nameFormatter.string(from: self)
        return name
    }
    
    /// get date by string
    ///
    /// - Returns: Format = "MMM d, HH:mm"
    func getStringDate() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM d, HH:mm"
        return formatter.string(from: self)
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func changeDate(toDate: Date) -> Date {
        let components = Calendar.current.dateComponents([.hour, .minute], from: toDate)
        let timeSecond = (components.hour! * 60 * 60) + (components.minute! * 60)
        return self.trimTime().addingTimeInterval(Double(timeSecond))
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

