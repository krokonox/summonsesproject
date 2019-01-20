//
//  ScheduleManager.swift
//  Summonses
//
//  Created by Smikun Denis on 15.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import Foundation


class SheduleManager: NSObject {
  
  enum Squad {
    case firstSquad
    case secondSquard
    case thirdSquad
  }
  
  public static let shared = SheduleManager()
  
  //MARK: Variables
  
  
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = Calendar.current.timeZone
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter
  }()
  
  var initialPayDay: Date! {
      let date = dateFormatter.date(from: "12.01.2018")
      return date
  }
  
  var initialWeakDay: Date! {
    let date = dateFormatter.date(from: "7.01.2017")
    return date
  }
  
  //MARK: Functions
  
//  func getVocationDays() -> [[Date]] {
//    var vocationDaysDates = [[Date]]()
//    let calendar = Calendar.current
//
//    let vdModels = DataBaseManager.shared.getVocationDays()
//
//    for model in vdModels {
//      let vdPeriodDates = calendar.dates(byInterval: 1, from: model.startDate!, to: model.endDate!)
//      vocationDaysDates.append(vdPeriodDates)
//    }
//
//    return vocationDaysDates
//  }

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
  
  func getPayDaysForSelectedMonth(firstDayMonth startDate: Date, lastDayMonth endDate: Date) -> [Date] {

/* Алгоритм
    1. Ищем количество дней, от константного дня до первого дня выбранного месяца
    2. Результат делим на 7 и отбрасываем остаток
    3. Если число нечетное, тогда делаем +1
    4. Умножаем на 7
    5. В результате у нас получится первая пятница которая нам нужна в нашем месяце
    6. Дальше через интервал в 14 дней мы обозначаем другие нужные нам пятницы в этом месяце
 */
    let calendar = Calendar.current
    let differenceDays = calendar.dateComponents([.day], from: initialPayDay, to: startDate)

    guard let difference = differenceDays.day else { fatalError() }

    var r = Double(difference) / 7.0
    r.round(.towardZero)
    var result = Int(r)
    
    if result % 2 != 0 {
      result = result + 1
    }
    
    let calculatedDifference = result * 7
    let firstPayDayCurrentMonth = calendar.date(byAdding: .day, value: calculatedDifference, to: initialPayDay)
    let dates = calendar.dates(byInterval: 14, from: firstPayDayCurrentMonth!, to: endDate)
    
    return dates
  }
  
  func getWeakends(firstDayMonth startDate: Date, lastDate: Date) -> [Date] {
    
    var dates: [Date] = []
    
    let calendar = Calendar.current
    let differenceDays = calendar.dateComponents([.day], from: initialWeakDay, to: startDate)
    
    guard let difference = differenceDays.day else { fatalError() }
    var r = Double(difference) / 7.0
    r.round(.towardZero)
    var result = Int(r)
    
    if result % 2 != 0 {
      result = result + 1
    }
    
    let calculatedDifference = result * 7
    
    //первая и последняя даты первого уикенда месяца (2 дня)
      let firstDateDoubleWeakend = calendar.date(byAdding: .day, value: calculatedDifference, to: initialWeakDay)
      let lastDateDoubleWeakend = calendar.date(byAdding: .day, value: 1, to: firstDateDoubleWeakend!)
    
    //Все даты первого уикенда
      let datesWeakend = [firstDateDoubleWeakend, lastDateDoubleWeakend]
    
    for dateWeakend in datesWeakend {
      let allDates = calendar.dates(byInterval: 15, from: dateWeakend!, to: lastDate)
      dates.append(contentsOf: allDates)
    }
    
    return dates
  }
  
 
  
  
}


