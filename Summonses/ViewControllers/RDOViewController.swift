//
//  RDOViewController.swift
//  Summonses
//
//  Created by Smikun Denis on 18.12.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

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

fileprivate struct ItemSettingsModel {
  var name: String!
  var isOn: Bool!
  
  init (name: String, isOn: Bool) {
    self.name = name
    self.isOn = isOn
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
  
  var calendarSectionHeight: CGFloat = 0.0
  var selectMonth: String = String()
  fileprivate var settingsCell: SettingsCellViewModel!
  fileprivate var otherSettingsCells = [ItemSettingsModel]()
  fileprivate var tableSections: [Sections] = [.calendarSection, .segmentSection, .expandableSection, .itemsSettingsSection, .otherItemsSettingSection]
  
  @IBOutlet weak var tableView: UITableView!
  
  var callBack: ((_ selectedMonth: String)->())?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let patrolModel = ItemSettingsModel(name: "Patrol", isOn: SettingsManager.shared.permissionShowPatrol)
    let srgModel = ItemSettingsModel(name: "Strategic Responce Group", isOn: SettingsManager.shared.permissionShowSRG)
    let customRDOModel = ItemSettingsModel(name: "Custom RDO", isOn: SettingsManager.shared.permissionShowCustomRDO)
    settingsCell = SettingsCellViewModel(isOpen: false, subCells: [patrolModel, srgModel, customRDOModel])
    
    let payDays = ItemSettingsModel(name: "Pay Days", isOn: SettingsManager.shared.permissionShowPayDays)
    let vocationDays = ItemSettingsModel(name: "Vocation Days", isOn: SettingsManager.shared.permissionShowVocationsDays)
    otherSettingsCells = [payDays, vocationDays]
    
    setupTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setupView()
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
        settingsCell.isOpen = false
      } else {
        settingsCell.isOpen = true
      }
      
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
      calendarCell.setupViews()
      
      return calendarCell
      
    case .segmentSection:
      
      guard let segmentCell = tableView.dequeueReusableCell(withIdentifier: segmentCellIdetifier) as? SegmentTableViewCell else { fatalError() }
      
      segmentCell.selectionStyle = .none
      segmentCell.separatorInset.left = 2000
      segmentCell.setCornersStyle(style: .fullRounded)
      
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
      
      itemSettingsCell.selectionStyle = .none
      itemSettingsCell.label.text = settingsCell.subCells[indexPath.row].name
      itemSettingsCell.switсh.isOn = settingsCell.subCells[indexPath.row].isOn
      
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
      
      otherSettingsCell.selectionStyle = .none
      otherSettingsCell.label.text = otherSettingsCells[indexPath.row].name
      otherSettingsCell.switсh.isOn = otherSettingsCells[indexPath.row].isOn
      
      return otherSettingsCell
    }
  }

}

extension RDOViewController : UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
  }
  
}
