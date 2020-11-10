//
//  RDOCalendarHeader.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 09.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import SwiftUI

struct RDOCalendarWeekdayHeader : View {
    
    var weekDaySymbols = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
     
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            ForEach(self.weekDaySymbols, id: \.self) { weekday in
                Text(weekday)
                    .font(.system(size: 9, weight: .bold))
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

struct RKWeekdayHeader_Previews : PreviewProvider {
    static var previews: some View {
        RDOCalendarWeekdayHeader()
    }
}

