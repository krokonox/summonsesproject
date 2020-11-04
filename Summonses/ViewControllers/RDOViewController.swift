//
//  RDOViewController.swift
//  Summonses
//
//  Created by Smikun Denis on 18.12.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit
import CustomizableActionSheet
import JTAppleCalendar
import SwipeCellKit

let calendarCellIdentifier = "CalendarTableViewCell"
let segmentCellIdetifier = "SegmentTableViewCell"
let expandableCellIdentifier = "ExpandableTableViewCell"
let itemSettingsCellIdentifier = "ItemSettingsTableViewCell"
let addScheduleCellIdentifier = "AddScheduleTableViewCell"
let scheduleItemCellIdentifier = "ScheduleItemTableViewCell"

let kNtfMonth: String = "kNtfMonth"

enum Sections: Int {
    case calendarSection = 0
    case segmentSection = 1
    case expandableSection = 2
    case addSheduleSection = 3
    case scheduleItemSection = 4
    case itemsSettingsSection = 5
    case otherItemsSettingSection = 6
}

open class ItemSettingsModel {
    
    enum ItemType {
        case patrol
        case SRG
        case steadyRDO
        case customRDO // not using at the moment
        case payDays
        case vocationDays
    }
    
    var type: ItemType!
    var name: String!
    
    var isOn: Bool {
        set {
            SettingsManager.shared.setRDOSettingsItemValueOfType(type: type, isOn: newValue)
        }
        get {
            return SettingsManager.shared.getRDOSettingsItemValueOfType(type: type)
        }
    }
    
    init (name: String, type: ItemType) {
        self.name = name
        self.type = type
        self.isOn = SettingsManager.shared.getRDOSettingsItemValueOfType(type: type)
    }
    
}

fileprivate struct SettingsCellViewModel {
    var isOpen: Bool
    var subCells: [ItemSettingsModel]
    
    init(isOpen: Bool, subCells: [ItemSettingsModel]) {
        self.isOpen = isOpen
        self.subCells = subCells
    }
}



class RDOViewController: BaseViewController {
    
    var isExtendedCell = true //false
    var calendarSectionHeight: CGFloat = 0.0
    var selectMonth: String = String()
    var tabBarHeight: CGFloat!
    var calendarCell : CalendarTableViewCell?
    var leftView: UIView!
    var rightView: UIView!
    
