//
//  RDOCalendarMediumWidget.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 05.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import SwiftUI
import WidgetKit

struct RDOCalendarMediumWidget: View {
    
    var entry: RDOCalendarWidgetEntry
    
    var body: some View {
        GeometryReader { metrics in
            HStack {
                VStack(spacing: -metrics.size.height * 0.05) {
                    Text("OVERTIME TOTALS")
                        .font(.system(size: 11))
                        .foregroundColor(Color.gray)
                RDOCalendarMediumOvertimeView(overtime: entry.overtime, headerNames: ["Cash", "Time", "Total"])
                }
                .frame(width: metrics.size.width * 0.44, height: metrics.size.height * 0.55)
                .padding(.top, metrics.size.height * 0.1)
                RDOCAlendarMonth(isPresented: .constant(false), rdoManager: RDOCalendarManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), entry: entry, monthOffset: 0, fontSize: 10, weekdayPadding: 0.04)
                    .frame(width: metrics.size.width * 0.5, height: metrics.size.height * 0.95, alignment: .trailing)
                    .padding(.trailing, metrics.size.width * 0.05)
                    .padding(.vertical, metrics.size.height * 0.05)
            }
        }
    }
}

struct RDOCalendarMediumWidget_Previews: PreviewProvider {
    static var previews: some View {
        RDOCalendarMediumWidget(entry: RDOCalendarWidgetEntry.stub)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
