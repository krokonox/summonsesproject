//
//  TotalOvertimeWithTimeTableViewCell.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 1/3/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class TotalOvertimeWithTimeTableViewCell: UITableViewCell {
  
  @IBOutlet weak var totalCashLabel: UILabel!
  @IBOutlet weak var totalTimeLabel: UILabel!
  @IBOutlet weak var totalEarnedLabel: UILabel!
	
	var cash: Int = 0 {
		didSet {
			totalCashLabel.text = cash != 0 ? cash.getTime() : "0"
			totalEarnedLabel.text = cash.setEarned()
		}
	}
	
	var time: Int = 0 {
		didSet {
			totalTimeLabel.text = time != 0 ? time.getTime() : "0"
		}
	}
	
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.backgroundColor = .darkBlue
    self.selectionStyle = .none
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    totalCashLabel.text =   ""
    totalTimeLabel.text =   ""
    totalEarnedLabel.text = ""
  }
}
