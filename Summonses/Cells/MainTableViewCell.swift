//
//  MainTableViewCell.swift
//  Summonses
//
//  Created by Artsiom Shmaenkov on 10/25/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet var viewGroup: [UIView]?
    @IBOutlet var labelGroup: [UILabel]?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateStyle()
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.updateStyle), name:Notification.Name(rawValue: "AppStyleUpdate"), object: nil)
    }
    
    func updateStyle() {
        StyleManager.updateStyleForViews(viewGroup:viewGroup)
        StyleManager.updateStyleForLabel(labelGroup:labelGroup)
        StyleManager.updateStyleForTableViewCell(tableCell:self)
    }
}
