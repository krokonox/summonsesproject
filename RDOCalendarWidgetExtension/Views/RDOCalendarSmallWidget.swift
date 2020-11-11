//
//  RDOCalendarSmallWidget.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 05.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import SwiftUI

import WidgetKit

struct RDOCalendarSmallWidget: View {
    
    var entry: RDOCalendarWidgetEntry
    
    var body: some View {
        GeometryReader { metrics in
            VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                Text(entry.today.date.getDateName(.day))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(UIColor.darkBlue3))
                Text("\(entry.today.date.get(.day))")
                    .font(.system(size: 24, weight: .bold))
                Text("Today is:")
                    .padding(.top, 20)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color.gray)
                ForEach(returnDayDescription(entry.today), id:  \.self) { str in
                    Text(str).foregroundColor(Color.gray)
                }
                
            }
            .padding(.top, metrics.size.height * 0.1)
            .padding(.leading, metrics.size.width * 0.1)
        }
    }
}

struct RDOCalendarSmallWidget_Previews: PreviewProvider {
    static var previews: some View {
        RDOCalendarSmallWidget(entry: RDOCalendarWidgetEntry.stub)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension RDOCalendarSmallWidget {
    func returnDayDescription(_ rdoDate: RDOCalendarWidgetDate) -> [String] {
        var descriptionText: [String] = []
            if rdoDate.isIndividualVacationDay {
                descriptionText.append("Individual Vacation Day")
            }
            if rdoDate.isVacationDay {
                descriptionText.append("Vacation Day")
            }
            if rdoDate.isPayDay {
                descriptionText.append("Pay Day")
            }
            if rdoDate.isWeekend {
                descriptionText.append("Weekend")
            } else {
                descriptionText.append("Working day")
            }
        return descriptionText
    }
}
