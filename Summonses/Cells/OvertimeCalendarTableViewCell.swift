//
//  CalendarTableViewCell.swift
//  Summonses
//
//  Created by Smikun Denis on 19.12.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit
import JTAppleCalendar

class OvertimeCalendarTableViewCell: MainTableViewCell {
    
    @IBOutlet weak var headerCalendarView: UIView!
    @IBOutlet weak var headerViewLabel: UILabel!
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var heightCostraintCalendarView: NSLayoutConstraint!
    
    @IBOutlet weak var rightHeaderCalendarConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftHeaderCalendarConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightCalendarConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftCalendarConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lastMonth: UIButton!
    @IBOutlet weak var nextMonth: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var bottomWhiteView: UIView!
    
    @IBOutlet weak var handlerArea: RoundView!
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var dropdownView: UIView!
    
    var customBackgoundColor = UIColor.bgMainCell
    
    var dates:[Date]?
    var currentDate = Date()
    
    var isCurrentDayShow = true
    var isPayDaysShow = false
    var isExpanded = false
    var onClick: (()->())?
    var newMonth: ((_ fistDay: Date)->())?
    
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
    
    private var isObservingState = false
    
    let firstDayOfWeak: DaysOfWeek = SettingsManager.shared.isMondayFirstDay ? .monday : .sunday
    
    //dropdown
    var cardHeight:CGFloat  {
        return self.contentView.frame.height * 0.6
    }
    var cardHandleAreaHeight:CGFloat = 30
    
    enum CardState {
        case expanded
        case collpased
    }
    
    var cardVisible = false
    var nextState:CardState {
        return cardVisible ? .collpased : .expanded
    }
    
    
    // Animation
    var animations:[UIViewPropertyAnimator] = []
    var currentAnimationProgress:CGFloat = 0
    var animationProgressWhenIntrupped:CGFloat = 0
    
    
    // visual effects
    
    var visualEffectView: UIVisualEffectView!
    
    var didBeginExpandUpdate: (()->())?
    var didBeginCollapseUpdate: (()->())?
    var didEndUpdate: (()->())?
    //dropdown
    
    @IBOutlet weak var stackViewLeftConstraints: NSLayoutConstraint!
    @IBOutlet weak var stackViewRightConstraints: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func awakeFromNib() {
        print("awakeFromNib")
        super.awakeFromNib()
        
        SettingsManager.shared.OVHistoryCurrentDate = dateFormatter.string(from: Date())
        
        setupViews()
    }
    
