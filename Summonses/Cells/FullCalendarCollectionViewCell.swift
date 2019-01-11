//
//  FullCalendarCollectionViewCell.swift
//  Summonses
//
//  Created by Smikun Denis on 02.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import JTAppleCalendar

let fullCalendarReusableViewIdentifier = "FullCalendarCollectionReusableView"



class FullCalendarCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var calendarView: JTAppleCalendarView!
  
  var monthAndYearGenerate: String! {
    didSet {
      calendarView.reloadData()
    }
  }
  
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = Calendar.current.timeZone
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "dd MM yyyy"
    return formatter
  }()
  
  func setupViews() {
    
    calendarView.calendarDelegate = self
    calendarView.calendarDataSource = self
    calendarView.isUserInteractionEnabled = false
    calendarView.minimumLineSpacing = 0
    calendarView.minimumInteritemSpacing = 0
    
    registerCollectionViewCells()
  }
  
  func reloadDataCalendar() {
    print("reloaded")
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
    cell.isHidden = state.dateBelongsTo == .thisMonth ? false : true
  }
}



extension FullCalendarCollectionViewCell: JTAppleCalendarViewDelegate {
  
  func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {}
  
  func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
    
    guard let headerView = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: fullCalendarReusableViewIdentifier, for: indexPath) as? FullCalendarCollectionReusableView else { fatalError() }
    
    dateFormatter.dateFormat = "MMMM"
    let monthString = dateFormatter.string(from: range.start).uppercased()
    headerView.monthLabel.text = monthString
    
    return headerView
  }
  
  func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
    return MonthSize(defaultSize: 24)
  }
  
  func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
    
    guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: dayCellIdentifier, for: indexPath) as? DayCollectionViewCell else { fatalError() }
    
    cell.dayLabel.text = cellState.text
    
    if UIScreen.main.bounds.height <= 568.0 {
      cell.dayLabel.font = UIFont.systemFont(ofSize: 7)
    }else{
      cell.dayLabel.font = UIFont.systemFont(ofSize: 8)
    }
    
    configureCells(cell: cell, state: cellState)
    
    return cell
  }
  
}

extension FullCalendarCollectionViewCell: JTAppleCalendarViewDataSource {
  func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
    
    dateFormatter.dateFormat = "MMMM yyyy"
    
    let startDate = dateFormatter.date(from: monthAndYearGenerate)
    let endDate = dateFormatter.date(from: monthAndYearGenerate)
    
    let configure = ConfigurationParameters(startDate: startDate!, endDate: endDate!, firstDayOfWeek: .monday)
    
    return configure
  }
}
