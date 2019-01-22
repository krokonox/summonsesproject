//
//  ScheduleManager.swift
//  Summonses
//
//  Created by Smikun Denis on 15.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import Foundation


struct DepartmentModel {
  var departmentType: TypeDepartment
  var squad: TypeSquad
  
  init(departmentType: TypeDepartment, squad: TypeSquad) {
    self.departmentType = departmentType
    self.squad = squad
  }
}

struct SheduleModel {

  let dateFormatter = SheduleManager.shared.dateFormatter
  var department: DepartmentModel
  
  var initialPayDay: Date! {
    let date = dateFormatter.date(from: "12.01.2018")
    return date
  }
  
  var initialWeekDay: Date {
    return getInitialWeekday(with: department.departmentType, squad: department.squad)
  }
  
  func getInitialWeekday(with department: TypeDepartment, squad: TypeSquad) -> Date! {
    
    switch department {
    case .patrol:
      switch squad {
      case .firstSquad:
        return dateFormatter.date(from: "12.01.2017")
      case .secondSquard:
        return dateFormatter.date(from: "02.01.2017")
      case .thirdSquad:
        return dateFormatter.date(from: "07.01.2017")
      }
    case .srg:
      switch squad {
      case .firstSquad:
        return dateFormatter.date(from: "06.01.2017")
      case .secondSquard:
        return dateFormatter.date(from: "04.01.2017")
      case .thirdSquad:
        return dateFormatter.date(from: "02.01.2017")
      }
    }
    
  }
  
}


class SheduleManager: NSObject {
  
  
  public static let shared = SheduleManager()
  
  var department: DepartmentModel! {
    willSet {
      reloadSheduleModel(department: newValue)
    }
  }
  fileprivate var shedule: SheduleModel!
  //MARK: Variables
  
  
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = Calendar.current.timeZone
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter
  }()

  func reloadSheduleModel(department: DepartmentModel) {
    shedule = SheduleModel(department: department)
  }

  
  //MARK: Calculating vacation periods
  
  func getVocationDays() -> [VDModel] {
    return DataBaseManager.shared.getVocationDays()
  }
  
  func getVocationDaysForSelectMonth(firstDayMonth startDate: Date, lastDayMonth endDate: Date) -> [[Date]] {
    
    var vacationDaysDates = [[Date]]()
    let calendar = Calendar.current
    let datesOfPeriod = calendar.dates(byInterval: 1, from: startDate, to: endDate)
    let vdModels = DataBaseManager.shared.getVocationDayByPeriod(datesOfPeriod: datesOfPeriod)
    
    for model in vdModels {
      let vdPeriodDates = calendar.dates(byInterval: 1, from: model.startDate!, to: model.endDate!)
      vacationDaysDates.append(vdPeriodDates)
    }
    
    return vacationDaysDates
  }
  
  func getIVDdateForSelectedMonth(firstDayMonth startDate: Date, lastDayMonth endDate: Date) -> [Date] {
    
    var ivdDates = [Date]()
    
    let calendar = Calendar.current
    let datesOfPeriod = calendar.dates(byInterval: 1, from: startDate, to: endDate)
    let ivdModels = DataBaseManager.shared.getIndividualVocationDayByPeriod(datesOfPeriod: datesOfPeriod)
    
    for model in ivdModels {
      ivdDates.append(model.date!)
    }
    
    return ivdDates
  }
  
  
  //MARK: Calculating pay days
  
  func getPayDaysForSelectedMonth(firstDayMonth startDate: Date, lastDayMonth endDate: Date) -> [Date] {

    let calendar = Calendar.current
    let differenceDays = calendar.dateComponents([.day], from: shedule.initialPayDay, to: startDate)

    guard let difference = differenceDays.day else { fatalError() }

    var r = Double(difference) / 7.0
    r.round(.towardZero)
    var result = Int(r)
    
    if result % 2 != 0 {
      result = result + 1
    }
    
    let calculatedDifference = result * 7
    let firstPayDayCurrentMonth = calendar.date(byAdding: .day, value: calculatedDifference, to: shedule.initialPayDay)
    let dates = calendar.dates(byInterval: 14, from: firstPayDayCurrentMonth!, to: endDate)
    
    return dates
  }
  
  
  //MARK: Calculating weekend days
  
  func getWeekends(firstDayMonth startDate: Date, lastDate: Date) -> [Date] {
    switch shedule.department.departmentType {
    case .patrol:
      return getWeekendsPatrol(firstDayMonth: startDate, lastDate: lastDate)
    case .srg:
      return getWeekendsSRG(firstDayMonth: startDate, lastDate: lastDate)
    }
  }
  
  func getWeekendsPatrol(firstDayMonth startDate: Date, lastDate: Date) -> [Date] {
    
    var dates: [Date] = []
    let calendar = Calendar.current
    let differenceDays = calendar.dateComponents([.day], from: shedule.initialWeekDay, to: startDate)
    
    guard let difference = differenceDays.day else { fatalError() }
    
    var r = Double(difference) / 15.0
    r.round(.towardZero)
    let result = Int(r)
    
    let calculatedDifference = result * 15
    
    let firstDateDoubleWeakend = calendar.date(byAdding: .day, value: calculatedDifference, to: shedule.initialWeekDay)
    let firstDayThreeWeekend = calendar.date(byAdding: .day, value: 7, to: firstDateDoubleWeakend!)
    
    let datesDoubleWeekend = calendar.dates(daysCount: 2, from: firstDateDoubleWeakend!)
    let datesThreeWeekend = calendar.dates(daysCount: 3, from: firstDayThreeWeekend!)
    
    var allDaysFirstWeakends = [Date]()
    allDaysFirstWeakends.append(contentsOf: datesDoubleWeekend)
    allDaysFirstWeakends.append(contentsOf: datesThreeWeekend)

    for dateWeakend in allDaysFirstWeakends {
      let allDates = calendar.dates(byInterval: 15, from: dateWeakend, to: lastDate)
      dates.append(contentsOf: allDates)
    }
    
    return dates
  }
  
  func getWeekendsSRG(firstDayMonth startDate: Date, lastDate: Date) -> [Date] {
    var dates: [Date] = []
    let calendar = Calendar.current
    let differenceDays = calendar.dateComponents([.day], from: shedule.initialWeekDay, to: startDate)
    
    guard let difference = differenceDays.day else { fatalError() }
    var r = Double(difference) / 6.0
    r.round(.towardZero)
    let result = Int(r)
    
    let calculatedDifference = result * 6
    
    let firstDateWeekend = calendar.date(byAdding: .day, value: calculatedDifference, to: shedule.initialWeekDay)
    let datesWeekend = calendar.dates(daysCount: 2, from: firstDateWeekend!)
    
    for dateWeekend in datesWeekend {
      let allDates = calendar.dates(byInterval: 6, from: dateWeekend, to: lastDate)
      dates.append(contentsOf: allDates)
    }
    
    return dates
  }
  
}


