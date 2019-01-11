//
//  CalendarTableViewCell.swift
//  Summonses
//
//  Created by Smikun Denis on 19.12.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit
import JTAppleCalendar

let dayCellIdentifier = "DayCollectionViewCell"
let daysWeakReusableViewIdentifier = "DaysWeakCollectionReusableView"

enum DaysOfWeek: Int {
  case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}

class CalendarTableViewCell: MainTableViewCell {
  
  @IBOutlet weak var headerCalendarView: UIView!
  @IBOutlet weak var headerViewLabel: UILabel!
  @IBOutlet weak var calendarView: JTAppleCalendarView!
  @IBOutlet weak var heightCostraintCalendarView: NSLayoutConstraint!
  
  @IBOutlet weak var rightHeaderCalendarConstraint: NSLayoutConstraint!
  @IBOutlet weak var leftHeaderCalendarConstraint: NSLayoutConstraint!
  @IBOutlet weak var rightCalendarConstraint: NSLayoutConstraint!
  @IBOutlet weak var leftCalendarConstraint: NSLayoutConstraint!
  
  var dates:[Date]?
  
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = Calendar.current.timeZone
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "dd MM yyyy"
    return formatter
  }()
  
  let firstDayOfWeak: DaysOfWeek = .monday
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.monthDidChange, object: nil)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setupViews() {
    
    let currentDate = Date()
    calendarView.scrollToDate(currentDate, animateScroll: false)
    
    calendarView.visibleDates { (dateSegment) in
      self.setupCalendarView(dateSegment: dateSegment)
    }
    
    calendarView.ibCalendarDataSource = self
    calendarView.ibCalendarDelegate = self
    calendarView.minimumLineSpacing = 0.0
    calendarView.minimumInteritemSpacing = 0.0
    calendarView.layer.cornerRadius = CGFloat.cornerRadius4
    
    headerCalendarView.layer.cornerRadius = CGFloat.cornerRadius4
    
    registerCollectionViewCells()
    registerCollectionViewReusableViews()
    
    NotificationCenter.default.addObserver(self, selector: #selector(monthChange(notification:)), name: NSNotification.Name.monthDidChange, object: nil)
  }
  
  @objc private func monthChange(notification: Notification) {
    if let monthAndYearString = notification.userInfo?[kNtfMonth] as? String {
      
      dateFormatter.dateFormat = "MMMM yyyy"
      let date = dateFormatter.date(from: monthAndYearString)
      calendarView.scrollToDate(date!, animateScroll: true)
    }
  }
  
  
  private func configureCells(cell: JTAppleCell?, state: CellState) {
    guard let customCell = cell as? DayCollectionViewCell else { return }
    
    handleCellsVisibility(cell: customCell, state: state)
    handleDayTextColor(cell: customCell, state: state)
    handleCustomDates(cell: customCell, state: state)
  }
  
  private func handleDayTextColor(cell: DayCollectionViewCell, state: CellState) {
    let todayDate = Date()
    
    dateFormatter.dateFormat = "dd MM yyyy"
    
    let todayDateString = dateFormatter.string(from: todayDate)
    let monthDateString = dateFormatter.string(from: state.date)
    
    if todayDateString == monthDateString {
      cell.backgroundDayView.isHidden = false
      cell.backgroundDayView.layer.borderWidth = 1
      cell.backgroundDayView.layer.borderColor = UIColor.customBlue.cgColor
      cell.backgroundDayView.layer.cornerRadius = CGFloat.cornerRadius10
    } else {
      cell.backgroundDayView.isHidden = true
      cell.backgroundDayView.layer.borderWidth = 0
      cell.backgroundDayView.layer.borderColor = nil
    }
  }
  
  private func handleCustomDates(cell: DayCollectionViewCell, state: CellState) {
    guard let dates = self.dates else {return}
    
    dateFormatter.dateFormat = "dd MM yyyy"
    let monthDateString = dateFormatter.string(from: state.date)
    
    _ = dates.map { (date) -> Void in
      let dateString = dateFormatter.string(from: date)
      if dateString == monthDateString {
        cell.backgroundDayView.isHidden = false
        cell.backgroundDayView.backgroundColor = .customBlue1
        cell.backgroundDayView.layer.cornerRadius = CGFloat.cornerRadius10
      }
    }
  }
  
  func setDates(dates: [Date]) {
    self.dates = dates
    calendarView.reloadData()
  }
  
  private func handleCellsVisibility(cell: DayCollectionViewCell, state: CellState) {
    cell.dayLabel.textColor = state.dateBelongsTo == .thisMonth ? UIColor.white : UIColor.white.withAlphaComponent(0.22)
    cell.dayLabel.font = state.dateBelongsTo == .thisMonth ? UIFont.boldSystemFont(ofSize: 14.0) : UIFont.systemFont(ofSize: 14.0)
  }
  
  private func setupCalendarView(dateSegment: DateSegmentInfo) {
    guard let date = dateSegment.monthDates.first?.date else { return }
    
    dateFormatter.dateFormat = "MMMM"
    let monthString = dateFormatter.string(from: date) + ", "
    let month = AttributedString.getString(text: monthString, size: 17.0, color: .white, fontStyle: .bold)
    
    dateFormatter.dateFormat = "yyyy"
    let year = AttributedString.getString(text: dateFormatter.string(from: date), size: 17.0, color: .white, fontStyle: .regular)
    
    let monthAndYear = NSMutableAttributedString(attributedString: month)
    monthAndYear.append(year)
    
    headerViewLabel.attributedText = monthAndYear
    
  }
  
  private func registerCollectionViewCells() {
    calendarView.register(UINib(nibName: dayCellIdentifier, bundle: nil), forCellWithReuseIdentifier: dayCellIdentifier)
  }
  
  private func registerCollectionViewReusableViews() {
    self.calendarView.register(UINib(nibName: daysWeakReusableViewIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: daysWeakReusableViewIdentifier)
  }
  
  override func prepareForReuse() {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.monthDidChange, object: nil)
  }
}


extension CalendarTableViewCell : JTAppleCalendarViewDelegate {
  
  func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {}
  
  func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
    
    let headerView = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: daysWeakReusableViewIdentifier, for: indexPath)
    
    return headerView
  }
  
  func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
    return MonthSize(defaultSize: 36)
  }
  
  func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
    
    guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: dayCellIdentifier, for: indexPath) as? DayCollectionViewCell else { fatalError() }
    
    cell.dayLabel.text = cellState.text
    configureCells(cell: cell, state: cellState)
    
    return cell
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
    setupCalendarView(dateSegment: visibleDates)
  }
}

extension CalendarTableViewCell : JTAppleCalendarViewDataSource {
  func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
    
    dateFormatter.dateFormat = "dd MM yyyy"
    
    let firstYear = Date().getVisibleYears().first
    let lastYear = Date().getVisibleYears().last
    
    let startDate = dateFormatter.date(from: "01 01 \(firstYear!)")
    let endDate = dateFormatter.date(from: "31 12 \(lastYear!)")
    
    let configure = ConfigurationParameters(startDate: startDate!, endDate: endDate!, generateOutDates: .tillEndOfRow, firstDayOfWeek: .monday)
    
    return configure
    
  }
  
}
