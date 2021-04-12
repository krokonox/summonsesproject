//
//  UILabel+Ex.swift
//  Summonses
//
//  Created by neoviso on 16.02.21.
//  Copyright © 2021 neoviso. All rights reserved.
//

import UIKit

extension UILabel {
    func diagonalStrikeThrough(offsetPercent: CGFloat = 0.1, color: CGColor) {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: bounds.height * (1 - offsetPercent)))
        linePath.addLine(to: CGPoint(x: bounds.width, y: bounds.height * offsetPercent))

        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.lineWidth = 1
        lineLayer.strokeColor = color
        layer.addSublayer(lineLayer)
    }
}
