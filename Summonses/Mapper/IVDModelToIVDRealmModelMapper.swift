//
//  IVDModelToIVDRealmModelMapper.swift
//  Summonses
//
//  Created by Smikun Denis on 10.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class IVDModelToIVDRealmModelMapper: Mapper <IVDModel, IVDRealmModel> {

    override func map(from: IVDModel, to: IVDRealmModel) {
        from.id = to.id
        from.date = to.date
    }

}