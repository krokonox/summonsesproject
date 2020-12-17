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
            VStack {
                HStack {
                    //RDOCalendarDay(entry: entry)
                      //  .frame(width: metrics.size.width * 0.3, height: metrics.size.height * 0.55, alignment: .trailing)
                    RDOCAlendarMonth(isPresented: .constant(false), rdoManager: RDOCalendarManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), entry: entry, monthOffset: 0, fontSize: 12, weekdayPadding: 0.056)
                        .frame(width: metrics.size.width * 0.9, height: metrics.size.height * 0.55, alignment: .leading)
                        //.padding(.leading, metrics.size.width * 0.)
                        .padding(.top, metrics.size.height * 0.05)
                }
                Divider()
                    .padding(.horizontal)
                RDOCalendarOvertimeView(overtime: entry.overtime)
                    .frame(width: metrics.size.width, height: metrics.size.height * 0.3)
            }
        }
    }
}

struct RDOCalendarLargeWidget_Previews: PreviewProvider {
    static var previews: some View {
        RDOCalendarMediumWidget(entry: RDOCalendarWidgetEntry.stub)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
