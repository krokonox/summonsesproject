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
			var cashInModel = 0
			var timeInModel = 0
			if overtimeModel.createDate?.getMonth() == month{
				//get total cash
				if overtimeModel.typeTravelTime == "Cash" {
//					cashMinutes += overtimeModel.travelMinutes
						cashInModel += overtimeModel.travelMinutes
				}
				
				if overtimeModel.splitCashMinutes != 0 {
//					cashMinutes += overtimeModel.splitCashMinutes
						cashInModel += overtimeModel.splitCashMinutes
				} else {
					if overtimeModel.type == "Cash" {
//						cashMinutes += overtimeModel.totalOvertimeWorked
							cashInModel += overtimeModel.totalOvertimeWorked
					}
				}
				
				//get time
				if overtimeModel.typeTravelTime == "Time" {
//					timeMinutes += overtimeModel.travelMinutes
					timeInModel += overtimeModel.travelMinutes
				}
				if overtimeModel.splitTimeMinutes != 0 {
//					timeMinutes += overtimeModel.splitTimeMinutes
					timeInModel += overtimeModel.splitTimeMinutes
				} else {
					if overtimeModel.type == "Time" {
//						timeMinutes += overtimeModel.totalOvertimeWorked
						timeInModel += overtimeModel.totalOvertimeWorked
					}
				}
				
				cashMinutes += cashInModel
				timeMinutes += timeInModel
				earned += cashInModel.setEarned(price: overtimeModel.overtimeRate)
			}
		})
		return (cashMinutes, timeMinutes, earned)
	}
	
	func getTotalCashInMonthWithPaidDetail(month: String, overtimes: [OvertimeModel]) -> (cash:Int, earned: Double) {
		var minutes = 0
		var earned = 0.0
		_ = overtimes.map({ (overtimeModel) -> Void in
			var cashInModel = 0
			if overtimeModel.type == "Paid Detail" && overtimeModel.createDate?.getMonth() == month{
				cashInModel += overtimeModel.totalActualTime
				earned += cashInModel.setEarned(price: overtimeModel.overtimeRate)
			}
			minutes += cashInModel
		})
		return (minutes, earned)
	}
	
	func getQuaterTotalTime(months: [String], overtimes: [OvertimeModel]) -> Int {
		var totalMinutes = 0
		_ = overtimes.map({ (overtimeModel) -> Void in
			if months.contains((overtimeModel.createDate?.getMonth())!) {
//				totalMinutes += overtimeModel.travelMinutes
				
				if overtimeModel.typeTravelTime == "Cash" {
					totalMinutes += overtimeModel.travelMinutes
				}
				
				if overtimeModel.splitCashMinutes != 0 {
					totalMinutes += overtimeModel.splitCashMinutes
				} else {
					if overtimeModel.type == "Cash" {
						totalMinutes += overtimeModel.totalOvertimeWorked
					}
				}
				
				//get time
				if overtimeModel.typeTravelTime == "Time" {
					totalMinutes += overtimeModel.travelMinutes
				}
				if overtimeModel.splitTimeMinutes != 0 {
					totalMinutes += overtimeModel.splitTimeMinutes
				} else {
					if overtimeModel.type == "Time" {
						totalMinutes += overtimeModel.totalOvertimeWorked
					}
				}
			}
		})
		
		return totalMinutes
	}
	
	func getTotalOvertime(overtimes: [OvertimeModel]) -> (cash:Int, time:Int, earned: Double) {
		var cashMinutes = 0
		var timeMinutes = 0
		var earned = 0.0
		_ = overtimes.map({ (overtimeModel) -> Void in
			var cashInModel = 0
			var timeInModel = 0
			//get total cash
			if overtimeModel.typeTravelTime == "Cash" {
//				cashMinutes += overtimeModel.travelMinutes
				cashInModel += overtimeModel.travelMinutes
			}
			
			if overtimeModel.splitCashMinutes != 0 {
//				cashMinutes += overtimeModel.splitCashMinutes
				cashInModel += overtimeModel.splitCashMinutes
			} else {
				if overtimeModel.type == "Cash" {
//					cashMinutes += overtimeModel.totalOvertimeWorked
					cashInModel += overtimeModel.totalOvertimeWorked
				}
			}
			
			//get time
			if overtimeModel.typeTravelTime == "Time" {
//				timeMinutes += overtimeModel.travelMinutes
				timeInModel += overtimeModel.travelMinutes
			}
			if overtimeModel.splitTimeMinutes != 0 {
//				timeMinutes += overtimeModel.splitTimeMinutes
				timeInModel += overtimeModel.splitTimeMinutes
			} else {
				if overtimeModel.type == "Time" {
//					timeMinutes += overtimeModel.totalOvertimeWorked
					timeInModel += overtimeModel.totalOvertimeWorked
				}
			}
			
			cashMinutes += cashInModel
			timeMinutes += timeInModel
			earned += cashInModel.setEarned(price: overtimeModel.overtimeRate)
		})
        print(cashMinutes)
		return (cashMinutes, timeMinutes, earned)
	}
	
	func getTotalPaidDetail(overtimes: [OvertimeModel]) -> (cash:Int, earned: Double) {
		var minutes = 0
		var earned = 0.0
		_ = overtimes.map({ (overtimeModel) -> Void in
			var cashInModel = 0
			if overtimeModel.type == "Paid Detail" {
				cashInModel += overtimeModel.totalActualTime
				earned += cashInModel.setEarned(price: overtimeModel.overtimeRate)
			}
			minutes += cashInModel
		})
		return (minutes, earned)
	}
}
