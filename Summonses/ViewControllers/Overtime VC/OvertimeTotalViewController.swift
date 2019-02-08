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
	let overtimeManager = OvertimeHistoryManager.shared
	let yearsSegmentItems: [String] = Date().getVisibleYears()
	var currencyYear = Date().getYear()
  
  private var overtimeArray = [OvertimeModel]()
  
  let years = Date().getVisibleYears()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.parent?.navigationItem.title = "Overtime Totals"
		setupView()
		reloadTableData()
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    registerCell()
    setupUI()
  }
	
  private func getOvertimeTotals(currentYear: String) -> [OvertimeModel] {
    return DataBaseManager.shared.getOvertimesHistory().filter { (overtime) -> Bool in
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
		currencyYear = years[yearsSegmentControl.selectedSegmentIndex]
    yearsSegmentControl.addTarget(self, action: #selector(selectYearAction(_:)), for: .valueChanged)
  }
  
  private func setupUI() {
    blueHeaderBG.layer.cornerRadius = CGFloat.cornerRadius4
    tableView.layer.cornerRadius = CGFloat.cornerRadius4
    
    tableView.tableFooterView = UIView()
//    tableView.backgroundColor = .darkBlue
    tableView.separatorStyle = .none
  }
	
	private func reloadTableData() {
		overtimeArray.removeAll()
		overtimeArray = getOvertimeTotals(currentYear: currencyYear)
		tableView.reloadData()
	}
	
	@IBAction func nextAction(_ sender: UIButton) {
		let currentSelectedIndex = yearsSegmentControl.selectedSegmentIndex
		if currentSelectedIndex == yearsSegmentItems.count - 1 {
			return
		} else {
			yearsSegmentControl.selectedSegmentIndex = currentSelectedIndex + 1
		}
		currencyYear = years[yearsSegmentControl.selectedSegmentIndex]
		reloadTableData()
	}
	
	@IBAction func backAction(_ sender: UIButton) {
		let currentSelectedIndex = yearsSegmentControl.selectedSegmentIndex
		if currentSelectedIndex == 0 {
			return
		} else {
			yearsSegmentControl.selectedSegmentIndex = currentSelectedIndex - 1
		}
		currencyYear = years[yearsSegmentControl.selectedSegmentIndex]
		reloadTableData()
	}
	
  @objc private func selectYearAction(_ sender: YearsSegmentControl) {
    print("\(years[sender.selectedSegmentIndex])")
    overtimeArray = getOvertimeTotals(currentYear: years[sender.selectedSegmentIndex])
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
			
			let monthData = overtimeManager.getTotalCashInMonth(month: month.idMonth, overtimes: overtimeArray)
      cell.cash = monthData.cash
			cell.time = monthData.time
//      cell.time = overtimeManager.getTotalTimeInMonth(month: month.idMonth, overtimes: overtimeArray)
      return cell
      
    case .quarter:
      let cell = tableView.dequeueReusableCell(withIdentifier: QuarterTotalsOvertimeWithTimeTableViewCell.className, for: indexPath) as! QuarterTotalsOvertimeWithTimeTableViewCell
			cell.quater = indexPath.section
			switch indexPath.section {
				case 1:
					cell.quaterTotalTimeLabel.text = overtimeManager.getQuaterTotalTime(months: ["1","2","3"], overtimes: overtimeArray).getTime();
				case 2:
					cell.quaterTotalTimeLabel.text = overtimeManager.getQuaterTotalTime(months: ["4","5","6"], overtimes: overtimeArray).getTime();
				case 3:
					cell.quaterTotalTimeLabel.text = overtimeManager.getQuaterTotalTime(months: ["7","8","9"], overtimes: overtimeArray).getTime();
				case 4:
					cell.quaterTotalTimeLabel.text = overtimeManager.getQuaterTotalTime(months: ["10","11","12"], overtimes: overtimeArray).getTime();
				default:
					break;
			}
      cell.quater = indexPath.section
      return cell
    case .total:
      let cell = tableView.dequeueReusableCell(withIdentifier: TotalOvertimeWithTimeTableViewCell.className, for: indexPath) as! TotalOvertimeWithTimeTableViewCell
			let yearData = overtimeManager.getTotalOvertime(overtimes: overtimeArray)
			cell.cash = yearData.cash
			cell.time = yearData.time
//			cell.time = overtimeManager.getTotalTime(overtimes: overtimeArray)
      return cell
    }
  }
}
