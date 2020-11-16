//
//  RDOCalendarOvertimeManager.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 14.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation

class RDOCalendarOvertimeManager {
    public static let shared = RDOCalendarOvertimeManager()
    var overtimeArray: [OvertimeModel] = []
    
    func fetchTotalOvertime() -> (cash: Int, time: Int, earned: Double) {
        overtimeArray = getOvertimeTotals(currentYear: Date().getYear())
        return OvertimeHistoryManager.shared.getTotalOvertime(overtimes: overtimeArray)
    }
    
    private func getOvertimeTotals(currentYear: String) -> [OvertimeModel] {
        return DataBaseManager.shared.getOvertimesHistory().filter { (overtime) -> Bool in
            return overtime.createDate?.getYear() == currentYear
        }
    }
}
