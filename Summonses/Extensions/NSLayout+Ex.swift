//
//  NSLayout+Ex.swift
//  Summonses
//
//  Created by neoviso on 10.03.21.
//  Copyright © 2021 neoviso. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
