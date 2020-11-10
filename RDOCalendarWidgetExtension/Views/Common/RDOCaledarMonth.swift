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
    
    let entry: RDOCalendarWidgetEntry
    let monthOffset: Int

    let daysPerWeek = 7
   
    var monthsArray: [[RDOCalendarWidgetDate]] {
        monthArray()
    }
    let cellWidth = CGFloat(21)
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 7) {
            Text("\(entry.date.getMonthName()), \(entry.date.getYear())")
                .font(.system(size: 14, weight: .bold))
                .padding(.leading, 20)
            VStack(alignment: .leading, spacing: 3) {
                RDOCalendarWeekdayHeader().frame(width: cellWidth * 9.5, alignment: .leading)
                    .padding(.leading, -3)
                ForEach(monthsArray, id:  \.self) { row in
                    HStack {
                        ForEach(row, id:  \.self) { column in
                            HStack {
                                //Spacer()
                                RDOCalendarDateCell(rdoDate: column, cellWidth: cellWidth)
                                //Spacer()
                            }
                        }
                    }
                }
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
            .padding(.leading, 20)
            .background(Color.clear)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .padding(.leading, 5)
        .padding(.bottom, 10)
        .padding(.top, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
    
    func monthArray() -> [[RDOCalendarWidgetDate]] {
        let dates = entry.rdoDates
        var rowArray = [[RDOCalendarWidgetDate]]()
        for row in 0 ..< (dates.count / 7) {
            var columnArray = [RDOCalendarWidgetDate]()
            for column in 0 ... 6 {
                let abc = entry.rdoDates[row * 7 + column]
                columnArray.append(abc)
            }
            rowArray.append(columnArray)
        }
        if dates.count >= 28 {
            rowArray.append(Array(dates[28...dates.count - 1]))
        }
        print(rowArray.count)
        return rowArray
    }
}

struct RKMonth_Previews : PreviewProvider {
    static var previews: some View {
        RDOCAlendarMonth(isPresented: .constant(false), entry: RDOCalendarWidgetEntry(date: Date(), rdoDates: RDOWidgetCalendarHelper.generateRDODates()), monthOffset: 0)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

// to remove
extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents) ?? nil
    }
}

