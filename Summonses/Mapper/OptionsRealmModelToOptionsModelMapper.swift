//
//  OptionsRealmModelToOptionsModelMapper.swift
//  Summonses
//
//  Created by Smikun Denis on 27.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import Foundation
import UIKit

class OptionsRealmModelToOptionsModelMapper: Mapper <OptionsRealmModel, DaysDisplayedModel> {
  
  
  override func map(from: OptionsRealmModel, to: DaysDisplayedModel) {
    //    if to.id.isEmpty {
    //      to.id = from.id
    //    }
    to.department = TypeDepartment(rawValue: from.department)!
    to.squad = TypeSquad(rawValue: from.squad)!
    to.showPayDays = from.showPayDays
    to.showVocationDays = from.showVacationDays
    //  }
  }
  
}
