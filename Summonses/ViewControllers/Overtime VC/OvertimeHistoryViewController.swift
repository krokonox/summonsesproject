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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        registerCells()
    }
    
    private func setupView() {
        tableView.backgroundColor = .bgMainCell
        self.parent?.navigationItem.title = "Overtime History"
        tableView.tableFooterView = UIView()
        tableData = [.calendar, .item]
        for _ in 0..<10 {
            tableData.append(.item)
        }
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: calendarCellIdentifier, bundle: nil), forCellReuseIdentifier: calendarCellIdentifier)
        tableView.register(UINib(nibName: itemsCellIdentifier, bundle: nil), forCellReuseIdentifier: itemsCellIdentifier)
    }
    
    //MARK: - Cell Emun
    enum Cell {
        case calendar
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
            calendarCell.selectionStyle = .none
            calendarCell.rightHeaderCalendarConstraint.constant = 0
            calendarCell.leftHeaderCalendarConstraint.constant = 0
            calendarCell.rightCalendarConstraint.constant = 5
            calendarCell.leftCalendarConstraint.constant = 5
            calendarCell.separatorInset.left = 2000
            calendarCell.setupViews()
            return calendarCell
        case .item:
            guard let itemCell = tableView.dequeueReusableCell(withIdentifier: itemsCellIdentifier, for: indexPath) as? OvertimeHistoryItemTableViewCell else { fatalError() }
            itemCell.setData(title: "\(indexPath.section).03.18", subTitle: "Total Overtime: 20:00 hours", image: UIImage(named: "home")!)
            itemCell.delegate = self
            itemCell.isUserInteractionEnabled = true
            return itemCell
        }
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
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print("delete")
        }
        deleteAction.backgroundColor = .darkBlue
        deleteAction.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        deleteAction.image = UIImage(named: "delete")
        
        let editAction = SwipeAction(style: .destructive, title: "Edit") { action, indexPath in
            print("edit")
        }
        editAction.backgroundColor = .customBlue
        editAction.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        editAction.image = UIImage(named: "edit")
        
        let activateAction = SwipeAction(style: .destructive, title: "Activate") { action, indexPath in
            print("activate")
        }
        activateAction.backgroundColor = .lightGray
        activateAction.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        activateAction.image = UIImage(named: "activate")
        
        return [deleteAction, editAction, activateAction]
        
    }
}
