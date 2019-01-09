//
//  MenueCollectionViewCell.swift
//  Summonses
//
//  Created by Vlad on 10/23/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class MenueCollectionViewCell: MainCollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cornerRadius = CGFloat.corderRadius5
      
        self.backView.layer.cornerRadius = CGFloat.corderRadius5
        self.backView.layer.masksToBounds = true
    }
    
    override func updateStyle() {
        super.updateStyle()
        self.backView.backgroundColor = .lightBlue
    }
    

}
