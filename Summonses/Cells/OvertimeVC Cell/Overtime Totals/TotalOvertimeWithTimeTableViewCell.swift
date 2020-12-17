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
	
	@IBOutlet weak var bgView: UIView!
	
	var cash: Int = 0 {
		didSet {
			totalCashLabel.text = cash != 0 ? cash.getTimeFromMinutes() : "0"
		}
	}
	
	var earned: Double = 0.0 {
		didSet {
			totalEarnedLabel.text = earned.getEarned()
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
	
	var time: Int = 0 {
		didSet {
			totalTimeLabel.text = time != 0 ? time.getTimeFromMinutes() : "0"
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
