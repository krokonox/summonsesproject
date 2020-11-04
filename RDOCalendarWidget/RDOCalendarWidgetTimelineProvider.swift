//
//  RDOCalendarWidgetTimelineProvider.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 04.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import Foundation
import WidgetKit

struct GlobalTotalStatsTimelineProvider: TimelineProvider {
    
    typealias Entry = RDOCalendarWidgetEntry
    let scheduleManager = SheduleManager.shared
 
    func placeholder(in context: Context) -> RDOCalendarWidgetEntry {
        RDOCalendarWidgetEntry.placeholder
    }
    
    func getSnapshot(in context: Context, completion: @escaping (RDOCalendarWidgetEntry) -> Void) {
        if context.isPreview {
            completion(RDOCalendarWidgetEntry.placeholder)
        } else {
            fetchTotalGlobalCaseStats { (result) in
                switch result {
                case .success(let entry):
                    completion(entry)
                case .failure(_):
                    completion(RDOCalendarWidgetEntry.placeholder)
                }
            }
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<RDOCalendarWidgetEntry>) -> Void) {
        fetchTotalGlobalCaseStats { (result) in
            switch result {
            case .success(let entry):
                // Refresh every 6 hrs
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60 * 10)))
                completion(timeline)
            case .failure(_):
                // Refresh after 10 mins
                let entry = RDOCalendarWidgetEntry.placeholder
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60 * 2)))
                completion(timeline)
            }
        }
    }
    
    private func fetchTotalGlobalCaseStats(completion: @escaping (Result<RDOCalendarWidgetEntry, Error>) -> ()) {
        var calendar = RDOWidgetCalendar()
        calendar.payDays = scheduleManager.getPayDaysForSelectedMonth(firstDayMonth: <#T##Date#>, lastDayMonth: <#T##Date#>)
        calendar.vacationDays = scheduleManager.getVocationDays()
        
        scheduleManager.getIVDdateForSelectedMonth(firstDayMonth: <#T##Date#>, lastDayMonth: <#T##Date#>)
//        scheduleManager.getGlobalTotalCount { (result) in
//            switch result {
//            case .success(let stats):
//                let entry = RDOCalendarWidgetEntry(date: Date(), totalCount: .init(title: "🌏", confirmed: stats.totalConfirmed, death: stats.totalDeaths, recovered: stats.totalRecovered))
//                completion(.success(entry))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
    }
}
