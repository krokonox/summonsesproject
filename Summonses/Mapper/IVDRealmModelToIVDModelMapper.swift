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
        from.id = to.id
        from.date = to.date
    }
}