    deinit {
        print("deinit")
        finishObservingCalendarState()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func startObservingCalendarState() {
        if isObservingState {
            return
        }
        
        isObservingState = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(monthChange(notification:)), name: NSNotification.Name.monthDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(vdDataDidChange(notification:)), name: NSNotification.Name.VDDateUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ivdDataDidChange(notification:)), name: NSNotification.Name.IVDDataDidChange, object: nil)
        
    }
    
    func finishObservingCalendarState() {
        if !isObservingState {
            return
        }
        
        isObservingState = false
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.monthDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.IVDDataDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.VDDateUpdate, object: nil)
    }
    
    override func setupViewsCell() {
        self.contentView.backgroundColor = customBackgoundColor
    }
    
    
    func setupViews() {
        if SettingsManager.shared.OVHistoryCurrentDate != "" {
            currentDate = dateFormatter.date(from: SettingsManager.shared.OVHistoryCurrentDate)!
        }
        SettingsManager.shared.isCalendarExpanded = false
        //currentDate = Date()
        //    calendarView.scrollToDate(currentDate)
        calendarView.scrollToDate(currentDate, triggerScrollToDateDelegate: false, animateScroll: false, preferredScrollPosition: .top, extraAddedOffset: 0.0, completionHandler: nil)
        //    calendarView.scrollToDate(currentDate, animateScroll: false)
        
        calendarView.visibleDates { (dateSegment) in
            self.setupCalendarView(dateSegment: dateSegment)
        }
        calendarView.allowsRangedSelection = true
        calendarView.allowsMultipleSelection = true
        calendarView.ibCalendarDataSource = self
        calendarView.ibCalendarDelegate = self
        calendarView.minimumLineSpacing = 0.0
        calendarView.minimumInteritemSpacing = 0.0
        calendarView.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15)
        calendarView.layer.cornerRadius = CGFloat.cornerRadius4
        
        if UIScreen.main.bounds.width <= 320.0 {
            stackViewLeftConstraints.constant = 25
            stackViewRightConstraints.constant = 25
            cashLabel.font = UIFont.systemFont(ofSize: 10.0)
            timeLabel.font = UIFont.systemFont(ofSize: 10.0)
            totalLabel.font = UIFont.systemFont(ofSize: 10.0)
        }
        //    } else if UIScreen.main.bounds.width >= 375.0 {
        //
        //    } else {
        //
        //    }
        
        setupCardView()
        
        headerCalendarView.layer.cornerRadius = CGFloat.cornerRadius4
        
        registerCollectionViewCells()
        registerCollectionViewReusableViews()
        
        getVacationPeriodsAndSelect()
        
        headerViewLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headerViewTapped(recognizer:)))
        headerViewLabel.addGestureRecognizer(tapGestureRecognizer)
        
        handlerArea.roundCorners([.allCorners], radius: 4.0)
        
    }
    
    private func getVacationPeriodsAndSelect() {
        calendarView.deselectAllDates()
        
        
        let vocationModels = SheduleManager.shared.getVocationDays()
        for model in vocationModels {
            calendarView.selectDates(from: model.startDate!, to: model.endDate!, keepSelectionIfMultiSelectionAllowed: true)
            
        }
        
        calendarView.reloadData()
    }
    
    func setMonthInfo(currentDate: Date) {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let overtimeArray = DataBaseManager.shared.getOvertimesHistory().filter { (overtime) -> Bool in
            return overtime.createDate?.getYear() == "\(currentYear)"
            
        }
        
        let monthData = OvertimeHistoryManager.shared.getTotalCashInMonth(month: "\(currentMonth)", overtimes: overtimeArray)
        let cashInHours = monthData.cash.getTimeFromMinutes()
        let timeInHours = monthData.time.getTimeFromMinutes()
        let totalInHours = (monthData.cash + monthData.time).getTimeFromMinutes()
        
        timeLabel.text = "TIME: " + timeInHours
        cashLabel.text = "CASH: " + cashInHours
        totalLabel.text = "TOTAL: " + totalInHours
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
    
    
    private func configureCells(cell: JTACDayCell?, state: CellState) {
        guard let customCell = cell as? DayCollectionViewCell else { return }
        
        customCell.cellType = .none
        
        self.handleCellsVisibility(cell: customCell, state: state)
        if isCurrentDayShow {
            self.handleCellCurrentDay(cell: customCell, state: state)
        }
        self.handleCustomDates(cell: customCell, state: state)
        
        if displayDaysOptions == nil
        {
            if isPayDaysShow {
                self.handleCellsPayDays(cell: customCell, state: state)
            }
            return
        }
        self.handleCellsPayDays(cell: customCell, state: state)
        if state.isSelected {
            if !displayDaysOptions!.showVocationDays {
                self.handleCellsWeekends(cell: customCell, state: state)
            }
        } else {
            self.handleCellsWeekends(cell: customCell, state: state)
        }
        self.handleCellsVDDays(cell: customCell, state: state)
        self.handleCellsIVD(cell: customCell, state: state)
    }
    
    private func handleCellsVisibility(cell: DayCollectionViewCell, state: CellState) {
        cell.dayLabel.textColor = UIColor.white
        cell.dayLabel.alpha = state.dateBelongsTo == .thisMonth ? 1.0 : 0.22
        cell.dayLabel.font = state.dateBelongsTo == .thisMonth ? UIFont.systemFont(ofSize: 14.0, weight: .heavy) : UIFont.systemFont(ofSize: 14.0)
    }
    
    private func handleCellCurrentDay(cell: DayCollectionViewCell, state: CellState) {
        if Calendar.current.isDateInToday(state.date) {
            cell.cellType = .currentDay
        }
    }
    
    private func handleCellsPayDays(cell: DayCollectionViewCell, state: CellState) {
        
        if displayDaysOptions != nil
        {
            if displayDaysOptions?.showPayDays == false { return }
        }
        
        
        let payDayDates = SheduleManager.shared.getPayDaysForSelectedMonth(firstDayMonth: state.date, lastDayMonth: state.date)
        
        let payDayDate = payDayDates.filter { (date) -> Bool in
            return calendar.isDate(date, inSameDayAs: state.date)
        }.first
        
        if let pd = payDayDate {
            if calendar.isDate(state.date, inSameDayAs: pd) {
                cell.cellType = .calcPayDay
            }
        }
    }
    
    private func handleCellsVDDays(cell: DayCollectionViewCell, state: CellState) {
        
        if displayDaysOptions?.showVocationDays == false { return }
        
        if state.isSelected {
            cell.cellType = .vocationDays(cellState: state)
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
                cell.cellType = .weekendDay
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
        self.dateFormatter.dateFormat = "dd MM yyyy"
        SettingsManager.shared.OVHistoryCurrentDate = self.dateFormatter.string(from: date)
        print("change "  + date.getMonth())
        
        self.dateFormatter.dateFormat = "MMMM"
        let monthString = self.dateFormatter.string(from: date) + ", "
        let month = AttributedString.getString(text: monthString, size: 17.0, color: .white, fontStyle: .bold)
        
        self.dateFormatter.dateFormat = "yyyy"
        let year = AttributedString.getString(text: self.dateFormatter.string(from: date), size: 17.0, color: .white, fontStyle: .regular)
        
        let monthAndYear = NSMutableAttributedString(attributedString: month)
        monthAndYear.append(year)
        self.headerViewLabel.attributedText = monthAndYear
        
        setMonthInfo(currentDate: date)
        
        calendarView.reloadData()
    }
    
    private func registerCollectionViewCells() {
        calendarView.register(UINib(nibName: dayCellIdentifier, bundle: nil), forCellWithReuseIdentifier: dayCellIdentifier)
    }
    
    private func registerCollectionViewReusableViews() {
        self.calendarView.register(UINib(nibName: daysWeakReusableViewIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: daysWeakReusableViewIdentifier)
    }
    
    @IBAction private func syncAction(_ sender: UIButton) {
        onClick?()
    }
    
    @IBAction private func nextMonthShow(_ sender: UIButton) {
        calendarView.scrollToSegment(.next)
    }
    
    @IBAction private func lastMonthShow(_ sender: UIButton) {
        calendarView.scrollToSegment(.previous)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        finishObservingCalendarState()
    }
    
}


extension OvertimeCalendarTableViewCell : JTACMonthViewDelegate {
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {}
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        
        let headerView = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: daysWeakReusableViewIdentifier, for: indexPath)
        return headerView
        
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 36)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: dayCellIdentifier, for: indexPath) as! DayCollectionViewCell
        cell.setupConstraint(with: 0.8)
        cell.dayLabel.text = cellState.text
        cell.payDayView.isHidden = true
        cell.isUserInteractionEnabled = false
        self.configureCells(cell: cell, state: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupCalendarView(dateSegment: visibleDates)
        let monthDate = visibleDates.monthDates
        newMonth?(monthDate.last!.date)
    }
}

