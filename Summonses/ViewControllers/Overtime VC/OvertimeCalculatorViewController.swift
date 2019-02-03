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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.reloadData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    overtimeModel = OvertimeModel()
    tableView.reloadData()
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
    tableData = [.overtimeHeader, .segment, .rdo, .travelTime, .cashAndTimeSplit, .notes, .saveButton]
    
    tableView.reloadData()
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
	
	/// if check paid detail then (sheduled: start time and end time and and rdo and travel time and chash&time split deactivate
	///
	/// - Parameter type: String
	private func checkOvertymeType(type: String) {
		if type == "Paid Detail" {
			overtimeModel.scheduledStartTime = nil
			overtimeModel.scheduledEndTime = nil
			overtimeModel.rdo = false
			overtimeModel.travelMinutes = 0
			overtimeModel.typeTravelTime = nil
			overtimeModel.splitCashMinutes = 0
			tableView.reloadData()
		}
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
      
      overtimeHeader.startScheduledDate = overtimeModel.scheduledStartTime
      overtimeHeader.endScheduledDate = overtimeModel.scheduledEndTime
      overtimeHeader.startActualDate = overtimeModel.actualStartTime
      overtimeHeader.endActualDate = overtimeModel.actualEndTime
      
      checkRDO = { [weak self] (isOn) in
        overtimeHeader.switchToRDO(isOn: isOn)
      }
      overtimeHeader.onDateUpdateForTextF = { [weak self] (date, tf) in
        switch tf {
        case .startScheduledDate:
          self?.overtimeModel.scheduledStartTime = date
        case .endScheduledDate:
          self?.overtimeModel.scheduledEndTime = date
        case .startActualDate:
          self?.overtimeModel.actualStartTime = date
        case .endActualDate:
          self?.overtimeModel.actualEndTime = date
        }
      }
			
			overtimeHeader.onTotalActualTime = { [weak self] (time) in
				self?.overtimeModel.totalActualTime = time
			}
      
      overtimeHeader.onTotalOvertime = {[weak self] (totalWorkedMinutes) in
        self?.overtimeModel.totalOvertimeWorked = totalWorkedMinutes
      }
      
      return overtimeHeader
    case .segment:
      guard let segmentCell = tableView.dequeueReusableCell(withIdentifier: segmentCellIdentifier, for: indexPath) as? SegmentTableViewCell else { fatalError() }
//			SettingsManager.shared.isHidePaidDetail = false
      var items = ["Cash", "Time", "Paid Detail"]
      if SettingsManager.shared.isHidePaidDetail {
        if overtimeModel.type != "Paid Detail" {
          items.removeLast()
        }
      }
      segmentCell.segmentControl.setItems(items: items)
      segmentCell.setCornersStyle(style: .fullRounded)
      segmentCell.bottomConstraint.constant = 10
      segmentCell.segmentControl.selectedSegmentIndex = items.lastIndex(of: overtimeModel.type) ?? 0
      segmentCell.click = { [weak self] (type) in
        print("Selected \(type)")
				self?.checkOvertymeType(type: type)
        self?.overtimeModel.type = type
      }
      return segmentCell
      
    case .rdo:
      guard let rdoVC = tableView.dequeueReusableCell(withIdentifier: switchCellsIdentifier, for: indexPath) as? CalculatorSwitchTableViewCell else { fatalError() }
      
      rdoVC.switсh.isOn = overtimeModel.rdo
      self.checkRDO?(overtimeModel.rdo)
      rdoVC.setText(title: "RDO", helpText: nil)
      rdoVC.separator.isHidden = false
      rdoVC.changeValue = { [weak self] (isOn) in
        self?.checkRDO?(isOn)
        self?.overtimeModel.rdo = isOn
      }
      return rdoVC
      
    case .travelTime:
      guard let travelVC = tableView.dequeueReusableCell(withIdentifier: switchCellsIdentifier, for: indexPath) as? CalculatorSwitchTableViewCell else { fatalError() }
      if overtimeModel.typeTravelTime != nil {
        travelVC.setText(title: "Travel Time", helpText: "\(overtimeModel.typeTravelTime ?? ""): \(overtimeModel.travelMinutes.getTime())")
        travelVC.switсh.isOn = true
      } else {
        travelVC.setText(title: "Travel Time", helpText: nil)
      }
      
      
      travelVC.separator.isHidden = false
      travelVC.changeValue = { [weak self] (isOn) in
        print("checkbox isOn = \(isOn)")
        if isOn {
          let travelPopup = self?.storyboard?.instantiateViewController(withIdentifier: TravelTimePopupViewController.className) as! TravelTimePopupViewController
          travelPopup.callBack = { [weak self] (type, time) in
            if time == 0 {
              travelVC.setText(title: "Travel Time", helpText: nil)
              travelVC.switсh.isOn = false
              self?.overtimeModel.typeTravelTime = nil
              self?.overtimeModel.travelMinutes = 0
            } else {
              travelVC.setText(title: "Travel Time", helpText: "\(type): \(time.getTime())")
              self?.overtimeModel.typeTravelTime = type
              self?.overtimeModel.travelMinutes = time
            }
          }
          self?.present(travelPopup, animated: true, completion: nil)
        } else {
          travelVC.setText(title: "Travel Time", helpText: nil)
          self?.overtimeModel.typeTravelTime = nil
          self?.overtimeModel.travelMinutes = 0
        }
      }
      return travelVC
      
    case .cashAndTimeSplit:
      guard let cashAndTimeSplitVC = tableView.dequeueReusableCell(withIdentifier: switchCellsIdentifier, for: indexPath) as? CalculatorSwitchTableViewCell else { fatalError() }
      if overtimeModel.splitCashMinutes != 0 && overtimeModel.splitTimeMinutes != 0 {
        cashAndTimeSplitVC.setText(title: "Cash & Time Split", helpText: "Time: \(overtimeModel.splitTimeMinutes.getTime())        Cash: \(overtimeModel.splitCashMinutes.getTime())")
        cashAndTimeSplitVC.switсh.isOn = true
      } else {
        cashAndTimeSplitVC.setText(title: "Cash & Time Split", helpText: nil)
        cashAndTimeSplitVC.switсh.isOn = false
      }
      
      cashAndTimeSplitVC.changeValue = { [weak self] (isOn) in
        print("checkbox isOn = \(isOn)")
        if isOn {
          let vc = self?.storyboard?.instantiateViewController(withIdentifier: CashAndTimePopupViewController.className) as! CashAndTimePopupViewController
          vc.callBack = { [weak self] (cash, time) in
            cashAndTimeSplitVC.setText(title: "Cash & Time Split", helpText: "Time: \(time.getTime())        Cash: \(cash.getTime())")
            self?.overtimeModel.splitCashMinutes = cash
            self?.overtimeModel.splitTimeMinutes = time
          }
          self?.present(vc, animated: true, completion: nil)
        }
      }
      return cashAndTimeSplitVC
      
    case .notes:
      guard let notesCell = tableView.dequeueReusableCell(withIdentifier: notesCellIdentifier, for: indexPath) as? NotesTableViewCell else { fatalError() }
      notesCell.notesTextView.text = overtimeModel.notes
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
				self?.overtimeModel.createDate = self?.overtimeModel.actualStartTime;
        print("save button clicked")
        DataBaseManager.shared.createOvertime(object: (self?.overtimeModel)!)
        
        if let pageVC = self?.parent as? OvertimePageViewController {
          if let vc = pageVC.pages[1] as? OvertimeHistoryViewController {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
              pageVC.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
            })
          }
        }
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
