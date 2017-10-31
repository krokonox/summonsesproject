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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
