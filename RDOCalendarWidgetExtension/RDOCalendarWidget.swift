//
//  RDOCalendarWidget.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 05.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import WidgetKit
import SwiftUI

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
        RDOCalendarWidgetEntryView(entry: RDOCalendarWidgetEntry(date: Date(), rdoDates: []))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
