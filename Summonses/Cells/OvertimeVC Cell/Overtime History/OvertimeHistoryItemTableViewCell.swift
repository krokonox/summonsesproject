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
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bgCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        bgCell.layer.cornerRadius = CGFloat.corderRadius5
    }
  
  func setData(create: Date, totalOvertime: String, notes: String?, type: String) {
        self.title.text = "\(create.getDate()) \(notes ?? ""))"
    self.subTitle.text = "Total Overtime: \(totalOvertime) hours"
        self.imgView.image = UIImage(named: type.lowercased().replace(target: " ", withString: "_"))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = ""
        subTitle.text = ""
        imageView?.image = nil
    }
}
