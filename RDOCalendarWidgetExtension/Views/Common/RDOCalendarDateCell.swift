//
//  CalendarCell.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 05.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation
import SwiftUI

struct RDOCalendarDateCell: View {
    
    var rdoDate: RDOCalendarWidgetDate
    
    var cellWidth: CGFloat
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: cellWidth, height: cellWidth)
                .background(rdoDate.getBackgroundColor())
                .cornerRadius(10)
            VStack {
                Text(rdoDate.getText())
                    .font(.system(size: 14))
                    .background(Color.clear)
                Rectangle()
                    .frame(width: 3, height: 3)
                    .background(rdoDate.getPayDayBackgroundColor())
            }
        }
    }
}

#if DEBUG
struct RKCell_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            RDOCalendarDateCell(rdoDate: RDOCalendarWidgetDate(date: Date(), isPayDay: true, isToday: false, isWeekend: false, isVacationDay: true), cellWidth: 32)
                .previewDisplayName("Vacation Day")
            //            RDOCalendarDateCell(rkDate: RDOCalendarWidgetDate(date: Date(), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), isDisabled: true, isToday: false, isSelected: false, isBetweenStartAndEnd: false), cellWidth: CGFloat(32))
            //                .previewDisplayName("Disabled Date")
            //            RDOCalendarDateCell(rkDate: RDOCalendarWidgetDate(date: Date(), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), isDisabled: false, isToday: true, isSelected: false, isBetweenStartAndEnd: false), cellWidth: CGFloat(32))
            //                .previewDisplayName("Today")
            //            RDOCalendarDateCell(rkDate: RDOCalendarWidgetDate(date: Date(), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), isDisabled: false, isToday: false, isSelected: true, isBetweenStartAndEnd: false), cellWidth: CGFloat(32))
            //                .previewDisplayName("Selected Date")
            //            RDOCalendarDateCell(rkDate: RDOCalendarWidgetDate(date: Date(), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), isDisabled: false, isToday: false, isSelected: false, isBetweenStartAndEnd: true), cellWidth: CGFloat(32))
            //                .previewDisplayName("Between Two Dates")
            //        }
            //        .prev
        }
    }
}
#endif

