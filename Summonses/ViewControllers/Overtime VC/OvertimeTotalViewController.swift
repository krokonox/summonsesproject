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
    @IBOutlet weak var blueHeaderBG: UIView!
    
    private var tableData: [Cell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        setupUI()
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: HeaderTotalWithTimeTableViewCell.className, bundle: nil), forCellReuseIdentifier: HeaderTotalWithTimeTableViewCell.className)
        tableView.register(UINib(nibName: MonthTotalsOvertimeWithTimeTableViewCell.className, bundle: nil), forCellReuseIdentifier: MonthTotalsOvertimeWithTimeTableViewCell.className)
        tableView.register(UINib(nibName: QuarterTotalsOvertimeWithTimeTableViewCell.className, bundle: nil), forCellReuseIdentifier: QuarterTotalsOvertimeWithTimeTableViewCell.className)
        tableView.register(UINib(nibName: TotalOvertimeWithTimeTableViewCell.className, bundle: nil), forCellReuseIdentifier: TotalOvertimeWithTimeTableViewCell.className)
    }
    
    private func setupView() {
        self.parent?.navigationItem.title = "Overtime Totals"
        
        tableData = [.header, .january, .february, .march, .quarter, .april, .may, .june, .quarter, .july, .august, .september, .quarter, .october, .november, .december, .quarter, .total]
    }
    private func setupUI() {
        blueHeaderBG.layer.cornerRadius = CGFloat.corderRadius5
        tableView.layer.cornerRadius = CGFloat.corderRadius5
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .darkBlue
        tableView.separatorStyle = .none
//        tableView.isScrollEnabled = false
    }
    
    enum Cell: UInt {
        case header
        case january
        case february
        case march
        case april
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
    }
}

extension OvertimeTotalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableData[indexPath.row] {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTotalWithTimeTableViewCell.className, for: indexPath) as! HeaderTotalWithTimeTableViewCell
            return cell
        case .january, .february, .march, .april, .may, .june, .july, .august, .september, .october, .november, .december:
            let cell = tableView.dequeueReusableCell(withIdentifier: MonthTotalsOvertimeWithTimeTableViewCell.className, for: indexPath) as! MonthTotalsOvertimeWithTimeTableViewCell
            return cell
        case .quarter:
            let cell = tableView.dequeueReusableCell(withIdentifier: QuarterTotalsOvertimeWithTimeTableViewCell.className, for: indexPath) as! QuarterTotalsOvertimeWithTimeTableViewCell
            return cell
        case .total:
            let cell = tableView.dequeueReusableCell(withIdentifier: TotalOvertimeWithTimeTableViewCell.className, for: indexPath) as! TotalOvertimeWithTimeTableViewCell
            return cell
        }
    }
}
