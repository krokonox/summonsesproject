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
    
    @IBOutlet weak var calendarView: JTACMonthView!
    
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
        for view in calendarView.subviews {
            view.removeFromSuperview()
        }
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
        calendarView.allowsRangedSelection = true
        
        calendarView.ibCalendarDataSource = self
        calendarView.ibCalendarDelegate = self
        
        calendarView.isUserInteractionEnabled = false
        calendarView.minimumLineSpacing = -0.25
        calendarView.minimumInteritemSpacing = -0.25
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
        
        let vm = SheduleManager.shared.getVocationDays()
        for model in vm {
            self.calendarView.selectDates(from: model.startDate!, to: model.endDate!, keepSelectionIfMultiSelectionAllowed: true)
        }
        
        self.calendarView.reloadData()
    }
    
    private func configureCells(cell: JTACDayCell?, state: CellState) {
        guard let customCell = cell as? DayCollectionViewCell else { return }
        
        customCell.cellType = .none
        self.handleCellsVisibility(cell: customCell, state: state)
        self.handleDayTextColor(cell: customCell, state: state)
        if !state.isSelected {
            self.handleCellsWeekends(cell: customCell, state: state)
        }
        self.handleCellsVDDays(cell: customCell, state: state)
        self.handleCellsIVD(cell: customCell, state: state)
        
        if UIScreen.main.bounds.height <= 568.0 {
            customCell.backgroundDayView.layer.cornerRadius = 1.0
            customCell.selectDaysView.cornerRadius = 1.0
        } else if UIScreen.main.bounds.height >= 812.0 {
            customCell.backgroundDayView.layer.cornerRadius = 3.0
            customCell.selectDaysView.cornerRadius = 3.0
        } else {
            customCell.backgroundDayView.layer.cornerRadius = 2.0
            customCell.selectDaysView.cornerRadius = 2.0
        }
        
        
    }
    
    
    func handleCellsVisibility(cell: DayCollectionViewCell, state: CellState) {
        cell.isHidden = state.dateBelongsTo == .thisMonth ? false : true
    }
    
    func handleDayTextColor(cell: DayCollectionViewCell, state: CellState) {
        
        if Calendar.current.isDateInToday(state.date) {
            cell.cellType = .currentDay
            cell.backgroundDayView.layer.borderWidth = 1.0
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
            //if state.isSelected && calendarView.selectedDates.count > 0 {
            if state.isSelected {
                cell.cellType = .vocationDays(cellState: state)
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
                cell.cellType = .weekendDay
            }
        }
    }
    
}


extension FullCalendarCollectionViewCell: JTACMonthViewDelegate {
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {}
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        
        guard let headerView = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: fullCalendarReusableViewIdentifier, for: indexPath) as? FullCalendarCollectionReusableView else { fatalError() }
        
        dateFormatter.dateFormat = "MMMM"
        let monthString = dateFormatter.string(from: range.start).uppercased()
        headerView.monthLabel.text = monthString
        
        if SettingsManager.shared.isMondayFirstDay {
            headerView.weekLabel.text = "Mo Tu We Th Fr Sa Su"
        } else {
            headerView.weekLabel.text = "Su Mo Tu We Th Fr Sa"
        }
        
        if  UIScreen.main.bounds.width <= 320.0 {
            headerView.weekLabel.font = UIFont.systemFont(ofSize: 7.0, weight: .regular)
        } else if UIScreen.main.bounds.width >= 414.0 {
            headerView.weekLabel.font = UIFont.systemFont(ofSize: 10.3, weight: .regular)
        } else {
            headerView.weekLabel.font = UIFont.systemFont(ofSize: 9.0, weight: .regular)
        }
        
        return headerView
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        if UIScreen.main.bounds.height <= 568.0 {
            return MonthSize(defaultSize: 24)
        } else if UIScreen.main.bounds.height >= 812.0 {
            return MonthSize(defaultSize: 30)
        } else {
            return MonthSize(defaultSize: 27)
        }
        
    }
    
    
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: dayCellIdentifier, for: indexPath) as! DayCollectionViewCell
        
        cell.dayLabel.text = cellState.text
        cell.preferredRadiusSelectDayView = 3.0
        if UIScreen.main.bounds.height <= 568.0 {
            cell.dayLabel.font = UIFont.systemFont(ofSize: 7, weight: .bold)
        } else if UIScreen.main.bounds.height >= 812.0 {
            cell.dayLabel.font = UIFont.systemFont(ofSize: 9, weight: .bold)
        } else {
            cell.dayLabel.font = UIFont.systemFont(ofSize: 8, weight: .bold)
        }
        
        configureCells(cell: cell, state: cellState)
        cell.setupConstraint(with: 0.75)
        
        return cell
    }
}

extension FullCalendarCollectionViewCell: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
        dateFormatter.dateFormat = "MMMM yyyy"
        
        let startDate = dateFormatter.date(from: monthAndYearGenerate)
        let endDate = dateFormatter.date(from: monthAndYearGenerate)
        
        let configure = ConfigurationParameters(startDate: startDate!,
                                                endDate: endDate!,
                                                firstDayOfWeek: SettingsManager.shared.isMondayFirstDay ? .monday : .sunday)
        
        return configure
    }
}
