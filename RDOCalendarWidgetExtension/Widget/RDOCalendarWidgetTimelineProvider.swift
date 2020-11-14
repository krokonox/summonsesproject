//
//  RDOCalendarWidgetTimelineProvider.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 04.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation
import WidgetKit

struct RDOCalendarWidgetTimelineProvider: TimelineProvider {
    
    typealias Entry = RDOCalendarWidgetEntry
 
    func placeholder(in context: Context) -> RDOCalendarWidgetEntry {
        RDOCalendarWidgetEntry.placeholder
    }
    
    func getSnapshot(in context: Context, completion: @escaping (RDOCalendarWidgetEntry) -> Void) {
        if context.isPreview {
            completion(RDOCalendarWidgetEntry.placeholder)
        } else {
            let entry = createEntry()
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<RDOCalendarWidgetEntry>) -> Void) {
        let dayInterval = 60 * 60 * 24
        let entry = createEntry()
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(TimeInterval(dayInterval))))
        completion(timeline)
    }
}

extension RDOCalendarWidgetTimelineProvider {
    private func createEntry() -> RDOCalendarWidgetEntry {
        let rdoDates = RDOCalendarRDODateManager.shared.generateRDODates()
        let entry = RDOCalendarWidgetEntry(date: Date(), rdoDates: rdoDates)
        return entry
    }
}
