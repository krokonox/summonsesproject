//
//  SettingsCalendarTableViewCell.swift
//  Summonses
//
//  Created by Smikun Denis on 19.12.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

enum CellStateSettings {
  case close
  case open
}

class ExpandableTableViewCell: MainTableViewCell {
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var chevronView: UIImageView!
  @IBOutlet weak var backView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setupViews()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
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
  
  private func setupViews() {
    self.customContentView = backView
  }
  
  func update(state: CellStateSettings, animated: Bool) {
    
    var rotationAngle : CGFloat
    
    switch state {
    case .open:
      rotationAngle = CGFloat(180 * CGFloat.pi/180)
    case .close:
      rotationAngle = CGFloat(-1 * -CGFloat.pi/180)
    }
    
    if animated {
      UIView.animate(withDuration: 0.3) {
        self.chevronView.transform = CGAffineTransform(rotationAngle: rotationAngle)
      }
    } else {
      self.chevronView.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
  }
  
}
