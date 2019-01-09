//
//  OvertimeCalculatorViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 12/29/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class OvertimeCalculatorViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let overtimeHeaderCellIdentifier = "OvertimeHeaderTableViewCell"
    private let segmentCellIdentifier = "SegmentTableViewCell"
    private let notesCellIdentifier = "NotesTableViewCell"
    private let saveButtonIdentifier = "OneButtonTableViewCell"
    private let switchCellsIdentifier = "CalculatorSwitchTableViewCell"
    
    var tableData = [Cell]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.title = "Overtime Calculator"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupUI()
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: overtimeHeaderCellIdentifier, bundle: nil), forCellReuseIdentifier: overtimeHeaderCellIdentifier)
        tableView.register(UINib(nibName: segmentCellIdentifier, bundle: nil), forCellReuseIdentifier: segmentCellIdentifier)
        tableView.register(UINib(nibName: notesCellIdentifier, bundle: nil), forCellReuseIdentifier: notesCellIdentifier)
        tableView.register(UINib(nibName: saveButtonIdentifier, bundle: nil), forCellReuseIdentifier: saveButtonIdentifier)
        tableView.register(UINib(nibName: switchCellsIdentifier, bundle: nil), forCellReuseIdentifier: switchCellsIdentifier)
    }
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.bgMainCell
        tableData = [.overtimeHeader, .segment, .rdo, .travelTime, .cashAndTimeSplit,.notes, .saveButton]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    //MARK: - Cell Emun
    enum Cell {
        case overtimeHeader
        case segment
        case rdo
        case travelTime
        case cashAndTimeSplit
        case notes
        case saveButton
    }
}

extension OvertimeCalculatorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableData[indexPath.row] {
        case .overtimeHeader:
            guard let overtimeHeader = tableView.dequeueReusableCell(withIdentifier: overtimeHeaderCellIdentifier, for: indexPath) as? OvertimeHeaderTableViewCell else { fatalError() }
            return overtimeHeader
        case .segment:
            guard let segmentCell = tableView.dequeueReusableCell(withIdentifier: segmentCellIdentifier, for: indexPath) as? SegmentTableViewCell else { fatalError() }
            segmentCell.segmentControl.setItems(items: ["Cash", "Time", "Paid Detail"])
            segmentCell.setCornersStyle(style: .fullRounded)
            segmentCell.bottomConstraint.constant = 10
            segmentCell.click = { [weak self] (index) in
                print("Selected \(index)")
            }
            return segmentCell
        case .rdo:
            guard let rdoVC = tableView.dequeueReusableCell(withIdentifier: switchCellsIdentifier, for: indexPath) as? CalculatorSwitchTableViewCell else { fatalError() }
            rdoVC.setText(title: "RDO", helpText: nil)
            rdoVC.separator.isHidden = false
            rdoVC.changeValue = { [weak self] (isOn) in
                SettingsManager.shared.rdoOvertime = isOn
                NotificationCenter.default.post(name: NSNotification.Name.rdoOvertimeDidChange, object: nil)
            }
            return rdoVC
        case .travelTime:
            guard let travelVC = tableView.dequeueReusableCell(withIdentifier: switchCellsIdentifier, for: indexPath) as? CalculatorSwitchTableViewCell else { fatalError() }
            travelVC.setText(title: "Travel Time", helpText: nil)
            travelVC.separator.isHidden = false
            travelVC.changeValue = { [weak self] (isOn) in
                print("checkbox isOn = \(isOn)")
                if isOn {
                    let travelPopup = self?.storyboard?.instantiateViewController(withIdentifier: TravelTimePopupViewController.className) as! TravelTimePopupViewController
                    self?.present(travelPopup, animated: true, completion: nil)
                }
            }
            return travelVC
        case .cashAndTimeSplit:
            guard let cashAndTimeSplitVC = tableView.dequeueReusableCell(withIdentifier: switchCellsIdentifier, for: indexPath) as? CalculatorSwitchTableViewCell else { fatalError() }
            cashAndTimeSplitVC.setText(title: "Cash & Time Split", helpText: "Time: 02:00        Cash: 01:00")
            cashAndTimeSplitVC.changeValue = { [weak self] (isOn) in
                print("checkbox isOn = \(isOn)")
                if isOn {
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: CashAndTimePopupViewController.className) as! CashAndTimePopupViewController
                    vc.callBack = { [weak self] (cash, time) in
                      cashAndTimeSplitVC.helpLabel.text = "Time: \(time.hh):\(time.mm)        Cash: \(cash.hh):\(cash.mm)"
                    }
                    self?.present(vc, animated: true, completion: nil)
                }
            }
            return cashAndTimeSplitVC
        case .notes:
            guard let notesCell = tableView.dequeueReusableCell(withIdentifier: notesCellIdentifier, for: indexPath) as? NotesTableViewCell else { fatalError() }
            notesCell.setNotes(title: "NOTES", notes: "Lorem ipsum dolor sit amet, con sectetur adipiscing elit.")
            return notesCell
        case .saveButton:
            guard let saveCell = tableView.dequeueReusableCell(withIdentifier: saveButtonIdentifier, for: indexPath) as? OneButtonTableViewCell else { fatalError() }
            saveCell.setButton(title: "Save Results", backgroundColor: .customBlue1)
            saveCell.click = { [weak self] in
                print("save button clicked")
            }
            return saveCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
        cell.layoutSubviews()
    }
}
