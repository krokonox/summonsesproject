//
//  EventModel.swift
//  Summonses
//
//  Created by Smikun Denis on 28.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import Foundation

class EventModel: NSObject {
  
  var title: String!
  var date: Date!
  var isAllDay: Bool = true
  
  init(title: String, date: Date) {
    self.title = title
    self.date = date
  }
  
}
