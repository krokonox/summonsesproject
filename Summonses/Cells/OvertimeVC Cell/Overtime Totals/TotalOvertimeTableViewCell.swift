//
//  TotalOvertimeTableViewCell.swift
//  Summonses
//
//  Created by Vlad Lavrenkov on 1/23/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class TotalOvertimeTableViewCell: UITableViewCell {

	@IBOutlet weak var totalCashLabel: UILabel!
	@IBOutlet weak var totalEarnedLabel: UILabel!
	
	@IBOutlet weak var backgroundTotalView: UIView!
	
	var cash: Int = 0 {
		didSet {
			totalCashLabel.text = cash != 0 ? cash.getTime() : "0"
			totalEarnedLabel.text = cash.setEarned(price: SettingsManager.shared.paidDetailRate)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		let maskPath = UIBezierPath(roundedRect: self.bounds,
																byRoundingCorners: [.bottomRight, .bottomLeft],
																cornerRadii: CGSize(width: .cornerRadius4, height: .cornerRadius4))
		
		let maskLayer = CAShapeLayer()
		maskLayer.frame = self.bounds
		maskLayer.path = maskPath.cgPath
		self.layer.mask = maskLayer
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
		totalEarnedLabel.text = ""
	}
}
