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
import SwiftyUserDefaults


let dayCellIdentifier = "DayCollectionViewCell"
let monthHeaderIdentifier = "MonthHeaderCollectionView"

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var heightHeader: NSLayoutConstraint!
    @IBOutlet weak var heightCalendar: NSLayoutConstraint!
    
    var callback:((_ type: NCWidgetDisplayMode)->())?
    var countOfRows: Int = 5
    var maxSize: CGSize!
    var expanded = false
    var currentDate: Date! = Date()
    var color = UIColor.black
    
    var calenadrNumberOfRow = 6
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd MM yyyy"
        return formatter
    }()
    
    var displayOptions: DaysDisplayedModel!
    //  var displayOptions: DaysDisplayedModel! {
    //    let options = DataBaseManager.shared.getShowOptions()
    //    return options
    //  }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataBaseManager.shared.setupDatabase()
        displayOptions = DataBaseManager.shared.getShowOptions()
        SheduleManager.shared.department = DepartmentModel(departmentType: displayOptions.department, squad: displayOptions.squad)
        
        configureColor()
        configureButtons()
        setupCalendarView()
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        callback = { [weak self] (type) in
            switch type {
            case .compact:
                self?.calenadrNumberOfRow = 1
            case .expanded:
                self?.calenadrNumberOfRow = 6
            }
            self?.getVacationPeriodsAndSelect()
            self?.calendarView.scrollToDate(Date(), animateScroll: true, completionHandler: {
                UIView.animate(withDuration: 0, animations: {
                    self?.calendarView.alpha = 1
                })
            })
        }
        print("123")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureColor()
        
        if self.extensionContext?.widgetActiveDisplayMode == .compact {
            self.calenadrNumberOfRow = 1
        } else {
            self.calenadrNumberOfRow = 6
        }
        
        self.getVacationPeriodsAndSelect()
        self.calendarView.scrollToDate(Date(), animateScroll: false)
    }
    
    private func configureColor() {
        if #available(iOSApplicationExtension 12.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                color = .white
            }
        }
    }
    
    private func configureButtons() {
        
        let arrowLeftImage = UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate)
        let arrowRightImage = UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate)
        
        backButton.setImage(arrowLeftImage, for: .normal)
        nextButton.setImage(arrowRightImage, for: .normal)
        
        backButton.tintColor = color
        nextButton.tintColor = color
    }
    
    private func setupCalendarView() {
        
        calendarView.allowsRangedSelection = true
        calendarView.allowsMultipleSelection = true
        
        calendarView.ibCalendarDelegate = self
        calendarView.ibCalendarDataSource = self
        
        let today = Date()
        calendarView.scrollToDate(today, animateScroll: false)
        
        calendarView.visibleDates { (visibleDates) in
            self.configureHeader(segmentInfo: visibleDates)
        }
        
        calendarView.minimumLineSpacing = -0.2
        calendarView.minimumInteritemSpacing = -0.2
        
        
        calendarView.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 25, right: 10)
        
        registerCells()
    }
    
    private func registerCells() {
        calendarView.register(UINib(nibName: dayCellIdentifier, bundle: nil), forCellWithReuseIdentifier: dayCellIdentifier)
    }
    
    private func configureCells(cell: JTACDayCell?, state: CellState) {
        guard let cell = cell as? DayCollectionViewCell else { return }
        
        cell.cellType = .none
        
        if (state.date.getDate() == "04.22.20") {
            print("h")
        }
        
        self.handleCellVisibility(cell: cell, state: state)
        self.handleCellCurrentDay(cell: cell, state: state)
        
        //self.handleCellsPayDays(cell: cell, state: state)
        //if !state.isSelected {
        if !self.handleCellsVDDays(cell: cell, state: state) {
            self.handleCellsWeekends(cell: cell, state: state)
            self.handleCellsPayDays(cell: cell, state: state, isSelected: false)
        } else {
            self.handleCellsPayDays(cell: cell, state: state, isSelected: true)
        }
        //self.handleCellsVDDays(cell: cell, state: state)
        self.handleCellsIVD(cell: cell, state: state)
    }
    
    private func configureHeader(segmentInfo: DateSegmentInfo) {
        guard let date = segmentInfo.monthDates.first?.date else { return }
        print(date)
        currentDate = date
        
        dateFormatter.dateFormat = "MMMM"
        let monthString = dateFormatter.string(from: date) + ", "
        let month = AttributedString.getString(text: monthString, size: 17.0, color: color, fontStyle: .bold)
        
        dateFormatter.dateFormat = "yyyy"
        let year = AttributedString.getString(text: dateFormatter.string(from: date), size: 17.0, color: color, fontStyle: .regular)
        
        
        let monthAndYear = NSMutableAttributedString(attributedString: month)
        monthAndYear.append(year)
        
        monthLabel.attributedText = monthAndYear
        calendarView.reloadData()
        
    }
    
    private func handleCellVisibility(cell: DayCollectionViewCell, state: CellState) {
        cell.dayLabel.textColor = color
        
        cell.dayLabel.alpha = state.dateBelongsTo == .thisMonth ? 1.0 : 0.22
        cell.dayLabel.font = state.dateBelongsTo == .thisMonth ? UIFont.systemFont(ofSize: 14.0, weight: .bold) : UIFont.systemFont(ofSize: 14.0)
    }
    
    private func handleCellCurrentDay(cell: DayCollectionViewCell, state: CellState) {
        if Calendar.current.isDateInToday(state.date) {
            cell.cellType = .currentDay
            cell.backgroundDayView.layer.borderWidth = 2.5
        }
    }
    
    private func handleCellsPayDays(cell: DayCollectionViewCell, state: CellState, isSelected: Bool) {
        
        if displayOptions.showPayDays == false { return }
        
        let payDayDates = SheduleManager.shared.getPayDaysForSelectedMonth(firstDayMonth: state.date, lastDayMonth: state.date)
        
        let payDayDate = payDayDates.filter { (date) -> Bool in
            return Calendar.current.isDate(date, inSameDayAs: state.date)
        }.first
        
        if (payDayDate != nil) {
            cell.cellType = .payDay(isSelected: isSelected)
            //cell.payDayView.backgroundColor = UIColor.customBlue1
        }
    }
    
    private func handleCellsVDDays(cell: DayCollectionViewCell, state: CellState) -> Bool{
        
        if displayOptions.showVocationDays == false { return false }
        
        let vdModels = SheduleManager.shared.getVocationDays()
        
        for model in vdModels {
            if Calendar.current.isDate(state.date, inSameDayAs: model.startDate!) {
                cell.cellType = .vocationDays(cellState: state)
                //cell.dayLabel.textColor = .black
                return true
            }
            if Calendar.current.isDate(state.date, inSameDayAs: model.endDate!) {
                cell.cellType = .vocationDays(cellState: state)
                //cell.dayLabel.textColor = .black
                return true
            }
            if state.date.isBetween(model.startDate!, and: model.endDate!) {
                cell.cellType = .vocationDays(cellState: state)
                //cell.dayLabel.textColor = .black
                return true
            }
        }
        return false
//        if (vocationDate != nil) {
//            cell.cellType = .vocationDays(cellState: state)
//            cell.dayLabel.textColor = .black
//        }
    }
    
    private func handleCellsIVD(cell: DayCollectionViewCell, state: CellState) {
        
        if displayOptions.showVocationDays == false { return }
        
        let ivdDatesByMonth = SheduleManager.shared.getIVDdateForSelectedMonth(firstDayMonth: state.date, lastDayMonth: state.date)
        
        let ivdDate = ivdDatesByMonth.filter { (date) -> Bool in
            return Calendar.current.isDate(date, inSameDayAs: state.date)
        }.first
        
        if (ivdDate != nil) {
            cell.cellType = .ivdDay
        }
        
    }
    
    private func handleCellsWeekends(cell: DayCollectionViewCell, state: CellState) {
        
        let weekendDates = SheduleManager.shared.getWeekends(firstDayMonth: state.date, lastDate: state.date)
        
        let weekendDate = weekendDates.filter { (date) -> Bool in
            return Calendar.current.isDate(date, inSameDayAs: state.date)
        }.first
        
        if (weekendDate != nil) {
            cell.cellType = .weekendDay
        }
    }
    
    //MARK: Get Data
    
    private func getVacationPeriodsAndSelect() {
        
//        self.calendarView.deselectAllDates()
//
//        let vocationModels = SheduleManager.shared.getVocationDays()
//
//        for model in vocationModels {
//            self.calendarView.selectDates(from: model.startDate!, to: model.endDate!, keepSelectionIfMultiSelectionAllowed: true)
//        }
    
        self.calendarView.reloadData()
    }
    
    //MARK: Actions
    
    @IBAction func nextMonthAction(_ sender: UIButton) {
        calendarView.scrollToSegment(.next)
    }
    
    @IBAction func previousMonthAction(_ sender: UIButton) {
        calendarView.scrollToSegment(.previous)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        self.maxSize = maxSize
        
        UIView.animate(withDuration: 0) {
            self.calendarView.alpha = 0
        }
        switch activeDisplayMode {
        case .compact:
            expanded = false
            //      heightHeader.constant = maxSize.height
            heightCalendar.constant = maxSize.height - 25
            UIView.animate(withDuration: 0.25) {
                self.preferredContentSize = maxSize
            }
        case .expanded:
            expanded = true
            //      heightHeader.constant = 44.0
            countOfRows = 5
            heightCalendar.constant = 250
            
            UIView.animate(withDuration: 0.25) {
                self.preferredContentSize = CGSize(width: maxSize.width, height: 280)
            }
        }
        
        self.callback!(activeDisplayMode)
        self.calendarView.scrollToDate(Date(), animateScroll: false)
        
        UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(.newData)
    }
    
}

