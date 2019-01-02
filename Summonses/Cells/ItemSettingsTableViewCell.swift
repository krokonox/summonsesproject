//
//  ItemSettingsTableViewCell.swift
//  Summonses
//
//  Created by Smikun Denis on 19.12.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class ItemSettingsTableViewCell: MainTableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var switсh: UISwitch!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var backView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setupViews() {
        customContentView = backView
        separator.isHidden = true
    }
   
}
