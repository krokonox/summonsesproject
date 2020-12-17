//
//  OvertimeHistoryItemTableViewCell.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 1/2/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import SwipeCellKit

class OvertimeHistoryItemTableViewCell: SwipeTableViewCell {
  
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var subTitle: UILabel!
	@IBOutlet weak var comment: UILabel!
  @IBOutlet weak var imgView: UIImageView!
  @IBOutlet weak var bgCell: UIView!
    
  override func awakeFromNib() {
    super.awakeFromNib()
    self.selectionStyle = .none
    bgCell.layer.cornerRadius = CGFloat.cornerRadius4
  }
  
  func setData(overtimeModel: OvertimeModel) {
    title.text = "\(overtimeModel.createDate!.getDate())"
		if overtimeModel.totalOvertimeWorked != 0 {
            subTitle.text = "Total Overtime: \((overtimeModel.totalOvertimeWorked + overtimeModel.travelMinutes).getTimeFromMinutes()) hours"
		} else {
            subTitle.text = "Total Overtime: \(overtimeModel.travelMinutes.getTimeFromMinutes()) hours"
		}
		comment.text = overtimeModel.notes
    imgView.image = UIImage(named: overtimeModel.type.lowercased().replace(target: " ", withString: "_"))?.withRenderingMode(.alwaysTemplate)
    if overtimeModel.isPaid {
      imgView.tintColor = .darkBlue
    } else {
      imgView.tintColor = .lightGray
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    title.text = ""
    subTitle.text = ""
		comment.text = ""
    imageView?.image = nil
  }
}
