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
  
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = Calendar.current.timeZone
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "dd MM yyyy"
    return formatter
  }()
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    NotificationCenter.default.removeObserver(self)

  }
  
  var monthAndYearGenerate: String! {
    didSet {
      calendarView.reloadData()
    }
  }
  
  func setupViews() {
    
    calendarView.calendarDelegate = self
    calendarView.calendarDataSource = self
    calendarView.isUserInteractionEnabled = false
    calendarView.minimumLineSpacing = 0
    calendarView.minimumInteritemSpacing = 0
    calendarView.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    registerCollectionViewCells()
    
    NotificationCenter.default.addObserver(self, selector:#selector(reloadDataCalendar(notification:)), name: Notification.Name.IVDDataDidChange, object: nil)

  }
  
  @objc private func reloadDataCalendar(notification: Notification) {
  
    //calendarView.performBatchUpdates({
      calendarView.reloadData()
    //}, completion: nil)
  }
  
  private func registerCollectionViewCells() {
    calendarView.register(UINib(nibName: dayCellIdentifier, bundle: nil), forCellWithReuseIdentifier: dayCellIdentifier)
  }
  
  func configureCells(cell: JTAppleCell?, state: CellState) {
    guard let customCell = cell as? DayCollectionViewCell else { return }
    
    handleCellsVisibility(cell: customCell, state: state)
    handleDayTextColor(cell: customCell, state: state)
    handleCellsIVD(cell: customCell, state: state)
  }
  
  
  func handleCellsVisibility(cell: DayCollectionViewCell, state: CellState) {
    cell.isHidden = state.dateBelongsTo == .thisMonth ? false : true
  }
  
  func handleDayTextColor(cell: DayCollectionViewCell, state: CellState) {
    
    if Calendar.current.isDateInToday(state.date) {
      cell.cellType = .currentDay
      cell.backgroundDayView.layer.cornerRadius = 4.0
    } else {
      cell.cellType = .none
    }

  }
  
  private func handleCellsIVD(cell: DayCollectionViewCell, state: CellState) {
    
    calendarView.visibleDates { [weak self] (visibleDates) in
      guard let firstDate = visibleDates.monthDates.first?.date, let lastDate = visibleDates.monthDates.last?.date else { return }
      let ivdDatesByMonth = SheduleManager.shared.getIVDdateForSelectedMonth(firstDayMonth: firstDate, lastDayMonth: lastDate)
      
      for (visibleDate, indexPath) in visibleDates.monthDates {
        for date in ivdDatesByMonth {
          
          if Calendar.current.isDate(date, inSameDayAs: visibleDate) {
            
            guard let cell = self?.calendarView.cellForItem(at: indexPath) as? DayCollectionViewCell else { return }
            cell.cellType = .ivdDay
            cell.backgroundDayView.layer.cornerRadius = 4.0
          }
          
        }
      }
      
    }
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
      cell.dayLabel.font = UIFont.systemFont(ofSize: 7)
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
