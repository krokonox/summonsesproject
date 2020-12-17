//
//  YearsSegmentControl.swift
//  Summonses
//
//  Created by Smikun Denis on 04.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class YearsSegmentControl: SegmentedControl {
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.backgroundColor = UIColor.clear
  }
  
  override func changeTitles() {
    
    let attributedNormalDict = [NSAttributedStringKey.foregroundColor : UIColor.white,
                                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17.0)]
    
    let attributedSelectedDict = [NSAttributedStringKey.foregroundColor : UIColor.white,
                                  NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17.0)]
    
    self.setTitleTextAttributes(attributedNormalDict, for: .normal)
    self.setTitleTextAttributes(attributedSelectedDict, for: .selected)
  }
  
  override func customBackgroundColor() -> UIColor {
    return .clear
  }
  
  override func selectedItemBackgroundColor() -> UIColor {
    return .clear
  }
  
  override func dividerColor() -> UIColor {
    return .clear
  }
  
}
