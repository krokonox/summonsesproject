//
//  TextField.swift
//  Summonses
//
//  Created by Smikun Denis on 14.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class PopupTextField: UITextField {
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = CGFloat.cornerRadius4
  }
  
  public func backlightTextField(_ text: String) {
    if text.count == 0 {
      emptyTextFieldStyle()
    } else {
      filledTextFieldStyle()
    }
  }
  
  private func emptyTextFieldStyle() {
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.customBlue.cgColor
    self.attributedPlaceholder = AttributedString.getString(text: self.placeholder ?? "", size: (self.font?.pointSize)!, color: UIColor.customBlue, fontStyle: .regular)
    
    self.shakeHard(duration: 0.5)
  }
  
  private func filledTextFieldStyle() {
    self.layer.borderWidth = 0.0
    self.layer.borderColor = nil
    self.attributedPlaceholder = AttributedString.getString(text: self.placeholder ?? "", size: (self.font?.pointSize)!, color: UIColor.lightGray, fontStyle: .regular)
  }

}
