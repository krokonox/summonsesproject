//
//  VocationDaysViewController.swift
//  Summonses
//
//  Created by Smikun Denis on 02.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import SwipeCellKit

enum VocationSegments: Int {
  case vocationSegment = 0
  case ivdSegment = 1
}

let vocationDayCellIdentifier = "VDTableViewCell"

class VocationDaysViewController: BaseViewController {
  
  private let tableSegments : [VocationSegments] = [.vocationSegment, .ivdSegment]
  let yearsSegmentItems: [String] = Date().getVisibleYears()
  let vocationsSegmentItems: [String] = ["Vocation Days", "IVD"]
  
  @IBOutlet weak var yearsSegmentControl: YearsSegmentControl!
  @IBOutlet weak var vocationsSegmentControl: SegmentedControl!
  @IBOutlet weak var tableView: UITableView!
  
  var vocationDaysArray = [VDModel]()
  var individualVocationDaysArray = [IVDModel]()
  
  var selectedYear: String {
    get {
      return yearsSegmentItems[yearsSegmentControl.selectedSegmentIndex]
    }
  }
  
  var selectedVocationType: VocationSegments {
    get {
      return tableSegments[vocationsSegmentControl.selectedSegmentIndex]
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupTableView()
    setupSegmentControls()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.parent?.navigationItem.title = "Vocation Days" //Должен меняться при каждом перелистывании на этот контроллер
    reloadTableData()
  }
  
  private func reloadTableData() {
    
    switch selectedVocationType {
      
    case .vocationSegment:
      
      vocationDaysArray.removeAll()
      vocationDaysArray = DataBaseManager.shared.getVocationDays().filter { (vocationDay) -> Bool in
        return vocationDay.getYear() == self.selectedYear
      }
      
      vocationDaysArray = vocationDaysArray.sorted(by: {
        $0.startDate!.compare($1.startDate!) == .orderedAscending
      })
      
    case .ivdSegment:
      
      individualVocationDaysArray.removeAll()
      individualVocationDaysArray = DataBaseManager.shared.getIndividualVocationDay().filter{ (ivdDay) -> Bool in
        return ivdDay.getYear() == self.selectedYear
      }
      
      individualVocationDaysArray = individualVocationDaysArray.sorted(by: {
        $0.date!.compare($1.date!) == .orderedAscending
      })
      
    }
    
    self.tableView.reloadData()
    
  }
  
  override func setupRightBarButtonItem() {
    let addButton = UIBarButtonItem(image:#imageLiteral(resourceName: "add_button"), style: .plain, target: self, action: #selector(addAction(sender:)))
    self.parent?.navigationItem.rightBarButtonItem =  addButton
  }
  
  private func setupView() {
    self.view.backgroundColor = UIColor.bgMainCell
  }
  
  private func setupSegmentControls() {
    yearsSegmentControl.setItems(items: yearsSegmentItems)
    yearsSegmentControl.selectedSegmentIndex = 1
    
    vocationsSegmentControl.selectedBackgroundColor = UIColor.darkBlue
    vocationsSegmentControl.setItems(items: vocationsSegmentItems)
  }
  
  private func setupTableView() {
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.backgroundColor = UIColor.bgMainCell
    self.tableView.separatorStyle = .none
    
    registerTableViewCells()
  }
  
  private func registerTableViewCells() {
    self.tableView.register(UINib(nibName: vocationDayCellIdentifier, bundle: nil), forCellReuseIdentifier: vocationDayCellIdentifier)
  }
  
  //MARK: Actions
  @IBAction func segmentAction(_ sender: UISegmentedControl) {
    reloadTableData()
  }
  
  @objc private func addAction(sender: Any?) {
    
    let vocationPopupVC = AddVocationPopupController()
    vocationPopupVC.modalTransitionStyle = .crossDissolve
    vocationPopupVC.modalPresentationStyle = .overFullScreen
    
    vocationPopupVC.doneCallback = {[weak self] in
      self?.reloadTableData()
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
    
    switch selectedVocationType {
    case .vocationSegment:
      return vocationDaysArray.count
    case .ivdSegment:
      return individualVocationDaysArray.count
    }
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: vocationDayCellIdentifier, for: indexPath) as? VDTableViewCell else { fatalError() }
    
    switch selectedVocationType {
      
    case .vocationSegment:
      let vocationDays = vocationDaysArray[indexPath.section]
      cell.label.text = vocationDays.getPeriodString()
    case .ivdSegment:
      let individualVocationDay = individualVocationDaysArray[indexPath.section]
      cell.label.text = individualVocationDay.getDateString()
    }
    
    cell.delegate = self
    
    return cell
  }
  
  
}

extension VocationDaysViewController : SwipeTableViewCellDelegate {
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    
    guard orientation == .right else { return nil }
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
      print("delete")
      
      switch self.selectedVocationType {
        
      case .vocationSegment:
        let currentVocationDays = self.vocationDaysArray[indexPath.section]
        DataBaseManager.shared.removeVocationDays(object: currentVocationDays)
        self.vocationDaysArray.remove(at: indexPath.section)
      case .ivdSegment:
        let currentIndividualVocationDays = self.individualVocationDaysArray[indexPath.section]
        DataBaseManager.shared.removeIndividualVocationDay(object: currentIndividualVocationDays)
        self.individualVocationDaysArray.remove(at: indexPath.section)
      }
      
      self.reloadTableData()
      
    }
    deleteAction.backgroundColor = .darkBlue
    deleteAction.font = UIFont.systemFont(ofSize: 11, weight: .regular)
    deleteAction.image = UIImage(named: "delete")
    
    let editAction = SwipeAction(style: .destructive, title: "Edit") { action, indexPath in
      print("edit")
      
      let vocationPopupVC = AddVocationPopupController()
      vocationPopupVC.modalTransitionStyle = .crossDissolve
      vocationPopupVC.modalPresentationStyle = .overFullScreen
      
      vocationPopupVC.doneCallback = {[weak self] in
        self?.reloadTableData()
      }
      
      switch self.selectedVocationType {
        
      case .vocationSegment:
        let currentVocationDays = self.vocationDaysArray[indexPath.section]
        vocationPopupVC.vocationDays = currentVocationDays
        
      case .ivdSegment:
        let currentIndividualVocationDays = self.individualVocationDaysArray[indexPath.section]
        vocationPopupVC.individualVocationDay = currentIndividualVocationDays
      }
      
      self.present(vocationPopupVC, animated: true, completion: nil)
      
    }
    editAction.backgroundColor = .customBlue
    editAction.font = UIFont.systemFont(ofSize: 11, weight: .regular)
    editAction.image = UIImage(named: "edit")
    
    return [deleteAction, editAction]
    
  }
}

