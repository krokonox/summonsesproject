//
//  MenueCollectionViewCell.swift
//  Summonses
//
//  Created by Vlad on 10/23/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class MenueCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.customBlue
        self.layer.cornerRadius = 8.0
        title.textColor = .black
    }

}