    fileprivate var settingsCell: SettingsCellViewModel!
    fileprivate var otherSettingsCells = [ItemSettingsModel]()
    fileprivate var tableSections: [Sections] = [.calendarSection, .addSheduleSection, .itemsSettingsSection, .otherItemsSettingSection]
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd MM yyyy"
        return formatter
    }()
    
    var selectSquad: TypeSquad = DataBaseManager.shared.getShowOptions().squad {
        didSet {
            reloadSettingsData()
        }
    }
    
    var currentSchedule: TypeDepartment = DataBaseManager.shared.getShowOptions().department {
        didSet {
            reloadSettingsData()
        }
    }
    
    var displayDaysOptions: DaysDisplayedModel! {
        willSet {
            DataBaseManager.shared.updateShowOptions(options: newValue)
        }
    }
    
    var callBack: ((_ selectedMonth: String)->())?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentSchedule)
        
        switch currentSchedule {
        case .none:
            break
        case .patrol, .srg:
            tableSections = [.calendarSection, .segmentSection, .scheduleItemSection , .itemsSettingsSection, .otherItemsSettingSection]
            break
        case .steady, .custom:
            tableSections = [.calendarSection, .scheduleItemSection , .itemsSettingsSection, .otherItemsSettingSection]
            break
        }
        
        setupTableView()
        reloadSettingsData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        NotificationCenter.default.post(name: Notification.Name.VDDateUpdate, object: nil)
    }
    
    private func reloadSettingsData() {
        
        //let srgModel = ItemSettingsModel(name: "Strategic Response Group", type: .SRG)
        //let patrolModel = ItemSettingsModel(name: "Patrol", type: .patrol)
        let payModel = ItemSettingsModel(name: "Pay Days", type: .payDays)
        let vocationModel = ItemSettingsModel(name: "Vacation Days", type: .vocationDays)
        
        settingsCell = SettingsCellViewModel(isOpen: isExtendedCell, subCells: [payModel, vocationModel])
        
        let options = DaysDisplayedModel()
        
        options.department = currentSchedule
        options.squad = selectSquad
        options.showPayDays = payModel.isOn
        options.showVocationDays = vocationModel.isOn
        
        displayDaysOptions = options
        let date = calendarCell?.calendarView.visibleDates().monthDates.first!.date ?? Date()
        
        SettingsManager.shared.currentDate = dateFormatter.string(from: date)
        
        if isViewLoaded {
            tableView.reloadData()
            tableView.layoutIfNeeded()
        }
    }
    
    private func setupView() {
        self.parent?.navigationItem.title = "RDO Calendar"
    }
    
    private func setupTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.backgroundColor = UIColor.bgMainCell
        self.tableView.separatorStyle = .none
        self.tableView.contentInset.bottom = 40
        self.tableView.showsVerticalScrollIndicator = false
        self.registerCellTableView()
        
        leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 64.0))
        leftView.backgroundColor = UIColor.white
        view.addSubview(leftView)
        rightView = UIView(frame: CGRect(x: UIScreen.main.bounds.width - 15.0, y: 0.0, width: 15.0, height: 64.0))
        rightView.backgroundColor = UIColor.white
        view.addSubview(rightView)
    }
    
    private func registerCellTableView() {
        self.tableView.register(UINib(nibName: calendarCellIdentifier, bundle: nil), forCellReuseIdentifier: calendarCellIdentifier)
        self.tableView.register(UINib(nibName: segmentCellIdetifier, bundle: nil), forCellReuseIdentifier: segmentCellIdetifier)
        self.tableView.register(UINib(nibName: expandableCellIdentifier, bundle: nil), forCellReuseIdentifier: expandableCellIdentifier)
        self.tableView.register(UINib(nibName: addScheduleCellIdentifier, bundle: nil), forCellReuseIdentifier: addScheduleCellIdentifier)
        self.tableView.register(UINib(nibName: itemSettingsCellIdentifier, bundle: nil), forCellReuseIdentifier: itemSettingsCellIdentifier)
        self.tableView.register(UINib(nibName: scheduleItemCellIdentifier, bundle: nil), forCellReuseIdentifier: scheduleItemCellIdentifier)
    }
    
    func selectMonthToCalendar(selectMonth: String) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name.monthDidChange, object: self, userInfo:[kNtfMonth: selectMonth])
        }
    }
    
    private func showActionSheet() {
        
        //    var items = [CustomizableActionSheetItem]()
        
        //    guard let exportView = UINib(nibName: "ExportView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? ExportView else { return }
        //		exportView.exportSwitch.isOn = CalendarSyncManager.shared.isExportCalendar
        //		exportView.swithCalback = {[weak self] (isOn) in
        //			if isOn {
        //				CalendarSyncManager.shared.isExportCalendar = isOn
        //			} else {
        //				CalendarSyncManager.shared.isExportCalendar = isOn
        //			}
        //			CalendarSyncManager.shared.syncCalendar()
        //		}
        //
        //    let exportItem = CustomizableActionSheetItem(type: .view, height: 58)
        //    exportItem.view = exportView
        //
        //    let closeItem = CustomizableActionSheetItem(type: .button, height: 58)
        //    closeItem.label = "Cancel"
        //    closeItem.font = UIFont.systemFont(ofSize: 19.0, weight: .medium)
        //    closeItem.textColor = UIColor.customBlue1
        //    closeItem.selectAction = { (actionSheet: CustomizableActionSheet) -> Void in
        //      actionSheet.dismiss()
        //    }
        //
        //    items.append(contentsOf: [exportItem, closeItem])
        //    let actionSheet = CustomizableActionSheet()
        //    actionSheet.showInView(self.view.window!, items: items)
        
        
        let schedulePopupVC = ScheduleSelectorPopupController()
        schedulePopupVC.modalTransitionStyle = .crossDissolve
        schedulePopupVC.modalPresentationStyle = .overFullScreen
        schedulePopupVC.onItemSelected = { [weak self] (item) in
            switch item {
            case .patrol:
                self?.tableSections = [.calendarSection, .segmentSection, .scheduleItemSection , .itemsSettingsSection, .otherItemsSettingSection]
                self?.currentSchedule = .patrol
                SettingsManager.shared.setRDOSettingsItemValueOfType(type: .patrol, isOn: true)
                
                CalendarSyncManager.shared.syncCalendar()
                
                
                break
            case .SRG:
                self?.tableSections = [.calendarSection, .segmentSection, .scheduleItemSection , .itemsSettingsSection, .otherItemsSettingSection]
                self?.currentSchedule = .srg
                SettingsManager.shared.setRDOSettingsItemValueOfType(type: .SRG, isOn: true)
                CalendarSyncManager.shared.syncCalendar()
                
                
                break
            case .customRDO:
                
                let options = DaysDisplayedModel()
                options.department = .custom
                options.squad = .firstSquad
                options.showPayDays =  true
                options.showVocationDays = false
                
                let customPopupVC = CustomRDOSelectorPopupController()
                customPopupVC.modalTransitionStyle = .crossDissolve
                customPopupVC.modalPresentationStyle = .overFullScreen
                customPopupVC.displayDaysOptions = options
                let calendarView = self!.tableView.visibleCells[0]
                
                customPopupVC.calendarFrame = self?.view.superview?.convert(calendarView.frame, to: nil)
                
                customPopupVC.onSaveButtonPressed = { [weak self] in
                    self?.tableSections = [.calendarSection, .scheduleItemSection , .itemsSettingsSection, .otherItemsSettingSection]
                    self?.currentSchedule = .custom
                    SettingsManager.shared.setRDOSettingsItemValueOfType(type: .customRDO, isOn: true)
                    CalendarSyncManager.shared.syncCalendar()
                }
                
                customPopupVC.onWillAppear = { [weak self] in
                    self?.tableView.isHidden = true
                }
                
                customPopupVC.onWillDisappear = { [weak self] in
                    self?.tableView.isHidden = false
                }
                
                self?.present(customPopupVC, animated: true, completion: nil)
                break
            case .steadyRDO:
                let options = DaysDisplayedModel()
                
                options.department = .steady
                options.squad = .firstSquad
                options.showPayDays = true
                options.showVocationDays = false
                
                let steadyPopupVC = SteadyRDOSelectorPopupController()
                steadyPopupVC.modalTransitionStyle = .crossDissolve
                steadyPopupVC.modalPresentationStyle = .overFullScreen
                steadyPopupVC.displayDaysOptions = options
                let calendarView = self!.tableView.visibleCells[0]
                
                steadyPopupVC.calendarFrame = self?.view.superview?.convert(calendarView.frame, to: nil)
                
                steadyPopupVC.onSaveButtonPressed = { [weak self] in
                    self?.tableSections = [.calendarSection, .scheduleItemSection , .itemsSettingsSection, .otherItemsSettingSection]
                    self?.currentSchedule = .steady
                    SettingsManager.shared.setRDOSettingsItemValueOfType(type: .steadyRDO, isOn: true)
                    CalendarSyncManager.shared.syncCalendar()
                }
                
                steadyPopupVC.onWillAppear = { [weak self] in
                    self?.tableView.isHidden = true
                }
                
                steadyPopupVC.onWillDisappear = { [weak self] in
                    self?.tableView.isHidden = false
                }
                
                self?.present(steadyPopupVC, animated: true, completion: nil)
                
                break
            }
        }
        
        self.present(schedulePopupVC, animated: true, completion: nil)
    }
    
}


