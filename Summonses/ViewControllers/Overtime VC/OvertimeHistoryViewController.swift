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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableData[indexPath.row] {
        case .calendar:
            guard let calendarCell = tableView.dequeueReusableCell(withIdentifier: calendarCellIdentifier, for: indexPath) as? CalendarTableViewCell else { fatalError() }
            calendarCell.selectionStyle = .none
            calendarCell.separatorInset.left = 2000
            calendarCell.setupViews()
            return calendarCell
        case .item:
            guard let itemCell = tableView.dequeueReusableCell(withIdentifier: itemsCellIdentifier, for: indexPath) as? OvertimeHistoryItemTableViewCell else { fatalError() }
            itemCell.setData(title: "index \(indexPath.row)", subTitle: "subItem \(indexPath.row)", image: UIImage(named: "tabbar_summons")!)
            itemCell.delegate = self
            itemCell.isUserInteractionEnabled = true
            return itemCell
        }
    }
}

extension OvertimeHistoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print("delete")
        }
        deleteAction.backgroundColor = .darkBlue
        deleteAction.image = UIImage(named: "delete")
        
        let editAction = SwipeAction(style: .destructive, title: "Edit") { action, indexPath in
            print("edit")
        }
        editAction.backgroundColor = .customBlue
        editAction.image = UIImage(named: "edit")
        
        let activateAction = SwipeAction(style: .destructive, title: "Activate") { action, indexPath in
            print("activate")
        }
        activateAction.backgroundColor = .lightGray
        activateAction.image = UIImage(named: "activate")
        
        return [deleteAction, editAction, activateAction]
        
    }
}
