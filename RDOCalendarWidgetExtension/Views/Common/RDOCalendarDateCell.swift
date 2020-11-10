//
//  CalendarCell.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 05.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

struct RDOCalendarDateCell: View {
    
    var rdoDate: RDOCalendarWidgetDate
    
    var cellWidth: CGFloat
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(rdoDate.getBackgroundColor())
                .frame(width: cellWidth, height: cellWidth)
                .overlay(
                  RoundedRectangle(cornerRadius: cellWidth / 3)
                    .stroke(rdoDate.getBorderColor(), lineWidth: 2)
                ).cornerRadius(cellWidth / 3)
            VStack(spacing: 0) {
                Text(rdoDate.getText())
                    .foregroundColor(rdoDate.getTextColor())
                    .font(.system(size: 11, weight: .semibold))
                    .background(Color.clear)
                Rectangle()
                    .fill(rdoDate.getPayDayBackgroundColor())
                    .frame(width: 3, height: 3)
            }
        }
    }
}

struct RKCell_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            RDOCalendarDateCell(rdoDate: RDOCalendarWidgetDate(date: Date(), isPayDay: true, isToday: true, isWeekend: false, isVacationDay: false, isIndividualVacationDay: false), cellWidth: 32)
                .previewDisplayName("Vacation Day")
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}


