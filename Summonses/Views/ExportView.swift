//
//  ExportView.swift
//  Summonses
//
//  Created by Smikun Denis on 29.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class ExportView: UIView {
  
  var swithCalback: ((Bool)->())?
	@IBOutlet weak var exportSwitch: UISwitch!

	override func awakeFromNib() {
		super.awakeFromNib()
		exportSwitch.onTintColor = .customBlue1
	}
	
  @IBAction private func switchClick(_ sender: UISwitch) {
    swithCalback?(sender.isOn)
  }

}
