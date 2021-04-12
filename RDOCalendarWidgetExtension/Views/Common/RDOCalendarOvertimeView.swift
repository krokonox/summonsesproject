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
    var headerNames: [String]
    
    var body: some View {
        VStack {
            RDOCalendarOvertimeImageView(header: headerNames[0], value: "\(overtime.0.getTimeFromMinutes())", imageName: "totalCash")
            RDOCalendarOvertimeImageView(header: headerNames[1], value: "\(overtime.1.getTimeFromMinutes())", imageName: "totalTime")
            RDOCalendarOvertimeImageView(header: headerNames[2], value: "\((overtime.1 + overtime.0).getTimeFromMinutes())", imageName: "totalEarned")
        }
        .padding(.top)
        .padding(.leading)
    }
}

struct RDOCalendarMediumOvertimeView : View {
    
    var overtime: (Int, Int, Double)
    var headerNames: [String]
    
    var body: some View {
        GeometryReader { metrics in
            VStack {
                RDOCalendarOvertimeRectangleView(header: headerNames[0], value: "\(overtime.0.getTimeFromMinutes())")
                RDOCalendarOvertimeRectangleView(header: headerNames[1], value: "\(overtime.1.getTimeFromMinutes())")
                RDOCalendarOvertimeRectangleView(header: headerNames[2], value: "\((overtime.1 + overtime.0).getTimeFromMinutes())")
            }
            .padding(.top)
            .padding(.leading)
        }
    }
}

struct RDOCalendarOvertimeView_Previews : PreviewProvider {
    static var previews: some View {
        RDOCalendarOvertimeView(overtime: (143, 1302, 3234), headerNames: ["Total Cash", "Total Time", "Total Overtime"])
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


