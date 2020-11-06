//
//  CalculatorSwitchTableViewCell.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 1/2/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class CalculatorDoubleSwitchTableViewCell: MainTableViewCell {
  
  @IBOutlet weak var leftLabel: UILabel!
  @IBOutlet weak var leftLabelInCenter: UILabel!
  @IBOutlet weak var leftHelpLabel: UILabel!
  @IBOutlet weak var leftSwitсh: UISwitch!
  @IBOutlet weak var leftSeparator: UIView!
    
  @IBOutlet weak var rightLabel: UILabel!
  @IBOutlet weak var rightLabelInCenter: UILabel!
  @IBOutlet weak var rightHelpLabel: UILabel!
  @IBOutlet weak var rightSwitсh: UISwitch!
  @IBOutlet weak var rightSeparator: UIView!
    
  @IBOutlet weak var backView: UIView!
  
  var changeLeftValue: ((_ isOn: Bool)->())?
  var changeRightValue: ((_ isOn: Bool)->())?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupViews()
    leftSwitсh.addTarget(self, action: #selector(checkLeftSwitch(leftSwitch:)), for: .valueChanged)
    rightSwitсh.addTarget(self, action: #selector(checkRightSwitch(rightSwitch:)), for: .valueChanged)
  }
  
  @objc func checkLeftSwitch(leftSwitch: UISwitch) {
    changeLeftValue?(leftSwitсh.isOn)
  }
    
  @objc func checkRightSwitch(rightSwitch: UISwitch) {
    changeRightValue?(rightSwitch.isOn)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    leftLabel.text = ""
    leftHelpLabel.text = ""
    leftLabelInCenter.text = ""
    leftSwitсh.isOn = false
    rightLabel.text = ""
    rightHelpLabel.text = ""
    rightLabelInCenter.text = ""
    rightSwitсh.isOn = false
  }
  
  func setLeftText(title: String, helpText: String?) {
    if let helpText = helpText {
      leftLabel.text = title
      leftHelpLabel.text = helpText
      leftLabelInCenter.text = ""
    } else {
      leftLabel.text = ""
      leftHelpLabel.text = ""
      leftLabelInCenter.text = title
    }
  }
    
  func setRightText(title: String, helpText: String?) {
    if let helpText = helpText {
      rightLabel.text = title
      rightHelpLabel.text = helpText
      rightLabelInCenter.text = ""
    } else {
      rightLabel.text = ""
      rightHelpLabel.text = ""
      rightLabelInCenter.text = title
    }
  }
  
  private func setupViews() {
    customContentView = backView
    leftSeparator.isHidden = true
    leftSwitсh.onTintColor = .customBlue1
    rightSeparator.isHidden = true
    rightSwitсh.onTintColor = .customBlue1
  }
}
