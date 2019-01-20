//
//  MonthTotalsOvertimeWithTimeTableViewCell.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 1/3/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class MonthTotalsOvertimeWithTimeTableViewCell: UITableViewCell {
  
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var cashLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var earnedLabel: UILabel!
  var cash: Int = 0 {
    didSet {
      cashLabel.text = cash != 0 ? cash.getTime() : "0"
      earnedLabel.text = cash.setEarned()
      setColorTextField()
    }
  }
  
  var time: Int = 0 {
    didSet {
      timeLabel.text = time != 0 ? time.getTime() : "0"
      setColorTextField()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = .darkBlue
    self.selectionStyle = .none
  }
  
  private func setColorTextField() {
    if cash == 0 && time == 0 {
      monthLabel.textColor = .customBlue1
      cashLabel.textColor = .customBlue1
      timeLabel.textColor = .customBlue1
      earnedLabel.textColor = .customBlue1
    } else {
      monthLabel.textColor = .white
      cashLabel.textColor = .white
      timeLabel.textColor = .white
      earnedLabel.textColor = .white
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    cash = 0
    time = 0
    monthLabel.text =   ""
    cashLabel.text =    ""
    timeLabel.text =    ""
    earnedLabel.text =  ""
    
    monthLabel.textColor = .white
    cashLabel.textColor = .white
    timeLabel.textColor = .white
    earnedLabel.textColor = .white
  }
}
