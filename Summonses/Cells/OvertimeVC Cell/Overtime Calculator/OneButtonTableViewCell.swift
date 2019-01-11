//
//  OneButtonTableViewCell.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 1/2/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class OneButtonTableViewCell: MainTableViewCell {
  
  @IBOutlet weak var button: UIButton!
  
  var click: (()->())?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func setButton(title: String, backgroundColor: UIColor) {
    button.setTitle(title, for: .normal)
    button.backgroundColor = backgroundColor
    button.cornerRadius = CGFloat.cornerRadius4
  }
  
  @IBAction func pressBtn() {
    click?()
  }
}
