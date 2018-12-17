//
//  CorenrView.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 8/8/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class CorneredView: UIView {
    
    var cornerRadii:                        CGFloat = 5.0
    var corners:                            UIRectCorner? {didSet { updateCorners()}}
    lazy fileprivate var customMask         = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let corners = self.corners  else { return }
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
        customMask.path = path.cgPath
        self.layer.mask = customMask
    }
    
    func updateCorners() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
}
