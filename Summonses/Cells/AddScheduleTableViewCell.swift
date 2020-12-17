//
//  SettingsCalendarTableViewCell.swift
//  Summonses
//
//  Created by Smikun Denis on 19.12.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class AddScheduleTableViewCell: MainTableViewCell {
  var onPressCallBack : (()->())?
  
    
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  @IBAction func buttonPressed(_ sender: Any) {
    if let switchClickChanged = onPressCallBack {
      switchClickChanged()
    }
  }
  
}
