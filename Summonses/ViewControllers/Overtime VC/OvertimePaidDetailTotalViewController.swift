//
//  OvertimePaidDetailTotalViewController.swift
//  Summonses
//
//  Created by Vlad Lavrenkov on 1/23/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import SmoothPicker

class OvertimePaidDetailTotalViewController: BaseViewController {
	
	@IBOutlet weak var tableView: UITableView!
	//@IBOutlet weak var yearsSegmentControl: YearsSegmentControl!
    @IBOutlet weak var pickerView: SmoothPickerView!
	@IBOutlet weak var blueHeaderBG: UIView!
	private var tableData: [[Cell]] = [[]]
	
	private var overtimeArray = [OvertimeModel]()
	private let overtimeManager = OvertimeHistoryManager.shared
	let yearsSegmentItems: [String] = Date().getVisibleYears()
	var currencyYear = Date().getYear()
	private var years = Date().getVisibleYearsForOvertimes()
    
    var pickerViewItems = [UIView]()
	
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
		return DataBaseManager.shared.getOvertimesCash().filter { (overtime) -> Bool in
			return overtime.createDate?.getYear() == currentYear
		}
	}
	
	private func setupView() {
		tableData = [[.header], [.january, .february, .march, .quarter], [.aprill, .may, .june, .quarter], [.july, .august, .september, .quarter], [.october, .november, .december], [.total]]
		
		
//		yearsSegmentControl.setItems(items: years)
//		yearsSegmentControl.selectedSegmentIndex = 1
//		currencyYear = years[yearsSegmentControl.selectedSegmentIndex]
//		yearsSegmentControl.addTarget(self, action: #selector(selectYearAction(_:)), for: .valueChanged)
        
        //pickerView.delegate = self
        //pickerView.dataSource = self
        years = Date().getVisibleYearsForOvertimes()
        SmoothPickerConfiguration.setSelectionStyle(selectionStyle: .scale)
        setPickerViewItems(items: years)
        pickerView.firstselectedItem  = years.count - 1
        //pickerView.reloadData()
	}
	
	private func setupUI() {
		blueHeaderBG.layer.cornerRadius = CGFloat.cornerRadius4
		tableView.layer.cornerRadius = CGFloat.cornerRadius4
		
		tableView.tableFooterView = UIView()
		//		tableView.backgroundColor = .darkBlue
		tableView.separatorStyle = .none
        view.backgroundColor = .bgMainCell
	}
	
	private func registerCell() {
		tableView.register(UINib(nibName: HeaderTotalTableViewCell.className, bundle: nil), forCellReuseIdentifier: HeaderTotalTableViewCell.className)
		tableView.register(UINib(nibName: MonthTotalsOvertimeTableViewCell.className, bundle: nil), forCellReuseIdentifier: MonthTotalsOvertimeTableViewCell.className)
		tableView.register(UINib(nibName: QuarterTotalsOvertimeTableViewCell.className, bundle: nil), forCellReuseIdentifier: QuarterTotalsOvertimeTableViewCell.className)
		tableView.register(UINib(nibName: TotalOvertimeTableViewCell.className, bundle: nil), forCellReuseIdentifier: TotalOvertimeTableViewCell.className)
	}
	
	private func reloadTableData() {
		overtimeArray.removeAll()
		overtimeArray = getOvertimeTotals(currentYear: currencyYear)
		tableView.reloadData()
	}
	
//	@IBAction func nextAction(_ sender: UIButton) {
//		let currentSelectedIndex = yearsSegmentControl.selectedSegmentIndex
//		if currentSelectedIndex == yearsSegmentItems.count - 1 {
//			return
//		} else {
//			yearsSegmentControl.selectedSegmentIndex = currentSelectedIndex + 1
//		}
//		currencyYear = years[yearsSegmentControl.selectedSegmentIndex]
//		reloadTableData()
//	}
//
//	@IBAction func backAction(_ sender: UIButton) {
//		let currentSelectedIndex = yearsSegmentControl.selectedSegmentIndex
//		if currentSelectedIndex == 0 {
//			return
//		} else {
//			yearsSegmentControl.selectedSegmentIndex = currentSelectedIndex - 1
//		}
//		currencyYear = years[yearsSegmentControl.selectedSegmentIndex]
//		reloadTableData()
//	}
	
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

extension OvertimePaidDetailTotalViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return tableData.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableData[section].count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		switch tableData[indexPath.section][indexPath.row] {
		case .header:
			let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTotalTableViewCell.className, for: indexPath) as! HeaderTotalTableViewCell
			return cell
		case .january, .february, .march, .aprill, .may, .june, .july, .august, .september, .october, .november, .december:
			let cell = tableView.dequeueReusableCell(withIdentifier: MonthTotalsOvertimeTableViewCell.className, for: indexPath) as! MonthTotalsOvertimeTableViewCell
			let month = tableData[indexPath.section][indexPath.row]
			cell.monthLabel.text = month.description
			let totalData = overtimeManager.getTotalCashInMonthWithPaidDetail(month: month.idMonth, overtimes: overtimeArray)
			cell.cash = totalData.cash
			cell.earned = totalData.earned
			return cell
		case .quarter:
			let cell = tableView.dequeueReusableCell(withIdentifier: QuarterTotalsOvertimeTableViewCell.className, for: indexPath) as! QuarterTotalsOvertimeTableViewCell
			return cell
		case .total:
			let cell = tableView.dequeueReusableCell(withIdentifier: TotalOvertimeTableViewCell.className, for: indexPath) as! TotalOvertimeTableViewCell
			let totalData = overtimeManager.getTotalPaidDetail(overtimes: overtimeArray)
			cell.cash = totalData.cash
			cell.earned = totalData.earned
			return cell
		}
	}	
}

extension OvertimePaidDetailTotalViewController : SmoothPickerViewDelegate, SmoothPickerViewDataSource {
    func numberOfItems(pickerView: SmoothPickerView) -> Int {
        return pickerViewItems.count
    }
    
    func itemForIndex(index: Int, pickerView: SmoothPickerView) -> UIView {
        
        if pickerViewItems.count != 0 {
            return pickerViewItems[index]
        } else {
            return UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        }
    }

    func didSelectItem(index: Int, view: UIView, pickerView: SmoothPickerView) {
        //print("SelectedIndex \(index)")
        print("\(years[index])")
        overtimeArray = getOvertimeTotals(currentYear: years[index])
        tableView.reloadData()
    }
    
    @IBAction func navigateNext(_ sender: Any) {
        pickerView.navigate(direction: .next)
    }
    @IBAction func navigatePervious(_ sender: Any) {
        pickerView.navigate(direction: .pervious)
    }
    
    func setPickerViewItems(items: [String]) {
        self.pickerViewItems.removeAll()
        
        for value in items {
            let itemView = YearPickerSliderItemViewCell(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
            itemView.setData(value: value)
            self.pickerViewItems.append(itemView)
        }
    }
}
