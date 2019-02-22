//
//  VDRealmModelToVDModelMapper.swift
//  Summonses
//
//  Created by Smikun Denis on 09.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class VDRealmModelToVDModelMapper: Mapper <VDRealmModel, VDModel> {
  
  override func map(from: VDRealmModel, to: VDModel) {
    to.id = from.id
    to.startDate = from.startDate
    to.endDate = from.endDate
		to.isDeleted = from.isDeleted
  }
  
}