extension RDOViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch tableSections[section] {
        case .otherItemsSettingSection:
            return settingsCell.isOpen ? 9.0 : 0.01
        default:
            return 9.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var color = UIColor()
        
        switch tableSections[section] {
        case .calendarSection:
            color = UIColor.white
        default:
            color = UIColor.bgMainCell
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 8))
        headerView.backgroundColor = color
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableSections[indexPath.section] {
        case .calendarSection:
            return calendarSectionHeight
        case .segmentSection:
            return 37
        case .addSheduleSection:
            return 125
        case .expandableSection, .itemsSettingsSection, .scheduleItemSection, .otherItemsSettingSection:
            return 67
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        
        switch tableSections[indexPath.section] {
            
        case .calendarSection:
            
            if let calendarSectionCell = cell as? CalendarTableViewCell {
                calendarSectionHeight = calendarSectionCell.frame.size.height
                calendarSectionCell.startObservingCalendarState()
            }
            
        case .segmentSection:
            break
        case .expandableSection:
            break
        case .addSheduleSection:
            break
        case .scheduleItemSection:
            break
        case .itemsSettingsSection:
            break
        case .otherItemsSettingSection:
            break
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch tableSections[indexPath.section] {
            
        case .calendarSection:
            
            if let calendarSectionCell = cell as? CalendarTableViewCell {
                calendarSectionCell.finishObservingCalendarState()
            }
            
        case .segmentSection:
            break
        case .expandableSection:
            break
        case .addSheduleSection:
            break
        case .scheduleItemSection:
            break
        case .itemsSettingsSection:
            break
        case .otherItemsSettingSection:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        switch tableSections[indexPath.section] {
            
        case .calendarSection, .segmentSection:
            break
        case .expandableSection:
            
            let cell = tableView.cellForRow(at: indexPath) as! ExpandableTableViewCell
            
            if settingsCell.isOpen {
                isExtendedCell = false
            } else {
                isExtendedCell = true
            }
            
            settingsCell.isOpen = isExtendedCell
            
            cell.update(state: settingsCell.isOpen ? .open : .close, animated: true)
            
            let sections = IndexSet(integer: indexPath.section + 1)
            tableView.reloadSections(sections, with: .none)
        case .addSheduleSection:
            break
        case .itemsSettingsSection:
            break
        case .scheduleItemSection:
            let cell = tableView.cellForRow(at: indexPath) as? SwipeTableViewCell
            cell?.showSwipe(orientation: .right)
            break
        case .otherItemsSettingSection:
            break
        }
        
        
    }
    
}


extension RDOViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableSections[section] {
        case .calendarSection, .segmentSection, .expandableSection, .addSheduleSection, .scheduleItemSection:
            return 1
        case .itemsSettingsSection:
            
            if settingsCell.isOpen {
                return settingsCell.subCells.count
            } else {
                return 0
            }
        case .otherItemsSettingSection:
            return otherSettingsCells.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var lastRowIndex = settingsCell.subCells.count - 1
        
        switch tableSections[indexPath.section] {
            
        case .calendarSection:
            
            guard let calendarCell = tableView.dequeueReusableCell(withIdentifier: calendarCellIdentifier) as? CalendarTableViewCell else { fatalError() }
            
            calendarCell.selectionStyle = .none
            calendarCell.separatorInset.left = 2000
            calendarCell.rightHeaderCalendarConstraint.constant = 0
            calendarCell.leftHeaderCalendarConstraint.constant = 0
            calendarCell.rightCalendarConstraint.constant = 5
            calendarCell.leftCalendarConstraint.constant = 5
            calendarCell.displayDaysOptions = displayDaysOptions
            calendarCell.onClick = {[weak self] in
                self?.showActionSheet()
            }
            self.calendarCell = calendarCell
            
            return calendarCell
            
        case .segmentSection:
            
            guard let segmentCell = tableView.dequeueReusableCell(withIdentifier: segmentCellIdetifier) as? SegmentTableViewCell else { fatalError() }
            
            segmentCell.selectionStyle = .none
            segmentCell.separatorInset.left = 2000
            segmentCell.setCornersStyle(style: .fullRounded)
            
            segmentCell.leadingConstraint.constant = 5
            segmentCell.trailingConstraint.constant = 5
            
            segmentCell.segmentControl.selectedSegmentIndex = displayDaysOptions.squad.rawValue
            SettingsManager.shared.typeSquad = displayDaysOptions.squad.rawValue
            
            segmentCell.clickIndex = { [weak self] (index) in
                SettingsManager.shared.typeSquad = index
                switch index {
                case 0:
                    self?.selectSquad = .firstSquad
                case 1:
                    self?.selectSquad = .secondSquard
                case 2:
                    self?.selectSquad = .thirdSquad
                default:
                    break
                }
                CalendarSyncManager.shared.syncCalendar()
                
            }
            
            return segmentCell
            
        case .expandableSection:
            
            guard let expandableCell = tableView.dequeueReusableCell(withIdentifier: expandableCellIdentifier) as? ExpandableTableViewCell else { fatalError() }
            
            expandableCell.selectionStyle = .none
            expandableCell.label.text = "Select your schedule"
            expandableCell.setCornersStyle(style: .fullRounded)
            
            return expandableCell
            
        case .addSheduleSection:
            
            guard let addScheduleCell = tableView.dequeueReusableCell(withIdentifier: addScheduleCellIdentifier) as? AddScheduleTableViewCell else { fatalError() }
            
            addScheduleCell.onPressCallBack = {[weak self] in
                self?.showActionSheet()
            }
            
            return addScheduleCell
            
        case .scheduleItemSection:
            
            guard let scheduleItemCell = tableView.dequeueReusableCell(withIdentifier: scheduleItemCellIdentifier) as? ScheduleItemTableViewCell else { fatalError() }
            
            //        scheduleItemCell.onButtonTapped = {[weak self] in
            //            self?.showActionSheet()
            //        }
            scheduleItemCell.delegate = self
            scheduleItemCell.isUserInteractionEnabled = true
            
            switch currentSchedule {
            case .patrol:
                scheduleItemCell.label.text = "Patrol"
                break
            case .srg:
                scheduleItemCell.label.text = "SRG"
                break
            case .steady:
                scheduleItemCell.label.text = "Steady RDO"
                break
            case .custom:
                scheduleItemCell.label.text = "Custom RDO"
            case .none:
                break
            }
            
            return scheduleItemCell
            
        case .itemsSettingsSection:
            
            guard let itemSettingsCell = tableView.dequeueReusableCell(withIdentifier: itemSettingsCellIdentifier) as? ItemSettingsTableViewCell else { fatalError() }
            
            if indexPath.row == 0 {
                itemSettingsCell.setCornersStyle(style: .topRounded)
            } else if indexPath.row < lastRowIndex {
                itemSettingsCell.setCornersStyle(style: .none)
            } else {
                itemSettingsCell.setCornersStyle(style: .bottomRounded)
            }
            
            if indexPath.row != lastRowIndex {
                itemSettingsCell.separator.isHidden = false
            } else {
                itemSettingsCell.separator.isHidden = true
            }
            
            let currentItemModel = settingsCell.subCells[indexPath.row]
            
            itemSettingsCell.selectionStyle = .none
            itemSettingsCell.itemModel = currentItemModel
            itemSettingsCell.switchCallBack = { [weak self] (isOn) in
                currentItemModel.isOn = isOn
                self?.reloadSettingsData()
                CalendarSyncManager.shared.syncCalendar()
            }
            
            return itemSettingsCell
            
        case .otherItemsSettingSection:
            
            guard let otherSettingsCell = tableView.dequeueReusableCell(withIdentifier: itemSettingsCellIdentifier) as? ItemSettingsTableViewCell else { fatalError() }
            
            lastRowIndex = otherSettingsCells.count - 1
            
            if indexPath.row == 0 {
                otherSettingsCell.setCornersStyle(style: .topRounded)
            } else if indexPath.row < lastRowIndex {
                otherSettingsCell.setCornersStyle(style: .none)
            } else {
                otherSettingsCell.setCornersStyle(style: .bottomRounded)
            }
            
            if indexPath.row != lastRowIndex {
                otherSettingsCell.separator.isHidden = false
            } else {
                otherSettingsCell.separator.isHidden = true
            }
            
            let currentItemModel = otherSettingsCells[indexPath.row]
            
            otherSettingsCell.selectionStyle = .none
            otherSettingsCell.itemModel = currentItemModel
            otherSettingsCell.switchCallBack = { [weak self] (isOn) in
                currentItemModel.isOn = isOn
                self?.reloadSettingsData()
            }
            
            return otherSettingsCell
            
        }
    }
    
}

