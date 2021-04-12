//
//  Calendar+Ex.swift
//  Summonses
//
//  Created by Admin on 10.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation

extension Calendar {
    
    func dates(byInterval interval: Int, from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date < toDate || Calendar.current.isDate(date, inSameDayAs: toDate) {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: interval, to: date) else { break }
            date = newDate
        }
        
        return dates
    }
    
    func dates(daysCount count: Int, from fromDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        let calendar = Calendar.current
        
        for _ in (0 ..< count) {
            dates.append(date)
            guard let newDate = calendar.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
            
        }
        
        return dates
    }
    
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to) 
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day!
    }
}
