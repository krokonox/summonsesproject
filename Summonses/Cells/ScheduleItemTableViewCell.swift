//
//  VDTableViewCell.swift
//  Summonses
//
//  Created by Smikun Denis on 08.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import SwipeCellKit

class ScheduleItemTableViewCell: SwipeTableViewCell {
  
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var settingsImage: UIImageView!
  @IBOutlet weak var backViewTrailingConstraint: NSLayoutConstraint!
    
  var onButtonTapped : (()->())?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    //self.label.font = UIFont.boldSystemFont(ofSize: 15)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
    settingsImage.isUserInteractionEnabled = true
    settingsImage.addGestureRecognizer(tapGesture)
   }
       
  @objc private func onTap(_ gesture: UIGestureRecognizer) {
       if (gesture.state == .ended) {
         if let onButtonTapped = onButtonTapped {
             onButtonTapped()
         }
       }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupViews()
  }
  
  private func setupViews() {
    self.selectionStyle = .none
    self.contentView.layer.cornerRadius = CGFloat.cornerRadius4
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
