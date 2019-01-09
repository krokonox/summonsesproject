//
//  OvertimeCalculatorViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 12/29/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit
import RealmSwift

class OvertimeCalculatorViewController: BaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private let overtimeHeaderCellIdentifier = "OvertimeHeaderTableViewCell"
  private let segmentCellIdentifier = "SegmentTableViewCell"
  private let notesCellIdentifier = "NotesTableViewCell"
  private let saveButtonIdentifier = "OneButtonTableViewCell"
  private let switchCellsIdentifier = "CalculatorSwitchTableViewCell"
  
  var tableData = [Cell]()
  
  var checkRDO:((Bool)->())?
  
  var overtimeModel = OvertimeModel()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.parent?.navigationItem.title = "Overtime Calculator"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerCell()
    setupUI()
  }
  
  private func registerCell() {
    tableView.register(UINib(nibName: overtimeHeaderCellIdentifier, bundle: nil), forCellReuseIdentifier: overtimeHeaderCellIdentifier)
    tableView.register(UINib(nibName: segmentCellIdentifier, bundle: nil), forCellReuseIdentifier: segmentCellIdentifier)
    tableView.register(UINib(nibName: notesCellIdentifier, bundle: nil), forCellReuseIdentifier: notesCellIdentifier)
    tableView.register(UINib(nibName: saveButtonIdentifier, bundle: nil), forCellReuseIdentifier: saveButtonIdentifier)
    tableView.register(UINib(nibName: switchCellsIdentifier, bundle: nil), forCellReuseIdentifier: switchCellsIdentifier)
  }
  
  private func setupUI() {
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.backgroundColor = UIColor.bgMainCell
    tableData = [.overtimeHeader, .segment, .rdo, .travelTime, .cashAndTimeSplit,.notes, .saveButton]
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    self.view.endEditing(true)
  }
  
  override func updateKeyboardHeight(_ height: CGFloat) {
    super.updateKeyboardHeight(height)
    var h: CGFloat = 0.0
    if height != 0.0 {
      h = height - 75
    }
    tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, h, 0.0)
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, h, 0.0)
  }
  
  //MARK: - Cell Emun
  enum Cell: Int {
    case overtimeHeader
    case segment
    case rdo
    case travelTime
    case cashAndTimeSplit
    case notes
    case saveButton
  }
}

extension OvertimeCalculatorViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch tableData[indexPath.row] {
    case .overtimeHeader:
      guard let overtimeHeader = tableView.dequeueReusableCell(withIdentifier: overtimeHeaderCellIdentifier, for: indexPath) as? OvertimeHeaderTableViewCell else { fatalError() }
      checkRDO = { [weak self] (isOn) in
        overtimeHeader.switchToRDO(isOn: isOn)
      }
      
      overtimeHeader.onDateUpdateForTextF = { [weak self] (date, tf) in
        switch tf {
        case .startScheduledDate:
          print(1)
          self?.overtimeModel.scheduledStartTime = date
        case .endScheduledDate:
          print(1)
          self?.overtimeModel.scheduledEndTime = date
        case .startActualDate:
          print(1)
          self?.overtimeModel.actualStartTime = date
        case .endActualDate:
          print(1)
          self?.overtimeModel.actualEndTime = date
        }
      }
      
      overtimeHeader.onTotalOvertime = {[weak self] (totalWorked) in
        self?.overtimeModel.totalOvertimeWorked = totalWorked
      }
      
