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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBackgroundDayView()
    }
    
    private func setupBackgroundDayView() {

        backgroundDayView.layer.cornerRadius = CGFloat.corderRadius5
        backgroundDayView.isHidden = true
    }

}
