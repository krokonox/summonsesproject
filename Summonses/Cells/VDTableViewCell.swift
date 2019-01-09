//
//  VDTableViewCell.swift
//  Summonses
//
//  Created by Smikun Denis on 08.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import SwipeCellKit

class VDTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.contentView.backgroundColor = UIColor.bgMainCell
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    private func setupViews() {
        self.selectionStyle = .none
        self.contentView.layer.cornerRadius = CGFloat.corderRadius5
        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        var color = UIColor()
        
        if highlighted {
            color = UIColor.groupTableViewBackground
        } else {
            color = UIColor.white
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.backView.backgroundColor = color
        }, completion: nil)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
