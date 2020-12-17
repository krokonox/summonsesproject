//
//  RoundView.swift
//  Summonses
//
//  Created by Stanislav on 5/13/20.
//  Copyright © 2020 neoviso. All rights reserved.
//

import UIKit

class RoundView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners([.bottomLeft, .bottomRight], radius: 4.0)
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}