extension OvertimeCalendarTableViewCell : JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
        dateFormatter.dateFormat = "dd MM yyyy"
        
        if SettingsManager.shared.OVHistoryCurrentDate != "" {
            currentDate = dateFormatter.date(from: SettingsManager.shared.OVHistoryCurrentDate)!
        }
        
        print("configureCalendar" + currentDate.getMonth())
        
        let firstYear = currentDate.getVisibleYears().first
        let lastYear = currentDate.getVisibleYears().last
        
        let startDate = dateFormatter.date(from: "01 01 \(firstYear!)")
        let endDate = dateFormatter.date(from: "31 12 \(lastYear!)")
        
        let configure = ConfigurationParameters(startDate: startDate!,
                                                endDate: endDate!,
                                                generateOutDates: .tillEndOfRow,
                                                firstDayOfWeek: SettingsManager.shared.isMondayFirstDay ? .monday : .sunday)
        
        
        
        var calendar = Calendar(identifier: Calendar.Identifier.chinese)
        calendar.locale = Locale(identifier: "ru_RU")
        //print(calendar.firstWeekday)
        
        //calendarView.scrollToDate(currentDate, triggerScrollToDateDelegate: false, animateScroll: false, preferredScrollPosition: .top, extraAddedOffset: 0.0, completionHandler: nil)
        
        return configure
    }
    
}

