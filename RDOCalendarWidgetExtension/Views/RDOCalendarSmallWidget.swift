//
//  RDOCalendarSmallWidget.swift
//  RDOCalendarWidgetExtension
//
//  Created by Admin on 05.11.2020.
//  Copyright © 2020 neoviso. All rights reserved.
//

import SwiftUI
import WidgetKit

struct RDOCalendarSmallWidget: View {
    
    var entry: RDOCalendarWidgetEntry
    
    var body: some View {
        RDOCalendarDay(entry: entry)
    }
}

struct RDOCalendarSmallWidget_Previews: PreviewProvider {
    static var previews: some View {
        RDOCalendarSmallWidget(entry: RDOCalendarWidgetEntry.stub)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
