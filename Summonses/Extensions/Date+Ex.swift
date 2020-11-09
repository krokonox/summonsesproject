//
//  Date+Ex.swift
//  Summonses
//
//  Created by Admin on 09.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation

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
}
