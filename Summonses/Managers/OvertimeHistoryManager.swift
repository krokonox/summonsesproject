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
	func getTotalCashInMonth(month: String, overtimes: [OvertimeModel]) -> (cash:Int, time:Int, earned: Double) {
		var cashMinutes = 0
		var timeMinutes = 0
		var earned = 0.0
		
		_ = overtimes.map({ (overtimeModel) -> Void in
			
			if overtimeModel.createDate?.getMonth() == month{
				//get total cash
				if overtimeModel.typeTravelTime == "Cash" {
					cashMinutes += overtimeModel.travelMinutes
				}
				
				if overtimeModel.splitCashMinutes != 0 {
					cashMinutes += overtimeModel.splitCashMinutes
				} else {
					if overtimeModel.type == "Cash" {
						cashMinutes += overtimeModel.totalOvertimeWorked
					}
				}
				
				//get time
				if overtimeModel.typeTravelTime == "Time" {
					timeMinutes += overtimeModel.travelMinutes
				}
				if overtimeModel.splitTimeMinutes != 0 {
					timeMinutes += overtimeModel.splitTimeMinutes
				} else {
					if overtimeModel.type == "Time" {
						timeMinutes += overtimeModel.totalOvertimeWorked
					}
				}
				earned += cashMinutes.setEarned(price: overtimeModel.overtimeRate)
			}
		})
		return (cashMinutes, timeMinutes, earned)
	}
	
	func getTotalCashInMonthWithPaidDetail(month: String, overtimes: [OvertimeModel]) -> (cash:Int, earned: Double) {
		var minutes = 0
		var earned = 0.0
		_ = overtimes.map({ (overtimeModel) -> Void in
			if overtimeModel.type == "Paid Detail" && overtimeModel.createDate?.getMonth() == month{
				minutes += overtimeModel.totalActualTime
				earned += minutes.setEarned(price: overtimeModel.overtimeRate)
			}
		})
		return (minutes, earned)
	}
	
	func getQuaterTotalTime(months: [String], overtimes: [OvertimeModel]) -> Int {
		var totalMinutes = 0
		_ = overtimes.map({ (overtimeModel) -> Void in
			if months.contains((overtimeModel.createDate?.getMonth())!) {
				totalMinutes += overtimeModel.totalOvertimeWorked
				totalMinutes += overtimeModel.travelMinutes
			}
		})
		
		return totalMinutes
	}
	
	func getTotalOvertime(overtimes: [OvertimeModel]) -> (cash:Int, time:Int, earned: Double) {
		var cashMinutes = 0
		var timeMinutes = 0
		var earned = 0.0
		_ = overtimes.map({ (overtimeModel) -> Void in
			
			//get total cash
			if overtimeModel.typeTravelTime == "Cash" {
				cashMinutes += overtimeModel.travelMinutes
			}
			
			if overtimeModel.splitCashMinutes != 0 {
				cashMinutes += overtimeModel.splitCashMinutes
			} else {
				if overtimeModel.type == "Cash" {
					cashMinutes += overtimeModel.totalOvertimeWorked
				}
			}
			
			//get time
			if overtimeModel.typeTravelTime == "Time" {
				timeMinutes += overtimeModel.travelMinutes
			}
			if overtimeModel.splitTimeMinutes != 0 {
				timeMinutes += overtimeModel.splitTimeMinutes
			} else {
				if overtimeModel.type == "Time" {
					timeMinutes += overtimeModel.totalOvertimeWorked
				}
			}
			
			earned += cashMinutes.setEarned(price: overtimeModel.overtimeRate)
		})
		return (cashMinutes, timeMinutes, earned)
	}
	
	func getTotalPaidDetail(overtimes: [OvertimeModel]) -> (cash:Int, earned: Double) {
		var minutes = 0
		var earned = 0.0
		_ = overtimes.map({ (overtimeModel) -> Void in
			if overtimeModel.type == "Paid Detail" {
				minutes += overtimeModel.totalActualTime
				earned += minutes.setEarned(price: overtimeModel.overtimeRate)
			}
		})
		return (minutes, earned)
	}
}
