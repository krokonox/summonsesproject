//
//  RDOCalendarWidgetAppearanceSettings.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 05.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation
import SwiftUI

class RDOCalendarWidgetAppearanceSettings {

    // Current Day
    var currentDayBorderColor: Color = Color(UIColor.borderBlue.cgColor)
    var currentDayBorderWidth = 2.0
    
    // Pay Day
    var payDayViewBackgroundColor: Color = .white
    
    // Vacation Day
    var vacationPayDayViewBackgroundColor: Color = Color(UIColor.darkBlue)
    var vacationDayTextLabelColor: Color = Color(UIColor.darkBlue)
    var vacationDayBackgroundViewColor: Color = .white
    
    // Weekend Day
    var weekendDayBackgroundViewColor: Color = Color(UIColor.customBlue1)
    var weekendDayBorderColor: Color = Color(UIColor.white.cgColor)
    var weekendDayTextLabelColor: Color = .white
    
    // Individual Vacation Day
    var ivdBorderColor: Color = Color(UIColor.borderBlue.cgColor)
    var ivdBackgroundViewIsHidden: Bool = false
    var ivdBackgroundViewColor: Color = Color(UIColor.customBlue3)
    var ivdTextLabelColor: Color = .white
    
    // None Day
    var noneBackgroundViewColor: Color = .clear
    var noneBorderColor = Color.clear
    var noneDayBorderWidth = 0
    var noneCornerRadius = CGFloat.cornerRadius10
    var noneBackgroundDayViewIsHidden: Bool = true
    var nonePayDayViewIsHidden: Bool = true
}
