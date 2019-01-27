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
  
  var displayDaysOptions: DaysDisplayedModel! {
    willSet {
      let departmentModel = DepartmentModel(departmentType: newValue.department, squad: newValue.squad)
      SheduleManager.shared.department = departmentModel
      calendarView.reloadData()
    }
  }
  
  let calendar = Calendar.current
  
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
    setupViews()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.monthDidChange, object: nil)
    NotificationCenter.default.removeObserver(self, name: Notification.Name.IVDDataDidChange, object: nil)
    NotificationCenter.default.removeObserver(self, name: Notification.Name.VDDateUpdate, object: nil)
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
    
    calendarView.isRangeSelectionUsed = true
    calendarView.allowsMultipleSelection = true
    calendarView.ibCalendarDataSource = self
    calendarView.ibCalendarDelegate = self
    calendarView.minimumLineSpacing = 0.0
    calendarView.minimumInteritemSpacing = 0.0
    calendarView.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15)
    calendarView.layer.cornerRadius = CGFloat.cornerRadius4
    
    headerCalendarView.layer.cornerRadius = CGFloat.cornerRadius4
    
    registerCollectionViewCells()
    registerCollectionViewReusableViews()
    
    getVacationPeriodsAndSelect()
    
    
    NotificationCenter.default.addObserver(self, selector: #selector(monthChange(notification:)), name: NSNotification.Name.monthDidChange, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(vdDataDidChange(notification:)), name: NSNotification.Name.VDDateUpdate, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(ivdDataDidChange(notification:)), name: NSNotification.Name.IVDDataDidChange, object: nil)
  }
  
  
  private func getVacationPeriodsAndSelect() {
    calendarView.deselectAllDates()
    
    let vocationModels = SheduleManager.shared.getVocationDays()
    for model in vocationModels {
      calendarView.selectDates(from: model.startDate!, to: model.endDate!, keepSelectionIfMultiSelectionAllowed: true)
    }
    
    calendarView.reloadData()
  }
  
  
  
  @objc private func monthChange(notification: Notification) {
    if let monthAndYearString = notification.userInfo?[kNtfMonth] as? String {
      
      dateFormatter.dateFormat = "MMMM yyyy"
      let date = dateFormatter.date(from: monthAndYearString)
      calendarView.scrollToDate(date!, animateScroll: true)
    }
  }
  
  @objc private func vdDataDidChange(notification: Notification) {
    getVacationPeriodsAndSelect()
  }
  
  @objc private func ivdDataDidChange(notification: Notification) {
    calendarView.reloadData()
  }
  
  
  private func configureCells(cell: JTAppleCell?, state: CellState) {
    guard let customCell = cell as? DayCollectionViewCell else { return }
    
    for subview in customCell.subviews {
      subview.layer.shouldRasterize = true
      subview.layer.rasterizationScale = UIScreen.main.scale
    }
    
    customCell.cellType = .none
    
    self.handleCellsVisibility(cell: customCell, state: state)
    self.handleCellCurrentDay(cell: customCell, state: state)
    
    if displayDaysOptions == nil { return }
    
    self.handleCellsPayDays(cell: customCell, state: state)
    self.handleCellsVDDays(cell: customCell, state: state)
    self.handleCellsIVD(cell: customCell, state: state)
    self.handleCellsWeekends(cell: customCell, state: state)
    self.handleCustomDates(cell: customCell, state: state)
    
  }
  
  private func handleCellsVisibility(cell: DayCollectionViewCell, state: CellState) {
    cell.dayLabel.textColor = state.dateBelongsTo == .thisMonth ? UIColor.white : UIColor.white.withAlphaComponent(0.22)
    cell.dayLabel.font = state.dateBelongsTo == .thisMonth ? UIFont.boldSystemFont(ofSize: 14.0) : UIFont.systemFont(ofSize: 14.0)
  }
  
  private func handleCellCurrentDay(cell: DayCollectionViewCell, state: CellState) {
    if Calendar.current.isDateInToday(state.date) {
      if state.dateBelongsTo == .thisMonth {
        cell.cellType = .currentDay
      }
    }
  }
  
  private func handleCellsPayDays(cell: DayCollectionViewCell, state: CellState) {
    
    if displayDaysOptions?.showPayDays == false { return }
    
    let payDayDates = SheduleManager.shared.getPayDaysForSelectedMonth(firstDayMonth: state.date, lastDayMonth: state.date)
    
    let payDayDate = payDayDates.filter { (date) -> Bool in
      return calendar.isDate(date, inSameDayAs: state.date)
      }.first
    
    if let pd = payDayDate {
      if calendar.isDate(state.date, inSameDayAs: pd) {
        if state.dateBelongsTo == .thisMonth {
          cell.cellType = .payDay(cellState: state)
        }
      }
    }
  }
  
  private func handleCellsVDDays(cell: DayCollectionViewCell, state: CellState) {
    
    if displayDaysOptions?.showVocationDays == false { return }
    
    if state.dateBelongsTo == .thisMonth {
      if state.isSelected {
        cell.cellType = .vocationDays(cellState: state)
      }
    }
  }
  
  private func handleCellsIVD(cell: DayCollectionViewCell, state: CellState) {
    
    if displayDaysOptions?.showVocationDays == false { return }
    
    let ivdDatesByMonth = SheduleManager.shared.getIVDdateForSelectedMonth(firstDayMonth: state.date, lastDayMonth: state.date)
    
    let ivdDate = ivdDatesByMonth.filter { (date) -> Bool in
      return calendar.isDate(date, inSameDayAs: state.date)
      }.first
    
    if let ivd = ivdDate {
      if calendar.isDate(state.date, inSameDayAs: ivd) {
        cell.cellType = .ivdDay
      }
    }
    
  }
  
  private func handleCellsWeekends(cell: DayCollectionViewCell, state: CellState) {
    
    let weekendDates = SheduleManager.shared.getWeekends(firstDayMonth: state.date, lastDate: state.date)
    
    let weekendDate = weekendDates.filter { (date) -> Bool in
      return calendar.isDate(date, inSameDayAs: state.date)
      }.first
    
    if let wd = weekendDate {
      if calendar.isDate(state.date, inSameDayAs: wd) {
        if state.dateBelongsTo == .thisMonth {
          cell.cellType = .ivdDay
        }
      }
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
  
  private func setupCalendarView(dateSegment: DateSegmentInfo) {
    setupHeaderCalendarView(visibleDates: dateSegment)
  }
  
  private func setupHeaderCalendarView(visibleDates: DateSegmentInfo) {
    
    guard let date = visibleDates.monthDates.first?.date else { return }
    
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
    super.prepareForReuse()
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.monthDidChange, object: nil)
    NotificationCenter.default.removeObserver(self, name: Notification.Name.IVDDataDidChange, object: nil)
    NotificationCenter.default.removeObserver(self, name: Notification.Name.VDDateUpdate, object: nil)
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
    
    let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: dayCellIdentifier, for: indexPath) as! DayCollectionViewCell
    cell.dayLabel.text = cellState.text
    cell.payDayView.isHidden = true
    cell.isUserInteractionEnabled = false
    self.configureCells(cell: cell, state: cellState)
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
    
    let configure = ConfigurationParameters(startDate: startDate!,
                                            endDate: endDate!,
                                            generateOutDates: .tillEndOfRow,
                                            firstDayOfWeek: .monday)
    
    return configure
    
  }
  
}
