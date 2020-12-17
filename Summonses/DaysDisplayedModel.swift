//
//  DaysDisplayedModel.swift
//  Summonses
//
//  Created by Smikun Denis on 21.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import Foundation

enum TypeDepartment: Int {
  case none = 0
  case patrol = 1
  case srg = 2
  case steady = 3
  case custom = 4
}

enum TypeSquad: Int {
  case firstSquad = 0
  case secondSquard = 1
  case thirdSquad = 2
}

class DaysDisplayedModel: NSObject {
  
  var department: TypeDepartment!
  var squad: TypeSquad!
  var showPayDays: Bool = false
  var showVocationDays: Bool = false
  
  override init() {
    super.init()
  }
  
  init(departmentType: TypeDepartment, squadType: TypeSquad) {
    self.department = departmentType
    self.squad = squadType
    
  }
  
}
