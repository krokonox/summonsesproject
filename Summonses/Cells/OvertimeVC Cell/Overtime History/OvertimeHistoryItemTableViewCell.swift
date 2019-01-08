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
    
    func setData(title: String, subTitle: String, image: UIImage) {
        self.title.text = title
        self.subTitle.text = subTitle
        self.imgView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = ""
        subTitle.text = ""
        imageView?.image = nil
    }
}
