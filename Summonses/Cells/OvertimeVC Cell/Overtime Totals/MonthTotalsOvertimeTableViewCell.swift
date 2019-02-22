//
//  MonthTotalsOvertimeTableViewCell.swift
//  Summonses
//
//  Created by Vlad Lavrenkov on 1/23/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class MonthTotalsOvertimeTableViewCell: UITableViewCell {
	
	@IBOutlet weak var monthLabel: UILabel!
	@IBOutlet weak var cashLabel: UILabel!
	@IBOutlet weak var earnedLabel: UILabel!
	
	var cash: Int = 0 {
		didSet {
			cashLabel.text = cash != 0 ? cash.getTimeFromMinutes() : "0"
			setColorTextField()
		}
	}
	
	var earned: Double = 0.0 {
		didSet {
			earnedLabel.text = earned.getEarned()
		}
	}
	private func setColorTextField() {
		if cash == 0 {
			monthLabel.textColor = .customBlue2
			cashLabel.textColor = .customBlue2
			earnedLabel.textColor = .customBlue2
		} else {
			monthLabel.textColor = .white
			cashLabel.textColor = .white
			earnedLabel.textColor = .white
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.backgroundColor = .darkBlue
		self.selectionStyle = .none
	}
	
}