extension TodayViewController : JTACMonthViewDelegate {
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        
        return MonthSize(defaultSize: 20)
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let currentDate = range.start
        let status = calendarView.cellStatus(for: currentDate)
        if let rows = status?.dateSection().rowCount {
            print("new rows:\(rows)")
            print("old rows:\(countOfRows)")
            if rows != countOfRows && expanded {
                if rows == 5 {
                    heightCalendar.constant = 250
                    
                    UIView.animate(withDuration: 0.25) {
                        self.preferredContentSize = CGSize(width: self.maxSize.width, height: 280)
                    }
                }
                if rows == 6 {
                    heightCalendar.constant = 290
                    
                    UIView.animate(withDuration: 0.25) {
                        self.preferredContentSize = CGSize(width: self.maxSize.width, height: 320)
                    }
                }
                calendarView.reloadData()
                calendarView.scrollToDate(currentDate, animateScroll: false)
                
                calendarView.layoutIfNeeded()
                calendarView.layoutSubviews()
                
                
                UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
                countOfRows = rows
            }
        }
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: monthHeaderIdentifier, for: indexPath)
        return header
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: dayCellIdentifier, for: indexPath) as! DayCollectionViewCell
        cell.setupConstraint(with: 0.8)

        cell.dayLabel.text = cellState.text
        cell.isUserInteractionEnabled = false
        
        self.configureCells(cell: cell, state: cellState)
        
        return cell
    }
    
    
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        configureHeader(segmentInfo: visibleDates)
    }
}



extension TodayViewController : JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let firstYear = Date().getVisibleYears().first
        let lastYear = Date().getVisibleYears().last
        
        dateFormatter.dateFormat = "dd MM yyyy"
        
        let startDate = dateFormatter.date(from: "01 01 \(firstYear!)")
        let endDate = dateFormatter.date(from: "31 12 \(lastYear!)")
       
        var isFirstDayMonday = false
        
        if let userDefaults = UserDefaults (suiteName: "group.com.summonspartner.sp") {
           isFirstDayMonday = userDefaults.bool(forKey: "firstDayWeekKey")
        }
        
        let configure = ConfigurationParameters(startDate: startDate!,
                                                endDate: endDate!,
                                                numberOfRows: calenadrNumberOfRow,
                                                calendar: Calendar.current,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfRow,
                                                firstDayOfWeek: isFirstDayMonday ? .monday : .sunday,
                                                hasStrictBoundaries: true)
        
        return configure
    }
}
