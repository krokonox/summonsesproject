//
//  RDOCalendarOvertimeView.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 15.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import SwiftUI
import WidgetKit

struct RDOCalendarOvertimeView : View {
    
    var overtime: (Int, Int, Double)
    
    var body: some View {
        VStack {
            RDOCalendarOvertimeTextView(header: "Total Cash", value: "\(overtime.0)")
            RDOCalendarOvertimeTextView(header: "Total Time", value: "\(overtime.1)")
            RDOCalendarOvertimeTextView(header: "Total Earned", value: "\(overtime.2)")
        }
        .padding(.top)
        .padding(.leading)
    }
}


struct RDOCalendarOvertimeView_Previews : PreviewProvider {
    static var previews: some View {
        RDOCalendarOvertimeView(overtime: (143, 1302, 3234))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