extension OvertimeCalendarTableViewCell {
    
    func setupCardView() {
        //visualEffectView = UIVisualEffectView(frame: self.view.bounds)
        //self.view.addSubview(visualEffectView)
        
        //cardViewController = CardViewController(nibName:"CardViewController",bundle:nil)
        //self.addChild(cardViewController)
        //self.view.addSubview(cardViewController.view)
        //dropdownView.removeConstraints(dropdownView.constraints)
        //dropdownView.frame = CGRect(x:0,y:-150 ,width:290,height:236)
        //self.view.frame.height - cardHandleAreaHeight,width:self.view.frame.width,height:cardHeight)
        //dropdownView.clipsToBounds = true
        
        //        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
        //        handlerArea.addGestureRecognizer(panGestureRecognizer)
        handlerArea.roundCorners([.allCorners], radius: 4.0)
        
        
    }
    
    
    
    @objc func panned(_ recognizer:UIPanGestureRecognizer? = nil) {
        if let recognizer = recognizer {
            switch recognizer.state {
            case .began:
                startIntractiveAnimation(state: nextState, duration: 0.9)
            case .changed:
                let translation =  recognizer.translation(in: self.handlerArea)
                let fractionCompleted = translation.y / cardHeight
                let fraction = cardVisible ? -fractionCompleted : fractionCompleted
                updateIntractiveAnimation(animationProgress: fraction)
            case .ended:
                
                continueAnimation(finalVelocity: recognizer.velocity(in: self.handlerArea))
            default:
                break
            }
        }
    }
    
    @objc func headerViewTapped(recognizer:UIPanGestureRecognizer) {
        //        if !SettingsManager.shared.isCalendarExpanded {
        //            startIntractiveAnimation(state: nextState, duration: 0.9)
        //            continueAnimation(finalVelocity: CGPoint(x: 0, y: 100))
        //            SettingsManager.shared.isCalendarExpanded = true
        //        } else {
        //            startIntractiveAnimation(state: nextState, duration: 0.9)
        //            continueAnimation(finalVelocity: CGPoint(x: 0, y: -100))
        //            SettingsManager.shared.isCalendarExpanded = false
        //        }
        if  !isExpanded {
            startIntractiveAnimation(state: nextState, duration: 0.9)
            continueAnimation(finalVelocity: CGPoint(x: 0, y: 100))
            isExpanded = true
        } else {
            startIntractiveAnimation(state: nextState, duration: 0.9)
            continueAnimation(finalVelocity: CGPoint(x: 0, y: -100))
            isExpanded = false
        }
    }
    
