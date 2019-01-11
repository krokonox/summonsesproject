//
//  VDModel.swift
//  Summonses
//
//  Created by Smikun Denis on 09.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import RealmSwift

class VDModel: NSObject {
  
  var id = UUID().uuidString
  var startDate: Date?
  var endDate: Date?
  
  override init() {
    super.init()
  }
  
  init(startDate: Date, endDate: Date) {
    self.startDate = startDate
    self.endDate = endDate
  }
  
  func getYear() -> String {
    
    let calendar = Calendar.current
    let year = calendar.component(.year, from: self.startDate!)
    
    return String(year)
  }
  
  func getPeriodString() -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "dd.MM.YY"
    
    return "\(dateFormatter.string(from: self.startDate!)) - \(dateFormatter.string(from: self.endDate!))"
    
  }
  
}
