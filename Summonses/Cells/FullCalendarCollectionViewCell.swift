//
//  FullCalendarCollectionViewCell.swift
//  Summonses
//
//  Created by Smikun Denis on 02.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import JTAppleCalendar

class FullCalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        formatter.dateFormat = "dd MM yyyy"
        return formatter
    }()
    
    func setupViews() {
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        
        registerCollectionViewCells()
    }
    
    private func registerCollectionViewCells() {
        calendarView.register(UINib(nibName: dayCellIdentifier, bundle: nil), forCellWithReuseIdentifier: dayCellIdentifier)
    }
    
    func configureCells(cell: JTAppleCell?, state: CellState) {
        guard let customCell = cell as? DayCollectionViewCell else { return }
        
        handleCellsVisibility(cell: customCell, state: state)
        handleDayTextColor(cell: customCell, state: state)
    }
    
    func handleDayTextColor(cell: DayCollectionViewCell, state: CellState) {
        let todayDate = Date()
        
        dateFormatter.dateFormat = "dd MM yyyy"
        
        let todayDateString = dateFormatter.string(from: todayDate)
        let monthDateString = dateFormatter.string(from: state.date)
        
        if todayDateString == monthDateString {
            cell.backgroundDayView.isHidden = false
            cell.backgroundDayView.layer.borderWidth = 1
            cell.backgroundDayView.layer.borderColor = UIColor.customBlue.cgColor
        } else {
            cell.backgroundDayView.isHidden = true
            cell.backgroundDayView.layer.borderWidth = 0
            cell.backgroundDayView.layer.borderColor = nil
        }
    }
    
    func handleCellsVisibility(cell: DayCollectionViewCell, state: CellState) {
        cell.dayLabel.textColor = state.dateBelongsTo == .thisMonth ? UIColor.white : UIColor(white: 1.0, alpha: 0.22)
    }
}



extension FullCalendarCollectionViewCell: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {}
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: dayCellIdentifier, for: indexPath) as? DayCollectionViewCell else { fatalError() }
        
        cell.dayLabel.text = cellState.text
        configureCells(cell: cell, state: cellState)
        
        return cell
    }
    
}

extension FullCalendarCollectionViewCell: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        dateFormatter.dateFormat = "dd MM yyyy"
        
        let startDate = dateFormatter.date(from: "01 01 2017")
        let endDate = dateFormatter.date(from: "31 12 2019")
        
        let configure = ConfigurationParameters(startDate: startDate!, endDate: endDate!, firstDayOfWeek: .monday)
        
        return configure
    }
}
