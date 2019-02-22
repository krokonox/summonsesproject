//
//  IVDRealmModelToIVDModelMapper.swift
//  Summonses
//
//  Created by Smikun Denis on 10.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class IVDRealmModelToIVDModelMapper: Mapper <IVDRealmModel, IVDModel>{
  
  override func map(from: IVDRealmModel, to: IVDModel) {
    to.id = from.id
    to.date = from.date
		to.isDeleted = from.isDeleted
  }
}
