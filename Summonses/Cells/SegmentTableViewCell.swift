//
//  SegmentTableViewCell.swift
//  Summonses
//
//  Created by Smikun Denis on 26.12.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class SegmentTableViewCell: MainTableViewCell {
  
  var click: ((String)->())?
  var clickIndex: ((Int)->())?
  
  @IBOutlet weak var segmentControl: SegmentedControl!
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    setupViews()
    segmentControl.addTarget(self, action: #selector(clickSegment(seg:)), for: .valueChanged)
  }
  
  @objc private func clickSegment(seg: UISegmentedControl) {
    click?(seg.titleForSegment(at: seg.selectedSegmentIndex) ?? "")
    clickIndex?(seg.selectedSegmentIndex)
  }
  
  func setupViews() {
    self.customContentView = backView
  }
}

