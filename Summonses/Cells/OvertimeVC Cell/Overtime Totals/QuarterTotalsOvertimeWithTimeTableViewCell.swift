//
//  QuarterTotalsOvertimeWithTimeTableViewCell.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 1/3/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class QuarterTotalsOvertimeWithTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var quaterLabel: UILabel!
    @IBOutlet weak var quaterTotalTimeLabel: UILabel!
  
  var quater: Int = 0 {
    didSet {
      switch quater {
      case 1:
        quaterLabel.text = "1st QUARTER"
      case 2:
        quaterLabel.text = "2nd QUARTER"
      case 3:
        quaterLabel.text = "3rd QUARTER"
      case 4:
        quaterLabel.text = "4th QUARTER"
      default:
        quaterLabel.text = ""
      }
    }
  }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .darkBlue
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        quaterLabel.text =          ""
        quaterTotalTimeLabel.text = ""
    }
}
