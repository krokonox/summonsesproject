//
//  RDOCaledarMonth.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 07.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import SwiftUI
import WidgetKit

struct RDOCAlendarMonth: View {
    
    @Binding var isPresented: Bool
    
    @ObservedObject var rdoManager: RDOCalendarManager
    
    let entry: RDOCalendarWidgetEntry
    
    let monthOffset: Int
    let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])
    let daysPerWeek = 7
   
    var monthsArray: [[RDOCalendarWidgetDate]] {
        monthArray()
    }
    
    var fontSize: CGFloat
    var weekdayPadding: CGFloat
    
    var weekDayNames: [String] {
        if entry.shouldStartFromMonday {
            return RDOCalendarRDODateManager.weekDayFromMonday
        } else {
            return RDOCalendarRDODateManager.weekDayFromSunday
        }
    }
    
    var body: some View {
        GeometryReader { metrics in
            VStack(alignment: HorizontalAlignment.leading, spacing: 7) {
                Text("\(entry.date.getDateName(.month).uppercased()) \(entry.date.getYear())")
                    .font(.system(size: 14, weight: .medium))
                    .minimumScaleFactor(0.7)
                    .padding(.leading, metrics.size.width * weekdayPadding)
                    VStack(alignment: .leading, spacing: 0) {
                        RDOCalendarWeekdayHeader(weekDaySymbols: weekDayNames, fontSize: fontSize)
                            .frame(width: metrics.size.width, alignment: .leading)
                            .padding(.leading, metrics.size.width * weekdayPadding)

                        ForEach(monthsArray, id:  \.self) { row in
                            GeometryReader { geometry in
                                HStack {
                                ForEach(row, id:  \.self) { column in
                                    HStack(spacing: -5) {
                                        if self.isThisMonth(date: column.date) {
                                            Spacer()
                                            RDOCalendarDateCell(rdoDate: column, cellWidth: metrics.size.width / 10, fontSize: fontSize)
                                            Spacer()
                                        } else {
                                            Spacer()
                                            Text("")
                                                .frame(width: geometry.size.width / 10, height: metrics.size.width / 10)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func monthArray() -> [[RDOCalendarWidgetDate]] {
        let dates = entry.rdoDates
        let firstDayIndex = entry.firstDayIndex
        var rowArray = [[RDOCalendarWidgetDate]]()
        var skipCount = firstDayIndex
        var dayIndex = 0
        for row in 0 ..< (numberOfDays(offset: monthOffset) / 7) {
            var columnArray = [RDOCalendarWidgetDate]()
            for column in 0 ... 6 {
                if (row == 0 && skipCount != 0) || ((dayIndex) > (dates.count - 1)) {
                    columnArray.append(RDOCalendarWidgetDate())
                    skipCount -= 1
                } else {
                    let abc = dates[dayIndex]
                    columnArray.append(abc)
                    dayIndex += 1
                }
            }
            rowArray.append(columnArray)
        }
        return rowArray
    }
    
    func isThisMonth(date: Date) -> Bool {
        return self.rdoManager.calendar.isDate(date, equalTo: firstOfMonthForOffset(), toGranularity: .month)
    }
    
    func numberOfDays(offset : Int) -> Int {
        let firstOfMonth = firstOfMonthForOffset()
        let rangeOfWeeks = rdoManager.calendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)
        return (rangeOfWeeks?.count)! * daysPerWeek
    }
    
    func firstOfMonthForOffset() -> Date {
        var offset = DateComponents()
        offset.month = monthOffset
        
        return rdoManager.calendar.date(byAdding: offset, to: RDOFirstDateMonth())!
    }
    
    func RDOFirstDateMonth() -> Date {
        var components = rdoManager.calendar.dateComponents(calendarUnitYMD, from: rdoManager.minimumDate)
        components.day = 1
        
        return rdoManager.calendar.date(from: components)!
    }
}

struct RKMonth_Previews: PreviewProvider {
    static var previews: some View {
        RDOCAlendarMonth(isPresented: .constant(false), rdoManager: RDOCalendarManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), entry: RDOCalendarWidgetEntry(date: Date(), rdoDates: []), monthOffset: 0, fontSize: 10, weekdayPadding: 0.04)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
