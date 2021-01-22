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
  let overtimeCalendarCellIdentifier = "OvertimeCalendarTableViewCell"
  let itemsCellIdentifier = "OvertimeHistoryItemTableViewCell"
  var tableData = [[Cell]]()
  var overtimeData = [OvertimeModel]()
	var overtimeDataForItems = [OvertimeModel]()
  var dates = [Date]()
	var lastDay = Date()
	
	var reloadCalendar: (()->())?
  
    var cellShouldExpand = false
    
    var timeValue: Int?
    var cashValue: Int?
    
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = Calendar.current.timeZone
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "dd MM yyyy"
    return formatter
  }()
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.parent?.navigationItem.title = "Overtime History"
		lastDay = Date().endOfMonth()
    
    SettingsManager.shared.OVHistoryCurrentDate = dateFormatter.string(from: Date())
    
    registerCells()
    setupTable()
  }
	
  private func setupView() {
    tableView.backgroundColor = .bgMainCell
    tableView.tableFooterView = UIView()
    view.backgroundColor = .bgMainCell
  }
  
  private func setupTable() {
    tableData = [[.calendar],[]]
    
    getOvertimes()
    overtimeDataForItems.forEach { (om) in
			tableData[1].append(.item)
    }
    tableView.reloadData()
  }
  
    func reloadMonthInfo() {
        timeValue = 0
        cashValue = 0
        
        var cashInModel = 0
        var timeInModel = 0
        
        for overtimeModel in overtimeData {
            if overtimeModel.typeTravelTime == "Cash" {
            //                    cashMinutes += overtimeModel.travelMinutes
                                    cashInModel += overtimeModel.travelMinutes
                            }
                            
                            if overtimeModel.splitCashMinutes != 0 {
            //                    cashMinutes += overtimeModel.splitCashMinutes
                                    cashInModel += overtimeModel.splitCashMinutes
                            } else {
                                if overtimeModel.type == "Cash" {
            //                        cashMinutes += overtimeModel.totalOvertimeWorked
                                        cashInModel += overtimeModel.totalOvertimeWorked
                                }
                            }
                            
                            //get time
                            if overtimeModel.typeTravelTime == "Time" {
            //                    timeMinutes += overtimeModel.travelMinutes
                                timeInModel += overtimeModel.travelMinutes
                            }
                            if overtimeModel.splitTimeMinutes != 0 {
            //                    timeMinutes += overtimeModel.splitTimeMinutes
                                timeInModel += overtimeModel.splitTimeMinutes
                            } else {
                                if overtimeModel.type == "Time" {
            //                        timeMinutes += overtimeModel.totalOvertimeWorked
                                    timeInModel += overtimeModel.totalOvertimeWorked
                                }
                            }
                            
                            cashValue! += cashInModel
                            timeValue! += timeInModel
        }
    }
    
  private func getOvertimes() {
    
    
     
    overtimeData.removeAll()
    overtimeDataForItems.removeAll()
    overtimeData = DataBaseManager.shared.getOvertimes()
    overtimeDataForItems = overtimeData.filter({ (model) -> Bool in
        return (model.createDate?.getMonth() == lastDay.getMonth() &&
            model.createDate?.getYear() == lastDay.getYear())
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
    tableView.register(UINib(nibName: overtimeCalendarCellIdentifier, bundle: nil), forCellReuseIdentifier: overtimeCalendarCellIdentifier)
    tableView.register(UINib(nibName: itemsCellIdentifier, bundle: nil), forCellReuseIdentifier: itemsCellIdentifier)
  }
	
	private func reloadItemSection() {
		self.overtimeData.removeAll()
		self.overtimeDataForItems.removeAll()
		self.overtimeData = DataBaseManager.shared.getOvertimes()
		self.overtimeDataForItems = self.overtimeData.filter({ (model) -> Bool in
            return (model.createDate?.getMonth() == self.lastDay.getMonth()) &&
                (model.createDate?.getYear() == self.lastDay.getYear())
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
      guard let calendarCell = tableView.dequeueReusableCell(withIdentifier: overtimeCalendarCellIdentifier, for: indexPath) as? OvertimeCalendarTableViewCell else { fatalError() }
      calendarCell.isCurrentDayShow = false
      calendarCell.isPayDaysShow = true
      calendarCell.selectionStyle = .none
      //calendarCell.rightHeaderCalendarConstraint.constant = 0
      //calendarCell.leftHeaderCalendarConstraint.constant = 0
      //calendarCell.rightCalendarConstraint.constant = 5
      //calendarCell.leftCalendarConstraint.constant = 5
      calendarCell.separatorInset.left = 2000
			
      calendarCell.setDates(dates: dates)
      calendarCell.setupViews()
      //calendarCell.updateMonthInfo(timeValue: timeValue!, cashValue: cashValue!)
			
			reloadCalendar = { () in
				self.getOvertimes()
				calendarCell.setDates(dates: self.dates)
				calendarCell.calendarView.reloadData()

			}
			
			calendarCell.newMonth = { (lastDay) in
				self.lastDay = lastDay
				self.reloadItemSection()
			}
      
      calendarCell.didBeginExpandUpdate = { [weak self] in
        self?.cellShouldExpand = true
        self?.tableView.beginUpdates()
        self?.tableView.endUpdates()
        
      }
      
      calendarCell.didBeginCollapseUpdate = { [weak self] in
        self?.cellShouldExpand = false
        self?.tableView.beginUpdates()
        self?.tableView.endUpdates()
        
      }
      
//      calendarCell.didEndUpdate = { [weak self] in
//        self?.cellShouldExpand = true
//        self?.tableView.beginUpdates()
//        self?.tableView.endUpdates()
//      }
			
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
//		let cell = tableView.cellForRow(at: indexPath) as? SwipeTableViewCell
//		cell?.showSwipe(orientation: .right)
	}
	
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0.0
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0))
    headerView.backgroundColor = .bgMainCell
    return headerView
  }
    
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if tableData[indexPath.section][indexPath.row] == .calendar {
        if cellShouldExpand {
            return 311 // the height you want
        } else {
            return 71
        }
    } else {
        return UITableViewAutomaticDimension
    }
  }
}

extension OvertimeHistoryViewController: SwipeTableViewCellDelegate {
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

    //guard orientation == .right else { return nil }
    
    if orientation == .right {
        
        //delete
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let overtimeModel = self.overtimeDataForItems[indexPath.row]
            DataBaseManager.shared.removeOvertime(overtimeId: (overtimeModel.overtimeId))
            //      tableView.deleteSections(indexSet as IndexSet, with: .automatic)
            self.reloadItemSection()
            self.reloadCalendar?()
            
            if #available(iOS 14, *) {
                print("reload")
                self.reloadWidget()
            } else {
                // Fallback on earlier versions
            }
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
    } else {
        
        let overtime = overtimeDataForItems[indexPath.row]
        
        //info action
        let title = "Start time: \(overtime.actualStartTime!.getTime())\nEnd time:   \(overtime.actualEndTime!.getTime())"
        
        let infoAction = SwipeAction(style: .destructive, title: title) { action, indexPath in
            
        }
        
        infoAction.backgroundColor = .customBlue
        infoAction.font = UIFont.monospacedDigitSystemFont(ofSize: 11, weight: .regular)
        
        return [infoAction]
    }
  }
}
