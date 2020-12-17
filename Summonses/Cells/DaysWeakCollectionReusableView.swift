//
//  DaysWeakCollectionReusableView.swift
//  Summonses
//
//  Created by Smikun Denis on 28.12.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DaysWeakCollectionReusableView: JTACMonthReusableView {
  
    @IBOutlet weak var firstDay: UILabel!
    @IBOutlet weak var secondDay: UILabel!
    @IBOutlet weak var thirdDay: UILabel!
    @IBOutlet weak var fourthDay: UILabel!
    @IBOutlet weak var fifthDay: UILabel!
    @IBOutlet weak var sixthDay: UILabel!
    @IBOutlet weak var seventhDay: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        changeWeekLabels()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeWeekLabels()
        // Initialization code
    }
    
    private func changeWeekLabels() {
        if SettingsManager.shared.isMondayFirstDay {
            firstDay.text   = "MON"
            secondDay.text  = "TUE"
            thirdDay.text   = "WED"
            fourthDay.text  = "THU"
            fifthDay.text   = "FRI"
            sixthDay.text   = "SAT"
            seventhDay.text = "SUN"
        } else {
            firstDay.text   = "SUN"
            secondDay.text  = "MON"
            thirdDay.text   = "TUE"
            fourthDay.text  = "WED"
            fifthDay.text   = "THU"
            sixthDay.text   = "FRI"
            seventhDay.text = "SAT"
        }
    }
}