      return overtimeHeader
    case .segment:
      guard let segmentCell = tableView.dequeueReusableCell(withIdentifier: segmentCellIdentifier, for: indexPath) as? SegmentTableViewCell else { fatalError() }
      //            SettingsManager.shared.paidDetail = false
      if SettingsManager.shared.paidDetail {
        segmentCell.segmentControl.setItems(items: ["Cash", "Time"])
      } else {
        segmentCell.segmentControl.setItems(items: ["Cash", "Time", "Paid Detail"])
      }
      segmentCell.setCornersStyle(style: .fullRounded)
      segmentCell.bottomConstraint.constant = 10
      segmentCell.click = { [weak self] (type) in
        print("Selected \(type)")
        self?.overtimeModel.type = type
      }
      return segmentCell
    case .rdo:
      guard let rdoVC = tableView.dequeueReusableCell(withIdentifier: switchCellsIdentifier, for: indexPath) as? CalculatorSwitchTableViewCell else { fatalError() }
      rdoVC.setText(title: "RDO", helpText: nil)
      rdoVC.separator.isHidden = false
      rdoVC.changeValue = { [weak self] (isOn) in
        self?.checkRDO?(isOn)
        self?.overtimeModel.rdo = isOn
      }
      return rdoVC
    case .travelTime:
      guard let travelVC = tableView.dequeueReusableCell(withIdentifier: switchCellsIdentifier, for: indexPath) as? CalculatorSwitchTableViewCell else { fatalError() }
      travelVC.setText(title: "Travel Time", helpText: nil)
      travelVC.separator.isHidden = false
      travelVC.changeValue = { [weak self] (isOn) in
        print("checkbox isOn = \(isOn)")
        if isOn {
          let travelPopup = self?.storyboard?.instantiateViewController(withIdentifier: TravelTimePopupViewController.className) as! TravelTimePopupViewController
            travelPopup.callBack = { [weak self] (type, time) in
              if time.hh == "00" && time.mm == "00" {
                  travelVC.setText(title: "Travel Time", helpText: nil)
                travelVC.switсh.isOn = false
                self?.overtimeModel.typeTravelTime = nil
                self?.overtimeModel.travelHH = nil
                self?.overtimeModel.travelMM = nil
              } else {
                travelVC.setText(title: "Travel Time", helpText: "\(type): \(time.hh):\(time.mm)")
                self?.overtimeModel.typeTravelTime = type
                self?.overtimeModel.travelHH = time.hh
                self?.overtimeModel.travelMM = time.mm
              }
          }
          self?.present(travelPopup, animated: false, completion: nil)
        } else {
          travelVC.setText(title: "Travel Time", helpText: nil)
          self?.overtimeModel.typeTravelTime = nil
          self?.overtimeModel.travelHH = nil
          self?.overtimeModel.travelMM = nil
        }
      }
      return travelVC
    case .cashAndTimeSplit:
      guard let cashAndTimeSplitVC = tableView.dequeueReusableCell(withIdentifier: switchCellsIdentifier, for: indexPath) as? CalculatorSwitchTableViewCell else { fatalError() }
      cashAndTimeSplitVC.setText(title: "Cash & Time Split", helpText: nil)
      cashAndTimeSplitVC.changeValue = { [weak self] (isOn) in
        print("checkbox isOn = \(isOn)")
        if isOn {
          let vc = self?.storyboard?.instantiateViewController(withIdentifier: CashAndTimePopupViewController.className) as! CashAndTimePopupViewController
          vc.callBack = { [weak self] (cash, time) in
            cashAndTimeSplitVC.setText(title: "Cash & Time Split", helpText: "Time: \(time.hh):\(time.mm)        Cash: \(cash.hh):\(cash.mm)")
            try! DataBaseManager.shared.realm.write {
              self?.overtimeModel.splitTimeHH = time.hh
              self?.overtimeModel.splitTimeMM = time.mm
              self?.overtimeModel.splitCashHH = cash.hh
              self?.overtimeModel.splitCashMM = cash.mm
            }
          }
          self?.present(vc, animated: false, completion: nil)
        }
      }
      return cashAndTimeSplitVC
    case .notes:
      guard let notesCell = tableView.dequeueReusableCell(withIdentifier: notesCellIdentifier, for: indexPath) as? NotesTableViewCell else { fatalError() }
      notesCell.startEdit = {
        let index = IndexPath(row: Cell.notes.rawValue, section: 0)
        self.tableView.scrollToRow(at: index, at: .middle, animated: true)
      }
      notesCell.updateValue = {[weak self] (text) in
        self?.overtimeModel.notes = text;
      }
      return notesCell
    case .saveButton:
      guard let saveCell = tableView.dequeueReusableCell(withIdentifier: saveButtonIdentifier, for: indexPath) as? OneButtonTableViewCell else { fatalError() }
      saveCell.setButton(title: "Save Results", backgroundColor: .customBlue1)
      saveCell.click = { [weak self] in
        print("save button clicked")
        DataBaseManager.shared.createOvertime(object: (self?.overtimeModel)!)
      }
      return saveCell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.view.endEditing(true)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.layoutIfNeeded()
    cell.layoutSubviews()
  }
}
