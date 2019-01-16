//
//  DayCollectionViewCell.swift
//  Summonses
//
//  Created by Smikun Denis on 27.12.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DayCollectionViewCell: JTAppleCell {
  
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var backgroundDayView: UIView!
  @IBOutlet weak var payDayView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupBackgroundDayView()
    setupPayDayView()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    backgroundDayView.backgroundColor = .clear
  }
  
  private func setupBackgroundDayView() {
    backgroundDayView.layer.cornerRadius = CGFloat.cornerRadius4
    backgroundDayView.isHidden = true
  }
  
  private func setupPayDayView() {
    payDayView.layer.cornerRadius = payDayView.frame.height / 2
    payDayView.isHidden = true
  }
  
}
