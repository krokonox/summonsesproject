//
//  OvertimeHistoryViewController.swift
//  Summonses
//
//  Created by Smikun Denis on 18.12.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit
import SwipeCellKit

class OvertimeHistoryViewController: BaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  let calendarCellIdentifier = "CalendarTableViewCell"
  let itemsCellIdentifier = "OvertimeHistoryItemTableViewCell"
  var tableData = [Cell]()
  var overtimeData = [OvertimeModel]()
  var dates = [Date]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.parent?.navigationItem.title = "Overtime History"
    
    registerCells()
    setupTable()
  }
	
  private func setupView() {
    tableView.backgroundColor = .bgMainCell
    tableView.tableFooterView = UIView()
  }
  
  private func setupTable() {
    tableData = [.calendar]
    
    getOvertimes()
    overtimeData.forEach { (om) in
      tableData.append(.item)
    }
    
    tableView.reloadData()
  }
  
  private func getOvertimes() {
    overtimeData.removeAll()
    overtimeData = DataBaseManager.shared.getOvertimes()
		
		dates.removeAll()
		_ = overtimeData.map { (ovM) -> Void in
			if ovM.createDate != nil {
				dates.append(ovM.createDate!)
			}
		}
  }
	
	private func reloadTableData() {
		getOvertimes()
		tableView.reloadData()
	}
  
  private func registerCells() {
    tableView.register(UINib(nibName: calendarCellIdentifier, bundle: nil), forCellReuseIdentifier: calendarCellIdentifier)
    tableView.register(UINib(nibName: itemsCellIdentifier, bundle: nil), forCellReuseIdentifier: itemsCellIdentifier)
  }
  
  //MARK: - Cell Emun
  enum Cell: Int {
    case calendar = 0
    case item
  }
}

extension OvertimeHistoryViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return tableData.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch tableData[indexPath.section] {
    case .calendar:
      guard let calendarCell = tableView.dequeueReusableCell(withIdentifier: calendarCellIdentifier, for: indexPath) as? CalendarTableViewCell else { fatalError() }
			calendarCell.isCurrentDayShow = false
      calendarCell.selectionStyle = .none
      calendarCell.rightHeaderCalendarConstraint.constant = 0
      calendarCell.leftHeaderCalendarConstraint.constant = 0
      calendarCell.rightCalendarConstraint.constant = 5
      calendarCell.leftCalendarConstraint.constant = 5
      calendarCell.separatorInset.left = 2000
			
			calendarCell.lastMonth.isHidden = false
			calendarCell.nextMonth.isHidden = false
			calendarCell.shareButton.isHidden = true

			calendarCell.setDates(dates: dates)
      calendarCell.setupViews()
			
      return calendarCell
    case .item:
      guard let itemCell = tableView.dequeueReusableCell(withIdentifier: itemsCellIdentifier, for: indexPath) as? OvertimeHistoryItemTableViewCell else { fatalError() }
      let overtime = overtimeData[indexPath.section-1]
      
      itemCell.setData(overtimeModel: overtime)
      itemCell.delegate = self
      itemCell.isUserInteractionEnabled = true
      return itemCell
    }
  }
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as? SwipeTableViewCell
		cell?.showSwipe(orientation: .right)
	}
	
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 10.0
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 10))
    headerView.backgroundColor = .bgMainCell
    return headerView
  }
}

extension OvertimeHistoryViewController: SwipeTableViewCellDelegate {
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    
    guard orientation == .right else { return nil }
    
    //delete
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") {[weak self] action, indexPath in
      DataBaseManager.shared.removeOvertime(overtimeId: ((self?.overtimeData[indexPath.section-1].overtimeId)!))
      self?.tableData.remove(at: indexPath.section)
      tableView.beginUpdates()
      let indexSet = NSMutableIndexSet()
      indexSet.add(indexPath.section)
      tableView.deleteSections(indexSet as IndexSet, with: .automatic)
      tableView.endUpdates()
			self?.reloadTableData()
    }
		
    deleteAction.backgroundColor = .darkBlue
    deleteAction.font = UIFont.systemFont(ofSize: 11, weight: .regular)
    deleteAction.image = UIImage(named: "delete")
    
    //edit overtime
    let editAction = SwipeAction(style: .destructive, title: "Edit") { action, indexPath in
      if let pageVC = self.parent as? OvertimePageViewController {
        if let vc = pageVC.pages[0] as? OvertimeCalculatorViewController {
          pageVC.setViewControllers([vc], direction: .reverse, animated: true, completion: { (completion) in
            vc.overtimeModel = self.overtimeData[indexPath.section - 1]
          })
        }
      }
    }
    editAction.backgroundColor = .customBlue
    editAction.font = UIFont.systemFont(ofSize: 11, weight: .regular)
    editAction.image = UIImage(named: "edit")
    
    //activate
    let activateAction = SwipeAction(style: .destructive, title: "Paid") { action, indexPath in
      print("Paid")
      let ot = self.overtimeData[indexPath.section-1]
      if ot.isPaid {
        ot.isPaid = false
      } else {
        ot.isPaid = true
      }
      DataBaseManager.shared.updateOvertime(overtime: ot)
      
      //TODO: - change reload table data
      tableView.reloadData()
    }
    activateAction.backgroundColor = .lightGray
    activateAction.font = UIFont.systemFont(ofSize: 11, weight: .regular)
    activateAction.image = UIImage(named: "activate")
    return [deleteAction, editAction, activateAction]
  }
  
}
