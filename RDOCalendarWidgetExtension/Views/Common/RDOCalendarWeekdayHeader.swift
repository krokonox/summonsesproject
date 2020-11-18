//
//  RDOCalendarHeader.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 09.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import SwiftUI

struct RDOCalendarWeekdayHeader : View {
    
    var weekDaySymbols: [String]
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            ForEach(self.weekDaySymbols, id: \.self) { weekday in
                Spacer()
                Text(weekday)
                    .minimumScaleFactor(0.7)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
        }
    }
}

struct RKWeekdayHeader_Previews : PreviewProvider {
    static var previews: some View {
        RDOCalendarWeekdayHeader(weekDaySymbols: RDOCalendarRDODateManager.shortWeekDayNames)
    }
}

