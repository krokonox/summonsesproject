//
//  RDOCalendarWidgetEntryView.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 11.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import SwiftUI
import WidgetKit

struct RDOCalendarWidgetEntryView : View {
    
    var entry: RDOCalendarWidgetEntry
    var dates: [RDOCalendarWidgetDate] = RDOCalendarRDODateManager.shared.generateRDODates()
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            RDOCalendarSmallWidget(entry: entry)
        case .systemMedium:
            RDOCalendarMediumWidget(entry: entry)
        case .systemLarge:
            RDOCalendarLargeWidget(entry: entry)
        }
    }
}

struct StatsWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RDOCalendarWidgetEntryView(entry: RDOCalendarWidgetEntry.stub)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .environment(\.colorScheme, .dark)
        }
    }
}

