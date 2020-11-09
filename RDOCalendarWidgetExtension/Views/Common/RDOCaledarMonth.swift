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
    let cellWidth = CGFloat(32)
    
    var body: some View {
            //Text(getMonthHeader()).foregroundColor(self.rkManager.colors.monthHeaderColor)
            VStack(alignment: .leading, spacing: 5) {
                ForEach(monthsArray, id:  \.self) { row in
                    HStack() {
                        ForEach(row, id:  \.self) { column in
                            HStack() {
                                Spacer()
                                RDOCalendarDateCell(rdoDate: column, cellWidth: cellWidth)
                                Spacer()
                            }
                        }
                    }
                }
            }.frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.clear)
    }
    
    func monthArray() -> [[RDOCalendarWidgetDate]] {
        print(RDOWidgetCalendarHelper.generateRDODates())
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