extension RDOViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        leftView.frame.origin.y =  -scrollView.contentOffset.y;
        rightView.frame.origin.y =  -scrollView.contentOffset.y;
    }
    
}

extension RDOViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.tableSections = [.calendarSection, .addSheduleSection, .itemsSettingsSection, .otherItemsSettingSection]
            self.currentSchedule = .none
        }
        
        
        
        deleteAction.backgroundColor = .darkBlue
        deleteAction.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        deleteAction.image = UIImage(named: "delete")
        
        let editAction = SwipeAction(style: .destructive, title: "Edit") { action, indexPath in
            if self.currentSchedule == .custom {
                let options = DaysDisplayedModel()
                
                options.department = .custom
                options.squad = .firstSquad
                options.showPayDays =  true
                options.showVocationDays = false
                
                let customPopupVC = CustomRDOSelectorPopupController()
                customPopupVC.modalTransitionStyle = .crossDissolve
                customPopupVC.modalPresentationStyle = .overFullScreen
                customPopupVC.displayDaysOptions = options
                let calendarView = self.tableView.visibleCells[0]
                
                customPopupVC.calendarFrame = self.view.superview?.convert(calendarView.frame, to: nil)
                
                customPopupVC.onSaveButtonPressed = { [weak self] in
                    self?.tableSections = [.calendarSection, .scheduleItemSection , .itemsSettingsSection, .otherItemsSettingSection]
                    self?.currentSchedule = .custom
                    SettingsManager.shared.setRDOSettingsItemValueOfType(type: .customRDO, isOn: true)
                    CalendarSyncManager.shared.syncCalendar()
                }
                
                customPopupVC.onWillAppear = { [weak self] in
                    self?.tableView.isHidden = true
                }
                
                customPopupVC.onWillDisappear = { [weak self] in
                    self?.tableView.isHidden = false
                }
                
                self.present(customPopupVC, animated: true, completion: nil)
                
            } else if self.currentSchedule == .steady {
                let options = DaysDisplayedModel()
                
                options.department = .steady
                options.squad = .firstSquad
                options.showPayDays = true
                options.showVocationDays = false
                
                let steadyPopupVC = SteadyRDOSelectorPopupController()
                steadyPopupVC.modalTransitionStyle = .crossDissolve
                steadyPopupVC.modalPresentationStyle = .overFullScreen
                steadyPopupVC.displayDaysOptions = options
                let calendarView = self.tableView.visibleCells[0]
                
                steadyPopupVC.calendarFrame = self.view.superview?.convert(calendarView.frame, to: nil)
                
                steadyPopupVC.onSaveButtonPressed = { [weak self] in
                    self?.tableSections = [.calendarSection, .scheduleItemSection , .itemsSettingsSection, .otherItemsSettingSection]
                    self?.currentSchedule = .steady
                    SettingsManager.shared.setRDOSettingsItemValueOfType(type: .steadyRDO, isOn: true)
                    CalendarSyncManager.shared.syncCalendar()
                }
                
                steadyPopupVC.onWillAppear = { [weak self] in
                    self?.tableView.isHidden = true
                }
                
                steadyPopupVC.onWillDisappear = { [weak self] in
                    self?.tableView.isHidden = false
                }
                
                self.present(steadyPopupVC, animated: true, completion: nil)
            }
        }
        
        editAction.backgroundColor = .customBlue
        editAction.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        editAction.image = UIImage(named: "edit")
        
        
        
        switch currentSchedule {
        case .patrol, .srg:
            return [deleteAction]
        case .steady, .custom :
            return [deleteAction, editAction]
        default:
            return []
        }
    }
    
}
