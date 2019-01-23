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
  
  let calendar = Calendar.current
  
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
    calendarView.deselectAllDates()
    NotificationCenter.default.removeObserver(self)

  }
  
  var monthAndYearGenerate: String! {
    didSet {
      setupViews()
    }
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    calendarView.reloadData()
  }
  
  func setupViews() {
    
    calendarView.allowsMultipleSelection = true
    calendarView.isRangeSelectionUsed = true
    
    calendarView.ibCalendarDataSource = self
    calendarView.ibCalendarDelegate = self
    
    calendarView.isUserInteractionEnabled = false
    calendarView.minimumLineSpacing = 0
    calendarView.minimumInteritemSpacing = 0
    calendarView.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    registerCollectionViewCells()
    getVacationPeriodsAndSelect()
    
    NotificationCenter.default.addObserver(self, selector:#selector(reloadDataCalendar(notification:)), name: Notification.Name.IVDDataDidChange, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(vdDataDidChange(notification:)), name: NSNotification.Name.VDDateFullCalendarUpdate, object: nil)
    
  }
  
  @objc private func vdDataDidChange(notification: Notification) {
    getVacationPeriodsAndSelect()
  }
  
  @objc private func reloadDataCalendar(notification: Notification) {
    calendarView.reloadData()
  }
  
  private func registerCollectionViewCells() {
    calendarView.register(UINib(nibName: dayCellIdentifier, bundle: nil), forCellWithReuseIdentifier: dayCellIdentifier)
  }
  
  func getVacationPeriodsAndSelect() {
    
    calendarView.deselectAllDates()
    
    calendarView.visibleDates { (visibleDates) in
      let vocationModels = SheduleManager.shared.getVocationDaysForSelectMonth(firstDayMonth: (visibleDates.monthDates.first?.date)!, lastDayMonth: (visibleDates.monthDates.last?.date)!)
      
      for model in vocationModels {
        self.calendarView.selectDates(from: model.startDate!, to: model.endDate!, keepSelectionIfMultiSelectionAllowed: true)
      }
      
      self.calendarView.reloadData()
    }
    
  }
  
  private func configureCells(cell: JTAppleCell?, state: CellState) {
    guard let customCell = cell as? DayCollectionViewCell else { return }
    
    customCell.cellType = .none
    
    handleCellsVisibility(cell: customCell, state: state)
    handleDayTextColor(cell: customCell, state: state)
    handleCellsVDDays(cell: customCell, state: state)
    handleCellsIVD(cell: customCell, state: state)
    handleCellsWeekends(cell: customCell, state: state)

    customCell.backgroundDayView.layer.cornerRadius = 4.0
    
  }
  
  
  func handleCellsVisibility(cell: DayCollectionViewCell, state: CellState) {
    cell.isHidden = state.dateBelongsTo == .thisMonth ? false : true
  }
  
  func handleDayTextColor(cell: DayCollectionViewCell, state: CellState) {
    
    if Calendar.current.isDateInToday(state.date) {
      cell.cellType = .currentDay
    }

  }
  
  private func handleCellsIVD(cell: DayCollectionViewCell, state: CellState) {

    if !SettingsManager.shared.permissionShowVocationsDays { return }
    
    let ivdDatesByMonth = SheduleManager.shared.getIVDdateForSelectedMonth(firstDayMonth: state.date, lastDayMonth: state.date)
    
    let ivdDate = ivdDatesByMonth.filter { (date) -> Bool in
      return Calendar.current.isDate(date, inSameDayAs: state.date)
      }.first
    
    if (ivdDate != nil) {
        cell.cellType = .ivdDay
    }
    
  }
  
  private func handleCellsVDDays(cell: DayCollectionViewCell, state: CellState) {
    
    if !SettingsManager.shared.permissionShowVocationsDays { return }
    
    if state.dateBelongsTo == .thisMonth {
      if state.isSelected && calendarView.selectedDates.count > 0 {
        cell.cellType = .vocationDays(cellState: state)
      } else {
        return
      }
    }
  }
  
  private func handleCellsWeekends(cell: DayCollectionViewCell, state: CellState) {
    
    let weekendDates = SheduleManager.shared.getWeekends(firstDayMonth: state.date, lastDate: state.date)
    
    let weekendDate = weekendDates.filter { (date) -> Bool in
      return Calendar.current.isDate(date, inSameDayAs: state.date)
      }.first
    
    if (weekendDate != nil) {
        if state.dateBelongsTo == .thisMonth {
          cell.cellType = .ivdDay
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
    
    let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: dayCellIdentifier, for: indexPath) as! DayCollectionViewCell
    
    cell.dayLabel.text = cellState.text
    cell.preferredRadiusSelectDayView = 4.0
    
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
