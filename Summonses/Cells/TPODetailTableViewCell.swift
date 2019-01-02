//
//  TPODetailTableViewCell.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 12/18/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class TPODetailTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.textColor = UIColor.darkBlue
        backView.layer.cornerRadius = CGFloat.corderRadius5
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
