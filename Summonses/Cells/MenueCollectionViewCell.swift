//
//  MenueCollectionViewCell.swift
//  Summonses
//
//  Created by Vlad on 10/23/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class MenueCollectionViewCell: MainCollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var grayView: UIView!
    @IBOutlet weak var lockImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cornerRadius = CGFloat.cornerRadius4
        
        self.backView.layer.cornerRadius = CGFloat.cornerRadius4
        self.backView.layer.masksToBounds = true
    }
    
    override func updateStyle() {
        super.updateStyle()
        self.backView.backgroundColor = .bgMainCell
    }
    
    override func prepareForReuse() {
        grayView.isHidden = false
        lockImage.isHidden = false
    }
    
}

extension MenueCollectionViewCell {
    
    func configure(with title: String?, image: UIImage?) {
        self.title.text = title ?? ""
        self.image.image = image ?? nil
        
        if title == "A-SUMMONS" {
            grayView.isHidden = true
            lockImage.isHidden = true
        } else if Defaults[.proBaseVersion] {
            grayView.isHidden = true
            lockImage.isHidden = true
        } else {
            grayView.isHidden = false
            lockImage.isHidden = false
        }
    }
}
