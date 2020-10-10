//
//  RDOCalendarWidgetEntity.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 04.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation
import WidgetKit

struct RDOCalendarWidgetEntry: TimelineEntry {
    public let date: Date
    
    var rdoDates: [RDOCalendarWidgetDate] = RDOWidgetCalendarHelper.generateRDODates()
    
}


extension RDOCalendarWidgetEntry {
    
    static var stub: RDOCalendarWidgetEntry {
        RDOCalendarWidgetEntry(date: Date(), rdoDates: [])
    }
    
    static var placeholder: RDOCalendarWidgetEntry {
        RDOCalendarWidgetEntry(date: Date(), rdoDates: [])
    }
}
