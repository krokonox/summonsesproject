//
//  RDOCalendarOvertimeTextView.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 15.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import SwiftUI
import WidgetKit

struct RDOCalendarOvertimeTextView : View {
    
    var header: String
    var value: String
    var imageName: String
    
    var body: some View {
        GeometryReader { metrics in
            HStack {
                Image(imageName)
                    .foregroundColor(Color("iconColor"))
                VStack(alignment: .leading, spacing: -3) {
                    Text(header)
                        .font(.system(size: 12, weight: .medium))
                    Text(value)
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray)
                }
            }
        }
    }
}

struct RDOCalendarOvertimeTextView_Previews : PreviewProvider {
    static var previews: some View {
        RDOCalendarOvertimeTextView(header: "Total Cash", value: "12000", imageName: "time1")
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


