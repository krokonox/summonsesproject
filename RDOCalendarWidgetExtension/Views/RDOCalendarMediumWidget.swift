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
                RDOCalendarOvertimeView(overtime: entry.overtime)
                    .frame(width: metrics.size.width * 0.35, height: metrics.size.height * 0.7)
                RDOCAlendarMonth(isPresented: .constant(false), rdoManager: RDOCalendarManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), entry: entry, monthOffset: 0, weekDayNames: RDOCalendarRDODateManager.shortWeekDayNames)
                    .frame(width: metrics.size.width * 0.6, height: metrics.size.height * 0.95, alignment: .trailing)
                    
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
