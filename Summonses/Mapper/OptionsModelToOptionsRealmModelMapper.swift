//
//  OptionsModelToOptionsRealmModelMapper.swift
//  Summonses
//
//  Created by Smikun Denis on 27.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class OptionsModelToOptionsRealmModelMapper: Mapper <DaysDisplayedModel, OptionsRealmModel> {
  
  
  override func map(from: DaysDisplayedModel, to: OptionsRealmModel) {
//    if to.id.isEmpty {
//      to.id = from.id
//    }
    to.department = from.department.rawValue
    to.squad = from.squad.rawValue
    to.showPayDays = from.showPayDays
    to.showVacationDays = from.showVocationDays
//  }
  }
  
}
