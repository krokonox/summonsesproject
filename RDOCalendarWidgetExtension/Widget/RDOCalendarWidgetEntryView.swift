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
    
    private static let deeplinkURL: URL = URL(string: "widget-deeplink://")!
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            RDOCalendarSmallWidget(entry: entry).widgetURL(RDOCalendarWidgetEntryView.deeplinkURL)
        case .systemMedium:
            RDOCalendarMediumWidget(entry: entry).widgetURL(RDOCalendarWidgetEntryView.deeplinkURL)
        case .systemLarge:
            RDOCalendarLargeWidget(entry: entry).widgetURL(RDOCalendarWidgetEntryView.deeplinkURL)
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

