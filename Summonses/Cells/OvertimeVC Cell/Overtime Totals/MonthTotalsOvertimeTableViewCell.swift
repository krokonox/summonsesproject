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
			cashLabel.text = cash != 0 ? cash.getTime() : "0"
			setColorTextField()
		}
	}
	
	var earned: Double = 0.0 {
		didSet {
			earnedLabel.text = "$"+String(format: "%.0f", earned)
		}
	}
	private func setColorTextField() {
		if cash == 0 {
			monthLabel.textColor = .customBlue1
			cashLabel.textColor = .customBlue1
			earnedLabel.textColor = .customBlue1
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
