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
