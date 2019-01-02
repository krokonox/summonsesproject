//
//  OffenseTableViewCell.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit


class OffenseTableViewCell: UITableViewCell {

    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.textColor = UIColor.darkBlue
        number.textColor = UIColor.customBlue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
         super.prepareForReuse()
         number.text = ""
         title.text = ""
    }
    
    func configure(with offense: OffenseModel) {
        self.number.text = "\(offense.classType)-Summons   \(offense.law):\(offense.number)"
        self.title.text  = offense.title
    }
    
}
