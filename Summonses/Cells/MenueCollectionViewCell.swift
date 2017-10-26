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
        self.backgroundColor = UIColor.white
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath

    }

}
