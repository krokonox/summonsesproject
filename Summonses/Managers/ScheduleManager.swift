//
//  ScheduleManager.swift
//  Summonses
//
//  Created by Smikun Denis on 15.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import Foundation

class SheduleManager: NSObject {
  
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
  
  //MARK: Functions
  
  func getPayDaysForSelectedMonth(date: Date) { //rename: first day of month
    let diffInDays = Calendar.current.dateComponents([.day], from: initialPayDay, to: date)
    
/* Алгоритм
    1. Ищем количество дней, от константного дня до первого дня выбранного месяца
    2. Результат делим на 7 и отбрасываем остаток
    3. Если число нечетное, тогда делаем +1
    4. Умножаем на 7
    5. В результате у нас получится первая пятница которая нам нужна в нашем месяце
    6. Дальше через интервал в 14 дней мы обозначаем другие нужные нам пятницы в этом месяце
 */
    guard let diffDays = diffInDays.day else { return }
    var result: Double = Double(diffDays) / Double(7)

  }
  
  
}
