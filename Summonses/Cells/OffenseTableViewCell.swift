//
//  OffenseTableViewCell.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit


class OffenseTableViewCell: MainTableViewCell {

    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var favouritesButton: UIButton!
    
    var onFavouritesPress : (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        number.textColor = UIColor.customBlue
        leftView.backgroundColor = UIColor.customGray
        
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
        self.number.text = offense.number
        self.title.text  = offense.tittle
        if offense.isFavourite {
            favouritesButton.tintColor = .customBlue
//            favouritesButton.setImage(UIImage(named: "star-3"), for: .normal)
        } else {
  //          favouritesButton.setImage(UIImage(named: "emptystar"), for: .normal)
            favouritesButton.tintColor = .white
        }
    }
    
    @IBAction func onFavouritePress(_ sender: Any) {
        if let onFavouritesPress = self.onFavouritesPress {
            onFavouritesPress()
        }
    }
    
}
