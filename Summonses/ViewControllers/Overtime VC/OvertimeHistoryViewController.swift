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
  var tableData = [[Cell]]()
  var overtimeData = [OvertimeModel]()
	var overtimeDataForItems = [OvertimeModel]()
  var dates = [Date]()
	var lastDay = Date()
	
	var reloadCalendar: (()->())?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.parent?.navigationItem.title = "Overtime History"
		lastDay = Date().endOfMonth()
    registerCells()
    setupTable()
  }
	
  private func setupView() {
    tableView.backgroundColor = .bgMainCell
    tableView.tableFooterView = UIView()
  }
  
  private func setupTable() {
    tableData = [[.calendar],[]]
    
    getOvertimes()
    overtimeDataForItems.forEach { (om) in
			tableData[1].append(.item)
    }
    tableView.reloadData()
  }
  
  private func getOvertimes() {
    overtimeData.removeAll()
		overtimeDataForItems.removeAll()
		overtimeData = DataBaseManager.shared.getOvertimes()
		overtimeDataForItems = overtimeData.filter({ (model) -> Bool in
			return model.createDate!.getMonth() == lastDay.getMonth()
		})
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
	
	private func reloadItemSection() {
		self.overtimeData.removeAll()
		self.overtimeDataForItems.removeAll()
		self.overtimeData = DataBaseManager.shared.getOvertimes()
		self.overtimeDataForItems = self.overtimeData.filter({ (model) -> Bool in
			return model.createDate!.getMonth() == self.lastDay.getMonth()
		})
		self.tableData[1] = []
		self.overtimeDataForItems.forEach { (om) in
			self.tableData[1].append(.item)
		}
		tableView.reloadSections(IndexSet(integer: 1), with: .none)
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
    return tableData[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch tableData[indexPath.section][indexPath.row] {
    case .calendar:
      guard let calendarCell = tableView.dequeueReusableCell(withIdentifier: calendarCellIdentifier, for: indexPath) as? CalendarTableViewCell else { fatalError() }
			calendarCell.isCurrentDayShow = false
      calendarCell.selectionStyle = .none
      calendarCell.rightHeaderCalendarConstraint.constant = 0
      calendarCell.leftHeaderCalendarConstraint.constant = 0
      calendarCell.rightCalendarConstraint.constant = 5
      calendarCell.leftCalendarConstraint.constant = 5
      calendarCell.separatorInset.left = 2000
			
			calendarCell.setDates(dates: dates)
      calendarCell.setupViews()
			
			reloadCalendar = { () in
				self.getOvertimes()
				calendarCell.setDates(dates: self.dates)
				calendarCell.calendarView.reloadData()

			}
			
			calendarCell.newMonth = { (lastDay) in
				self.lastDay = lastDay
				self.reloadItemSection()
			}
			
      return calendarCell
    case .item:
      guard let itemCell = tableView.dequeueReusableCell(withIdentifier: itemsCellIdentifier, for: indexPath) as? OvertimeHistoryItemTableViewCell else { fatalError() }
      let overtime = overtimeDataForItems[indexPath.row]
      
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
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
			let overtimeModel = self.overtimeDataForItems[indexPath.row]
			DataBaseManager.shared.removeOvertime(overtimeId: (overtimeModel.overtimeId))
//      tableView.deleteSections(indexSet as IndexSet, with: .automatic)
			self.reloadItemSection()
			self.reloadCalendar?()
    }
		
    deleteAction.backgroundColor = .darkBlue
    deleteAction.font = UIFont.systemFont(ofSize: 11, weight: .regular)
    deleteAction.image = UIImage(named: "delete")
    
    //edit overtime
    let editAction = SwipeAction(style: .destructive, title: "Edit") { action, indexPath in
      if let pageVC = self.parent as? OvertimePageViewController {
        if let vc = pageVC.pages[0] as? OvertimeCalculatorViewController {
          pageVC.setViewControllers([vc], direction: .reverse, animated: true, completion: { (completion) in
            vc.overtimeModel = self.overtimeDataForItems[indexPath.row]
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
      let ot = self.overtimeDataForItems[indexPath.row]
      if ot.isPaid {
        ot.isPaid = false
      } else {
        ot.isPaid = true
      }
      DataBaseManager.shared.updateOvertime(overtime: ot)
      
      //TODO: - change reload table data
//      tableView.reloadData()
			tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    activateAction.backgroundColor = .lightGray
    activateAction.font = UIFont.systemFont(ofSize: 11, weight: .regular)
    activateAction.image = UIImage(named: "activate")
    return [deleteAction, editAction, activateAction]
  }
  
}
