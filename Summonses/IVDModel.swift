//
//  IVDModel.swift
//  Summonses
//
//  Created by Smikun Denis on 10.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import RealmSwift

class IVDModel: NSObject {
  
  var id = UUID().uuidString
  var date: Date?
	
	var isDeleted = false
	
  override init() {
    super.init()
  }
  
  init(date: Date) {
    self.date = date
  }
  
  func getYear() -> String {
    
    let calendar = Calendar.current
    let year = calendar.component(.year, from: self.date!)
    
    return String(year)
  }
  
  func getDateString() -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "MM.dd.yy"
    
    return "\(dateFormatter.string(from: self.date!))"
    
  }
  
}
