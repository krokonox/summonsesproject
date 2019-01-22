//
//  DaysDisplayedModel.swift
//  Summonses
//
//  Created by Smikun Denis on 21.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import Foundation

enum TypeDepartment {
  case patrol
  case srg
}

enum TypeSquad {
  case firstSquad
  case secondSquard
  case thirdSquad
}

class DaysDisplayedModel: NSObject {
  
  var department: TypeDepartment
  var squad: TypeSquad
  var showPayDays: Bool = false
  var showVocationDays: Bool = false
  
  init(departmentType: TypeDepartment, squadType: TypeSquad) {
    self.department = departmentType
    self.squad = squadType
    
  }
  
}
