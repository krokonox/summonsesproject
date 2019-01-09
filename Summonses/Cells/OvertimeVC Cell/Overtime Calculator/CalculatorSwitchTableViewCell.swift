//
//  CalculatorSwitchTableViewCell.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 1/2/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class CalculatorSwitchTableViewCell: MainTableViewCell {
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var labelInCenter: UILabel!
  @IBOutlet weak var helpLabel: UILabel!
  @IBOutlet weak var switсh: UISwitch!
  @IBOutlet weak var separator: UIView!
  @IBOutlet weak var backView: UIView!
  
  var changeValue: ((_ isOn: Bool)->())?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupViews()
    switсh.addTarget(self, action: #selector(checkSwitch(switch:)), for: .valueChanged)
  }
  
  @objc func checkSwitch(switch: UISwitch) {
    changeValue?(switсh.isOn)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    label.text = ""
    helpLabel.text = ""
    labelInCenter.text = ""
  }
  
  func setText(title: String, helpText: String?) {
    if let helpText = helpText {
      label.text = title
      helpLabel.text = helpText
      labelInCenter.text = ""
    } else {
      label.text = ""
      helpLabel.text = ""
      labelInCenter.text = title
    }
  }
  
  private func setupViews() {
    customContentView = backView
    separator.isHidden = true
    switсh.onTintColor = .customBlue1
  }
}
