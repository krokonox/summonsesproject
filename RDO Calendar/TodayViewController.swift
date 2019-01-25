//
//  TodayViewController.swift
//  RDO Calendar
//
//  Created by Smikun Denis on 25.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import NotificationCenter
import JTAppleCalendar

let dayCellIdentifier = "DayCollectionViewCell"
let monthHeaderIdentifier = "MonthHeaderCollectionView"

class TodayViewController: UIViewController, NCWidgetProviding {
  
  @IBOutlet weak var calendarView: JTAppleCalendarView!
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = Calendar.current.timeZone
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "dd MM yyyy"
    return formatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureButtons()
    setupCalendarView()
    getVacationPeriodsAndSelect()
    self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
  }
  
  private func configureButtons() {
    
    let arrowLeftImage = UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate)
    let arrowRightImage = UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate)
    
    backButton.setImage(arrowLeftImage, for: .normal)
    nextButton.setImage(arrowRightImage, for: .normal)
    
    backButton.tintColor = UIColor.black
    nextButton.tintColor = UIColor.black
  }
  
  private func setupCalendarView() {
    calendarView.ibCalendarDelegate = self
    calendarView.ibCalendarDataSource = self
    
    let today = Date()
    calendarView.scrollToDate(today)
    
    calendarView.visibleDates { (visibleDates) in
      self.configureHeader(segmentInfo: visibleDates)
    }
    
    calendarView.minimumLineSpacing = 0.0
    calendarView.minimumInteritemSpacing = 0.0
    calendarView.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 25, right: 10)
    
    registerCells()
  }
  
  private func registerCells() {
    calendarView.register(UINib(nibName: dayCellIdentifier, bundle: nil), forCellWithReuseIdentifier: dayCellIdentifier)
  }
  
  private func configureCells(cell: JTAppleCell?, state: CellState) {
    guard let cell = cell as? DayCollectionViewCell else { return }
    
    cell.cellType = .none
    
    handleCellVisibility(cell: cell, state: state)
    handleCellCurrentDay(cell: cell, state: state)
    handleCellsVDDays(cell: cell, state: state)
  }
  
  private func configureHeader(segmentInfo: DateSegmentInfo) {
    guard let date = segmentInfo.monthDates.first?.date else { return }
    
    dateFormatter.dateFormat = "MMMM"
    let monthString = dateFormatter.string(from: date) + ", "
    let month = AttributedString.getString(text: monthString, size: 17.0, color: .black, fontStyle: .bold)
    
    dateFormatter.dateFormat = "yyyy"
    let year = AttributedString.getString(text: dateFormatter.string(from: date), size: 17.0, color: .black, fontStyle: .regular)
    
    let monthAndYear = NSMutableAttributedString(attributedString: month)
    monthAndYear.append(year)
    
    monthLabel.attributedText = monthAndYear
    
  }
  
  private func handleCellVisibility(cell: DayCollectionViewCell, state: CellState) {
    cell.dayLabel.textColor = state.dateBelongsTo == .thisMonth ? UIColor.black : UIColor.black.withAlphaComponent(0.22)
    cell.dayLabel.font = state.dateBelongsTo == .thisMonth ? UIFont.boldSystemFont(ofSize: 14.0) : UIFont.systemFont(ofSize: 14.0)
  }
  
  private func handleCellCurrentDay(cell: DayCollectionViewCell, state: CellState) {
    if Calendar.current.isDateInToday(state.date) {
      cell.cellType = .currentDay
      cell.backgroundDayView.layer.borderWidth = 1.5
    }
  }
  
  private func handleCellsVDDays(cell: DayCollectionViewCell, state: CellState) {
    
    //if displayDaysOptions?.showVocationDays == false { return }
    
    if state.dateBelongsTo == .thisMonth {
      if state.isSelected {
        cell.cellType = .vocationDays(cellState: state)
      }
    }
  }
  
  //MARK: Get Data
  
  private func getVacationPeriodsAndSelect() {
    calendarView.deselectAllDates()
    
    let vocationModels = SheduleManager.shared.getVocationDays()
    for model in vocationModels {
      calendarView.selectDates(from: model.startDate!, to: model.endDate!, keepSelectionIfMultiSelectionAllowed: true)
    }
    
    calendarView.reloadData()
  }
  
  //MARK: Actions
  
  @IBAction func nextMonthAction(_ sender: UIButton) {
  calendarView.scrollToSegment(.next)
  }
  
  @IBAction func previousMonthAction(_ sender: UIButton) {
    calendarView.scrollToSegment(.previous)
  }
  
  
  func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
    
    switch activeDisplayMode {
    case .compact:
      UIView.animate(withDuration: 0.25) {
        self.preferredContentSize = maxSize
      }
    case .expanded:
      UIView.animate(withDuration: 0.25) {
        self.preferredContentSize = CGSize(width: maxSize.width, height: 310)
      }
    }

  }
  
  
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    completionHandler(NCUpdateResult.newData)
  }
  
}


extension TodayViewController : JTAppleCalendarViewDelegate {
  
  func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
    return MonthSize(defaultSize: 20)
  }
  
  func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
    
    let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: monthHeaderIdentifier, for: indexPath)
    return header
  }
  
  func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {}
  
  func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
    let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: dayCellIdentifier, for: indexPath) as! DayCollectionViewCell
    
    cell.dayLabel.text = cellState.text
    cell.isUserInteractionEnabled = false
    
    configureCells(cell: cell, state: cellState)
    
    return cell
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
    configureHeader(segmentInfo: visibleDates)
  }
  
  
}


extension TodayViewController : JTAppleCalendarViewDataSource {
  func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
    
    
    let firstYear = Date().getVisibleYears().first
    let lastYear = Date().getVisibleYears().last
    
    let startDate = dateFormatter.date(from: "01 01 \(firstYear!)")
    let endDate = dateFormatter.date(from: "31 12 \(lastYear!)")
    
    let configure = ConfigurationParameters(startDate: startDate!,
                                            endDate: endDate!,
                                            calendar: Calendar.current,
                                            generateInDates: .forAllMonths,
                                            generateOutDates: .tillEndOfRow,
                                            firstDayOfWeek: .monday,
                                            hasStrictBoundaries: true)
    
    return configure
  }
  
  
}
