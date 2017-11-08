//
//  OffenseTableViewCell.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit


class OffenseTableViewCell: MainTableViewCell {

    @IBOutlet weak var law: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var favouritesButton: UIButton!
    
    var onFavouritesPress : (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        number.textColor = UIColor.customBlue
        law.textColor = UIColor.customBlue
        leftView.backgroundColor = UIColor.customBlue
        
        self.backView.layer.shadowColor = UIColor.gray.cgColor
        self.backView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.backView.layer.shadowRadius = 1.0
        self.backView.layer.shadowOpacity = 1.0
        self.backView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
         super.prepareForReuse()
        
    }
    
    func configure(offense: OffenseModel) {
        if !offense.law.isEmpty {
            self.law.text = offense.law + ":"
        }
        self.number.text = offense.number
        self.title.text  = offense.title
        if offense.isFavourite {
            favouritesButton.tintColor = .white
        } else {
            favouritesButton.tintColor = .customGray
        }
    }
    
    @IBAction func onFavouritePress(_ sender: Any) {
        if let onFavouritesPress = self.onFavouritesPress {
            onFavouritesPress()
        }
    }
    
}
