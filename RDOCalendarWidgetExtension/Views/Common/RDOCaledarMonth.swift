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
    
    @ObservedObject var rdoManager: RDOCalendarWidgetManager
    
    let entry: RDOCalendarWidgetEntry
    
    let monthOffset: Int
    let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])
    let daysPerWeek = 7
   
    var monthsArray: [[RDOCalendarWidgetDate]] {
        monthArray()
    }
    
    var body: some View {
        GeometryReader { metrics in
            VStack(alignment: HorizontalAlignment.leading, spacing: 7) {
                Text("\(entry.date.getDateName(.month)), \(entry.date.getYear())")
                    .font(.system(size: 14, weight: .bold))
//                    .padding(.leading, metrics.size.width * 0.1)
                VStack(alignment: .leading, spacing: 3) {
                    RDOCalendarWeekdayHeader().frame(width: metrics.size.width, alignment: .leading)
                        .padding(.leading, 3)
                    ForEach(monthsArray, id:  \.self) { row in
                        HStack {
                            ForEach(row, id:  \.self) { column in
                                HStack {
                                    if self.isThisMonth(date: column.date) {
                                        Spacer()
                                        RDOCalendarDateCell(rdoDate: column, cellWidth: metrics.size.width * 0.1)
                                        Spacer()
                                    } else {
                                        Spacer()
                                        Text("").frame(width: metrics.size.width * 0.1, height: metrics.size.width * 0.1)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                .padding(.top, metrics.size.height * 0.075)
                .background(Color.clear)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        }
    }
    
    func monthArray() -> [[RDOCalendarWidgetDate]] {
        print("called")
        let dates = entry.rdoDates
        let firstDayIndex = dates[0].date.get(.day)
        var rowArray = [[RDOCalendarWidgetDate]]()
        var skipCount = 6 - (6 - firstDayIndex)
        
        for row in 0 ..< (numberOfDays(offset: monthOffset) / 7) {
            var columnArray = [RDOCalendarWidgetDate]()
            for column in 0 ... 6 {
                if (row == 0 && skipCount != 0) || ((row * 7 + column) > (dates.count - 1)) {
                    columnArray.append(RDOCalendarWidgetDate())
                    skipCount -= 1
                } else {
                    let abc = dates[row * 7 + column - 1]
                    columnArray.append(abc)
                }
            }
            print(columnArray.count, row)
            rowArray.append(columnArray)
        }
        return rowArray
    }
    
    func isThisMonth(date: Date) -> Bool {
        print(self.rdoManager.calendar.isDate(date, equalTo: firstOfMonthForOffset(), toGranularity: .month), date.get(.day))
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
//
//struct RKMonth_Previews : PreviewProvider {
//    static var previews: some View {
//        RDOCAlendarMonth(isPresented: .constant(false), entry: RDOCalendarWidgetEntry(date: Date(), rdoDates: RDOWidgetCalendarHelper.generateRDODates()), monthOffset: 0)
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
//    }
//}
