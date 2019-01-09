//
//  VocationDaysViewController.swift
//  Summonses
//
//  Created by Smikun Denis on 02.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import SwipeCellKit

let vocationDayCellIdentifier = "VDTableViewCell"

class VocationDaysViewController: BaseViewController {
    
    let vocationsSegmentItems: [String] = ["Vocation Days", "IVD"];
    
    @IBOutlet weak var yearsSegmentControl: YearsSegmentControl!
    @IBOutlet weak var vocationsSegmentControl: SegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSegmentControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    override func setupRightBarButtonItem() {
        let addButton = UIBarButtonItem(image:#imageLiteral(resourceName: "add_button"), style: .plain, target: self, action: #selector(addAction(sender:)))
        self.parent?.navigationItem.rightBarButtonItem =  addButton
    }
    
    private func setupView() {
        self.parent?.navigationItem.title = "Vocation Days"
        self.view.backgroundColor = UIColor.bgMainCell
    }
    
    private func setupSegmentControls() {
        yearsSegmentControl.selectedSegmentIndex = 1
        vocationsSegmentControl.selectedBackgroundColor = UIColor.darkBlue
        vocationsSegmentControl.setItems(items: vocationsSegmentItems)
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.bgMainCell
        self.tableView.separatorStyle = .none
        //self.tableView.frame = UIEdgeInsetsInsetRect(self.tableView.frame, UIEdgeInsetsMake(0, 15, 0, 15))
        
        registerTableViewCells()
    }
    
    private func registerTableViewCells() {
        self.tableView.register(UINib(nibName: vocationDayCellIdentifier, bundle: nil), forCellReuseIdentifier: vocationDayCellIdentifier)
    }
    
    //MARK: Actions
    
    @objc private func addAction(sender: Any?) {
        print("Add Vocation Days")
        
        let vocationPopupVC = AddVocationPopupController()
        vocationPopupVC.modalTransitionStyle = .crossDissolve
        vocationPopupVC.modalPresentationStyle = .overFullScreen
        vocationPopupVC.doneCallback = {[weak self] () in
            print(123)
            
        }
        self.present(vocationPopupVC, animated: true, completion: nil)
        
    }

}


extension VocationDaysViewController : UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.bgMainCell
        return view
    }
    
    
}


extension VocationDaysViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: vocationDayCellIdentifier, for: indexPath) as? VDTableViewCell else { fatalError() }
        cell.label.text = "\(indexPath.section)"
        cell.delegate = self
        
        return cell
    }
    
    
}

extension VocationDaysViewController : SwipeTableViewCellDelegate {
    
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
        
        return [deleteAction, editAction]
        
    }
}

