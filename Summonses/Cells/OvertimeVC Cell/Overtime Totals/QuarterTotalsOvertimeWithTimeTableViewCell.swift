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
