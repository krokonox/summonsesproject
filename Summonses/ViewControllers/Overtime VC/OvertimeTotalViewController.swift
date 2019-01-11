//
//  OvertimeTotalViewController.swift
//  Summonses
//
//  Created by Smikun Denis on 18.12.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class OvertimeTotalViewController: BaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var yearsSegmentControl: YearsSegmentControl!
  @IBOutlet weak var blueHeaderBG: UIView!
  private var tableData: [[Cell]] = [[]]
//  private var overtimeData: []
  
  private var overtimeArray = [OvertimeModel]()
  
  let years = Date().getVisibleYears()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.parent?.navigationItem.title = "Overtime Totals"
    
    overtimeArray = getOvertimeTotals(currentYear: Date().getYear())
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerCell()
    
    setupView()
    setupUI()
  }
  
  private func getOvertimeTotals(currentYear: String) -> [OvertimeModel] {
    return DataBaseManager.shared.getOvertimes().filter { (overtime) -> Bool in
      return overtime.createDate?.getYear() == currentYear
    }
  }
  
  private func registerCell() {
    tableView.register(UINib(nibName: HeaderTotalWithTimeTableViewCell.className, bundle: nil), forCellReuseIdentifier: HeaderTotalWithTimeTableViewCell.className)
    tableView.register(UINib(nibName: MonthTotalsOvertimeWithTimeTableViewCell.className, bundle: nil), forCellReuseIdentifier: MonthTotalsOvertimeWithTimeTableViewCell.className)
    tableView.register(UINib(nibName: QuarterTotalsOvertimeWithTimeTableViewCell.className, bundle: nil), forCellReuseIdentifier: QuarterTotalsOvertimeWithTimeTableViewCell.className)
    tableView.register(UINib(nibName: TotalOvertimeWithTimeTableViewCell.className, bundle: nil), forCellReuseIdentifier: TotalOvertimeWithTimeTableViewCell.className)
  }
  
  private func setupView() {
    tableData = [[.header], [.january, .february, .march, .quarter], [.aprill, .may, .june, .quarter], [.july, .august, .september, .quarter], [.october, .november, .december, .quarter], [.total]]
    
    
    yearsSegmentControl.setItems(items: years)
    yearsSegmentControl.selectedSegmentIndex = 1
    yearsSegmentControl.addTarget(self, action: #selector(selectYearAction(_:)), for: .valueChanged)
  }
  
  private func setupUI() {
    blueHeaderBG.layer.cornerRadius = CGFloat.corderRadius5
    tableView.layer.cornerRadius = CGFloat.corderRadius5
    
    tableView.tableFooterView = UIView()
    tableView.backgroundColor = .darkBlue
    tableView.separatorStyle = .none
  }
  
  @objc private func selectYearAction(_ sender: YearsSegmentControl) {
    print("\(years[sender.selectedSegmentIndex])")
    overtimeArray = getOvertimeTotals(currentYear: years[sender.selectedSegmentIndex])
    _ = getTotalCashInMonth(month: "1")
    tableView.reloadData()
  }
  
  enum Cell: Int {
    case header
    case january
    case february
    case march
    case aprill
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
    case quarter
    case total
    
    var description: String {
      switch self {
      case .january:
        return "January"
      case .february:
        return "February"
      case .march:
        return "March"
      case .aprill:
        return "April"
      case .may:
        return "May"
      case .june:
        return "June"
      case .july:
        return "July"
      case .august:
        return "August"
      case .september:
        return "September"
      case .october:
        return "October"
      case .november:
        return "November"
      case .december:
        return "December"
      default:
        return ""
      }
    }
    
    var idMonth: String {
      switch self {
      case .january:
        return "1"
      case .february:
        return "2"
      case .march:
        return "3"
      case .aprill:
        return "4"
      case .may:
        return "5"
      case .june:
        return "6"
      case .july:
        return "7"
      case .august:
        return "8"
      case .september:
        return "9"
      case .october:
        return "10"
      case .november:
        return "11"
      case .december:
        return "12"
      default:
        return ""
      }
    }
  }
  
  func getTotalCashInMonth(month: String) -> Int {
    var minutes = 0
    _ = overtimeArray.map({ (overtimeModel) -> Void in
      if overtimeModel.type == "Cash" && overtimeModel.createDate?.getMonth() == month{
        minutes += overtimeModel.totalOvertimeWorked
      }
    })
    return minutes
  }
  
  func getTotalTimeInMonth(month: String) -> Int {
    var minutes = 0
    _ = overtimeArray.map({ (overtimeModel) -> Void in
      if overtimeModel.type == "Time" && overtimeModel.createDate?.getMonth() == month{
        minutes += overtimeModel.totalOvertimeWorked
      }
    })
    return minutes
  }
  
}

extension OvertimeTotalViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return tableData.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableData[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch tableData[indexPath.section][indexPath.row] {
    case .header:
      let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTotalWithTimeTableViewCell.className, for: indexPath) as! HeaderTotalWithTimeTableViewCell
      return cell
    case .january, .february, .march, .aprill, .may, .june, .july, .august, .september, .october, .november, .december:
      let cell = tableView.dequeueReusableCell(withIdentifier: MonthTotalsOvertimeWithTimeTableViewCell.className, for: indexPath) as! MonthTotalsOvertimeWithTimeTableViewCell
      let month = tableData[indexPath.section][indexPath.row]
      cell.monthLabel.text = month.description
      cell.cash = getTotalCashInMonth(month: month.idMonth)
      cell.time = getTotalTimeInMonth(month: month.idMonth)
      return cell
      
    case .quarter:
      let cell = tableView.dequeueReusableCell(withIdentifier: QuarterTotalsOvertimeWithTimeTableViewCell.className, for: indexPath) as! QuarterTotalsOvertimeWithTimeTableViewCell
      cell.quater = indexPath.section
      return cell
    case .total:
      let cell = tableView.dequeueReusableCell(withIdentifier: TotalOvertimeWithTimeTableViewCell.className, for: indexPath) as! TotalOvertimeWithTimeTableViewCell
      return cell
    }
  }
}
