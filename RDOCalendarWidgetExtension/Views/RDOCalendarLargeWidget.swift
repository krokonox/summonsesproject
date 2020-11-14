//
//  RDOCalendarLargeWidget.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 05.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import SwiftUI
import WidgetKit

struct RDOCalendarLargeWidget: View {
    
    var entry: RDOCalendarWidgetEntry
    
    var body: some View {
        GeometryReader { metrics in
            RDOCAlendarMonth(isPresented: .constant(false), rdoManager: RDOCalendarManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), entry: entry, monthOffset: 0, weekDayNames: RDOCalendarRDODateManager.fullWeekDayNames)
                .frame(width: metrics.size.width * 0.8 , height: metrics.size.height * 0.65
                       , alignment: .leading)
//                .padding(.leading, metrics.size.width * 0.05)
        }
    }
}

struct RDOCalendarLargeWidget_Previews: PreviewProvider {
    static var previews: some View {
        RDOCalendarMediumWidget(entry: RDOCalendarWidgetEntry.stub)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
