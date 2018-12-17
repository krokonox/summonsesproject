//
//  CalendarView.swift
//  Summonses
//
//  Created by Pavel Budankov on 01.08.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarView: UIView {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    override func awakeFromNib() {
        
         self.calendarView.register(UINib(nibName: CalendarCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: CalendarCollectionViewCell.className)
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        setupCalendarView()
        calendarView.selectDates([Date(),Calendar.current.date(byAdding: .day, value: 1, to: Date())! ])
//        calendarView.delega
    }
    
    func setupCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCollectionViewCell else { return }
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCollectionViewCell else { return }
        if cellState.isSelected {
            validCell.dateLabel.textColor = .black
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = .white
            } else {
                validCell.dateLabel.textColor = .gray
            }
            
        }
        
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}



extension CalendarView : JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CalendarCollectionViewCell.className, for: indexPath) as! CalendarCollectionViewCell
        
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let parameters = ConfigurationParameters(startDate: /*minDate ?? */ Date(),endDate: /*maxDate ??*/ Date())//.adjust(.year, offset: 10))
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        let newDate = date.adjust(hour: currentDate.component(.hour), minute: currentDate.component(.minute), second: currentDate.component(.second))
//        currentDate = newDate
//        datePicker.date = newDate
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
//        let newDate = date.adjust(hour: currentDate.component(.hour), minute: currentDate.component(.minute), second: currentDate.component(.second))
//        if let minDateValue = minDate {
//            guard Int(newDate.timeIntervalSince1970) >= Int(minDateValue.timeIntervalSince1970) else { return false }
//        }
//        if let maxDateValue = maxDate {
//            guard Int(newDate.timeIntervalSince1970) <= Int(maxDateValue.timeIntervalSince1970) else { return false }
//        }
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
//        setupDateLabel(with: date)
    }
}
