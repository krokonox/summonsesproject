//
//  MonthHeaderCollectionView.swift
//  RDO Calendar
//
//  Created by Smikun Denis on 25.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DayNamesHeaderView: JTACMonthReusableView {
    @IBOutlet weak var firstDay: UILabel!
    @IBOutlet weak var secondDay: UILabel!
    @IBOutlet weak var thirdDay: UILabel!
    @IBOutlet weak var fourthDay: UILabel!
    @IBOutlet weak var fifthDay: UILabel!
    @IBOutlet weak var sixthDay: UILabel!
    @IBOutlet weak var seventhDay: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeWeekLabels()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        changeWeekLabels()
    }
    
    private func changeWeekLabels() {
        var isFirstDayMonday = false
        
        if let userDefaults = UserDefaults (suiteName: "group.com.summonspartner.sp") {
           isFirstDayMonday = userDefaults.bool(forKey: "firstDayWeekKey")
        }
        
        if isFirstDayMonday {
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
