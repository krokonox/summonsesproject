//
//  SettingTableViewCell.swift
//  Summonses
//
//  Created by Artsiom Shmaenkov on 10/26/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class SettingTableViewCell: MainTableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var leftView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftView.backgroundColor = UIColor.customBlue        
        
        self.backView.layer.shadowColor = UIColor.gray.cgColor
        self.backView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.backView.layer.shadowRadius = 1.0
        self.backView.layer.shadowOpacity = 1.0
        self.backView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
