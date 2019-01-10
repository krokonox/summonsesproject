//
//  VDModelToVDRealmModelMapper.swift
//  Summonses
//
//  Created by Smikun Denis on 09.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class VDModelToVDRealmModelMapper: Mapper <VDModel, VDRealmModel> {
    
    override func map(from: VDModel, to: VDRealmModel) {
        to.id = from.id
        to.startDate = from.startDate
        to.endDate = from.endDate
    }

}
