//
//  Array+Ex.swift
//  Summonses
//
//  Created by Admin on 09.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation

extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}