    func createAnimation(state:CardState,duration:TimeInterval) {
        
        guard animations.isEmpty else {
            print("Animation not empty")
            return
            
        }
        
        print("array count",self.animations.count)
        
        let cardMoveDownAnimation = UIViewPropertyAnimator.init(duration: duration, dampingRatio: 1.0) { [weak self] in
            guard let `self` = self else  {return}
            
            switch state {
            case .collpased:
                //self.dropdownView.frame.origin.y = -self.cardHeight + 63  //self.view.frame.height - self.cardHandleAreaHeight
                //self.contentView.superview?.frame.size.height = 60
                if let didBeginCollapseUpdate = self.didBeginCollapseUpdate {
                    didBeginCollapseUpdate()
                }
                self.handlerArea.roundCorners([.allCorners], radius: 4.0)
            //                self?.calendarView.isHidden =  true
            //                self?.roundView.isHidden = true
            case .expanded:
                //self.dropdownView.frame.origin.y = 63//self.view.frame.height - self.cardHeight
                //self.contentView.superview?.frame.size.height = 305
                if let didBeginExpandUpdate = self.didBeginExpandUpdate {
                    didBeginExpandUpdate()
                }
                self.handlerArea.roundCorners([.bottomLeft, .bottomRight], radius: 4.0)
                self.calendarView.isHidden =  false
                self.roundView.isHidden = false
            }
            //self.calendarView.reloadData()
        }
        cardMoveDownAnimation.addCompletion { [weak self] _ in
            
            self?.cardVisible =  state ==  .collpased ? false : true
            if state == .collpased {
                self?.calendarView.isHidden =  true
                self?.roundView.isHidden = true
            }
            self?.animations.removeAll()
        }
        cardMoveDownAnimation.startAnimation()
        animations.append(cardMoveDownAnimation)
        
        //        let cornerRadiusAnimation = UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
        //            switch state {
        //            case .expanded:
        //                self?.dropdownView.layer.cornerRadius = 12
        //            case .collpased:
        //                self?.dropdownView.layer.cornerRadius = 0
        //            }
        //        }
        //        cornerRadiusAnimation.startAnimation()
        //        animations.append(cornerRadiusAnimation)
        
        //        let visualEffectAnimation = UIViewPropertyAnimator.init(duration: duration, curve: .linear) { [weak self ] in
        //            switch state {
        //            case .expanded:
        //                self?.visualEffectView.effect = UIBlurEffect(style: .dark)
        //
        //            case .collpased:
        //                self?.visualEffectView.effect =  nil
        //            }
        //        }
        //        visualEffectAnimation.startAnimation()
        //        animations.append(visualEffectAnimation)
        
        
        
    }
    
    func startIntractiveAnimation(state:CardState,duration:TimeInterval) {
        if animations.isEmpty {
            createAnimation(state: state, duration: duration)
            // Create Animations
        }
        // Here we are pause the animation and get fraction Complete value and store it. so when use change the animation we can update animation.fractionComplete in next method
        for animation in animations {
            animation.pauseAnimation()
            animationProgressWhenIntrupped = animation.fractionComplete
        }
    }
    
    func updateIntractiveAnimation(animationProgress:CGFloat)  {
        for animation in animations {
            //     print(animationProgress + animationProgressWhenIntrupped)
            animation.fractionComplete = animationProgress + animationProgressWhenIntrupped
            // print(animation.fractionComplete)
        }
    }
    
    func continueAnimation (finalVelocity:CGPoint) {
        print(cardVisible == (finalVelocity.y > 0))
        
        
        if cardVisible == (finalVelocity.y > 0) {
            var completedFraction:CGFloat = 0
            for animation in animations {
                completedFraction = animation.fractionComplete
                animation.stopAnimation(true)
                
            }
            animations.removeAll()
            self.cardVisible =  !self.cardVisible
            self.createAnimation(state: nextState, duration: TimeInterval(completedFraction * 0.9))
            
        } else {
            for animation in animations {
                animation.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                
            }
        }
    }
}

