//
//  SettingColorTableViewCell.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 11/8/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class SettingColorTableViewCell: MainTableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var leftView: UIView!
    
    var onSwitchChange : ((Bool) -> Void)? = nil
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if StyleManager.getAppStyle() == AppStyle.white {
            mySwitch.setOn(false, animated: false)
        }
        
        leftView.backgroundColor = UIColor.customBlue
        self.backView.layer.shadowColor = UIColor.gray.cgColor
        self.backView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.backView.layer.shadowRadius = 1.0
        self.backView.layer.shadowOpacity = 1.0
        self.backView.layer.masksToBounds = false
    }
  
    @IBAction func onSwitchChange(_ sender: Any) {
        if let onSwitchChange = self.onSwitchChange {
            onSwitchChange((sender as AnyObject).isOn)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
