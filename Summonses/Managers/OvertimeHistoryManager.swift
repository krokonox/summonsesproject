//
//  OvertimeHistoryManager.swift
//  Summonses
//
//  Created by Vlad Lavrenkov on 1/23/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import Foundation

class OvertimeHistoryManager: NSObject {
	
	public static let shared = OvertimeHistoryManager()
	
	//MARK: - get times
	func getTotalCashInMonth(month: String, overtimes: [OvertimeModel]) -> Int {
		var minutes = 0
		_ = overtimes.map({ (overtimeModel) -> Void in
			if overtimeModel.type == "Cash" && overtimeModel.createDate?.getMonth() == month{
				minutes += overtimeModel.totalOvertimeWorked
			}
		})
		return minutes
	}
	
	func getTotalCashInMonthWithPaidDetail(month: String, overtimes: [OvertimeModel]) -> Int {
		var minutes = 0
		_ = overtimes.map({ (overtimeModel) -> Void in
			if overtimeModel.type == "Paid Detail" && overtimeModel.createDate?.getMonth() == month{
				minutes += overtimeModel.totalActualTime
			}
		})
		return minutes
	}
	
	func getTotalTimeInMonth(month: String, overtimes: [OvertimeModel]) -> Int {
		var minutes = 0
		_ = overtimes.map({ (overtimeModel) -> Void in
			if overtimeModel.type == "Time" && overtimeModel.createDate?.getMonth() == month{
				minutes += overtimeModel.totalOvertimeWorked
			}
		})
		return minutes
	}
	
	func getQuaterTotalTime(months: [String], overtimes: [OvertimeModel]) -> Int {
		var totalMinutes = 0
		_ = overtimes.map({ (overtimeModel) -> Void in
			if months.contains((overtimeModel.createDate?.getMonth())!) {
				totalMinutes += overtimeModel.totalOvertimeWorked
			}
		})
		
		return totalMinutes
	}
	
	func getTotalCash(overtimes: [OvertimeModel]) -> Int {
		var minutes = 0
		_ = overtimes.map({ (overtimeModel) -> Void in
			if overtimeModel.type == "Cash" {
				minutes += overtimeModel.totalOvertimeWorked
			}
		})
		return minutes
	}
	
	func getTotalTime(overtimes: [OvertimeModel]) -> Int {
		var minutes = 0
		_ = overtimes.map({ (overtimeModel) -> Void in
			if overtimeModel.type == "Time" {
				minutes += overtimeModel.totalOvertimeWorked
			}
		})
		return minutes
	}
	
}
