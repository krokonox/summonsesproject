//
//  RDOViewController.swift
//  Summonses
//
//  Created by Smikun Denis on 18.12.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit
import CustomizableActionSheet

let calendarCellIdentifier = "CalendarTableViewCell"
let segmentCellIdetifier = "SegmentTableViewCell"
let expandableCellIdentifier = "ExpandableTableViewCell"
let itemSettingsCellIdentifier = "ItemSettingsTableViewCell"

let kNtfMonth: String = "kNtfMonth"

enum Sections: Int {
  case calendarSection = 0
  case segmentSection = 1
  case expandableSection = 2
  case itemsSettingsSection = 3
  case otherItemsSettingSection = 4
}

open class ItemSettingsModel {
  
  enum ItemType {
    case patrol
    case SRG
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
  
  var isExtendedCell = false
  var calendarSectionHeight: CGFloat = 0.0
  var selectMonth: String = String()
  
  fileprivate var settingsCell: SettingsCellViewModel!
  fileprivate var otherSettingsCells = [ItemSettingsModel]()
  fileprivate var tableSections: [Sections] = [.calendarSection, .segmentSection, .expandableSection, .itemsSettingsSection, .otherItemsSettingSection]

  
  var selectSquad: TypeSquad = DataBaseManager.shared.getShowOptions().squad {
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
    
    setupTableView()
    reloadSettingsData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setupView()
    NotificationCenter.default.post(name: Notification.Name.VDDateUpdate, object: nil)
  }
  
  private func reloadSettingsData() {

    let srgModel = ItemSettingsModel(name: "Strategic Responce Group", type: .SRG)
    let patrolModel = ItemSettingsModel(name: "Patrol", type: .patrol)
    settingsCell = SettingsCellViewModel(isOpen: isExtendedCell, subCells: [patrolModel, srgModel])
    
    let payDaysModel = ItemSettingsModel(name: "Pay Days", type: .payDays)
    let vocationDaysModel = ItemSettingsModel(name: "Vacation Days", type: .vocationDays)
    otherSettingsCells = [payDaysModel, vocationDaysModel]
    
    let options = DaysDisplayedModel()

    options.department = srgModel.isOn ? .srg : .patrol
    options.squad = selectSquad
    options.showPayDays = payDaysModel.isOn
    options.showVocationDays = vocationDaysModel.isOn
    
    displayDaysOptions = options
    
    if isViewLoaded {
      tableView.reloadData()
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
    self.registerCellTableView()
  }
  
  private func registerCellTableView() {
    self.tableView.register(UINib(nibName: calendarCellIdentifier, bundle: nil), forCellReuseIdentifier: calendarCellIdentifier)
    self.tableView.register(UINib(nibName: segmentCellIdetifier, bundle: nil), forCellReuseIdentifier: segmentCellIdetifier)
    self.tableView.register(UINib(nibName: expandableCellIdentifier, bundle: nil), forCellReuseIdentifier: expandableCellIdentifier)
    self.tableView.register(UINib(nibName: itemSettingsCellIdentifier, bundle: nil), forCellReuseIdentifier: itemSettingsCellIdentifier)
  }
  
  func selectMonthToCalendar(selectMonth: String) {
    DispatchQueue.main.async {
      NotificationCenter.default.post(name: NSNotification.Name.monthDidChange, object: self, userInfo:[kNtfMonth: selectMonth])
    }
  }
  
  private func export() {
    print("EXPORT")
  }

  private func showActionSheet() {
    
    var items = [CustomizableActionSheetItem]()
    
    guard let exportView = UINib(nibName: "ExportView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? ExportView else { return }
    
    exportView.swithCalback = {[weak self] (isOn) in
      self?.export()
    }
    
    let exportItem = CustomizableActionSheetItem(type: .view, height: 58)
    exportItem.view = exportView
    
    let closeItem = CustomizableActionSheetItem(type: .button, height: 58)
    closeItem.label = "Cancel"
    closeItem.font = UIFont.systemFont(ofSize: 19.0, weight: .medium)
    closeItem.textColor = UIColor.customBlue1
    closeItem.selectAction = { (actionSheet: CustomizableActionSheet) -> Void in
      actionSheet.dismiss()
    }
    
    items.append(contentsOf: [exportItem, closeItem])
    let actionSheet = CustomizableActionSheet()
    actionSheet.showInView(self.view.window!, items: items)

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
    case .expandableSection, .itemsSettingsSection, .otherItemsSettingSection:
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
      
    case .itemsSettingsSection:
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
    case .calendarSection, .segmentSection, .expandableSection:
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
      calendarCell.displayDaysOptions = displayDaysOptions
      calendarCell.onClick = {[weak self] in
          self?.showActionSheet()
      }
      return calendarCell
      
    case .segmentSection:
      
      guard let segmentCell = tableView.dequeueReusableCell(withIdentifier: segmentCellIdetifier) as? SegmentTableViewCell else { fatalError() }
      
      segmentCell.selectionStyle = .none
      segmentCell.separatorInset.left = 2000
      segmentCell.setCornersStyle(style: .fullRounded)
      
      segmentCell.segmentControl.selectedSegmentIndex = displayDaysOptions.squad.rawValue
      segmentCell.clickIndex = { [weak self] (index) in
        
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
        
      }
      
      return segmentCell
      
    case .expandableSection:
      
      guard let expandableCell = tableView.dequeueReusableCell(withIdentifier: expandableCellIdentifier) as? ExpandableTableViewCell else { fatalError() }
      
      expandableCell.selectionStyle = .none
      expandableCell.label.text = "Settings"
      expandableCell.setCornersStyle(style: .fullRounded)
      
      return expandableCell
      
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
    
  }
  
}
