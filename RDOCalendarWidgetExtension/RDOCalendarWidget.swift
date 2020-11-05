//
//  RDOCalendarWidget.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 05.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import WidgetKit
import SwiftUI

struct RDOCalendarWidgetEntryView : View {
    var entry: RDOCalendarWidgetEntry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

@main
struct RDOCalendarWidget: Widget {
    let kind: String = "RDOCalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RDOCalendarWidgetTimelineProvider()) { entry in
            RDOCalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct RDOCalendarWidget_Previews: PreviewProvider {
    static var previews: some View {
        RDOCalendarWidgetEntryView(entry: RDOCalendarWidgetEntry(date: Date(), calendar: RDOCalendar(vacationDays: [], payDays: [], weekends: [], individualVacationDays: [])))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
