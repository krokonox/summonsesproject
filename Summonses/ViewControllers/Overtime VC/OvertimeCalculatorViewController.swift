//
//  OvertimeCalculatorViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 12/29/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyUserDefaults

class OvertimeCalculatorViewController: BaseViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	private let overtimeHeaderCellIdentifier = "OvertimeHeaderTableViewCell"
	private let segmentCellIdentifier = "SegmentTableViewCell"
	private let notesCellIdentifier = "NotesTableViewCell"
	private let saveButtonIdentifier = "OneButtonTableViewCell"
	private let switchCellsIdentifier = "CalculatorSwitchTableViewCell"
    private let doubleSwitchCellsIdentifier = "CalculatorDoubleSwitchTableViewCell"
	
	var tableData = [Cell]()
	
	var checkRDO:((Bool)->())?
	
	var isEnableSheduledTime:((Bool)->())?
	var isEnableRDO:((Bool)->())?
	var isEnableTravelTime:((Bool)->())?
	var isEnableSplit:((Bool)->())?
	var isEnableMyTour:((Bool)->())?
	var isEnableTour:((Bool)->())?
	var isChangeRDO:((Bool)->())?
	var isChangeMyTour:((Bool)->())?
	
	var overtimeModel = OvertimeModel()
	
	var startTourSecond = 0
	var endTourSecond = 0
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.parent?.navigationItem.title = "Overtime Calculator"
		overtimeModel.totalActualTime = 0
		tableView.reloadData()
		
		isEnableSheduledTime?(true)
		isEnableRDO?(true)
		isEnableTravelTime?(true)
		isEnableSplit?(true)
		isEnableTour?(true)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		tableView.reloadData()
		
		startTourSecond = UserDefaults.standard.integer(forKey: K.UserDefaults.startTourSecond)
		endTourSecond = UserDefaults.standard.integer(forKey: K.UserDefaults.endTourSecond)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		overtimeModel = OvertimeModel()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		registerCell()
		setupUI()
		
		if !Defaults[.firstOpenOvertime] {
			Defaults[.firstOpenOvertime] = true
            let text = """
                       Before using Overtime Calculator tap the settings to set default values:
                          ∙ Overtime Rate
                          ∙ Paid Detail Rate
                          ∙ Start tour
                          ∙ End tour
                       """
			//Alert.show(title: "Reminder", subtitle: text)
            
            let message = ""
            let alertController = UIAlertController(
                title: "", // This gets overridden below.
                message: message,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .cancel) { _ -> Void in
            }
            alertController.addAction(okAction)

            
            let attString = NSMutableAttributedString()
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .left
            attString.append(NSAttributedString(string: "Reminder\n\n", attributes: [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
            ]))
            attString.append(NSAttributedString(string: text, attributes: [.paragraphStyle: paragraph,
                  NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]))
            alertController.setValue(attString, forKey: "attributedTitle")
            self.present(alertController, animated: true, completion: nil)
		}
	}
	
	private func registerCell() {
		tableView.register(UINib(nibName: overtimeHeaderCellIdentifier, bundle: nil), forCellReuseIdentifier: overtimeHeaderCellIdentifier)
		tableView.register(UINib(nibName: segmentCellIdentifier, bundle: nil), forCellReuseIdentifier: segmentCellIdentifier)
		tableView.register(UINib(nibName: notesCellIdentifier, bundle: nil), forCellReuseIdentifier: notesCellIdentifier)
		tableView.register(UINib(nibName: saveButtonIdentifier, bundle: nil), forCellReuseIdentifier: saveButtonIdentifier)
		tableView.register(UINib(nibName: switchCellsIdentifier, bundle: nil), forCellReuseIdentifier: switchCellsIdentifier)
        tableView.register(UINib(nibName: doubleSwitchCellsIdentifier, bundle: nil), forCellReuseIdentifier: doubleSwitchCellsIdentifier)
	}
	
	private func setupUI() {
        
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		tableView.backgroundColor = UIColor.bgMainCell
        if UIScreen.main.bounds.height <= 736 {
            tableData = [.overtimeHeader, .segment, .tourRDO, .travelTime, .cashAndTimeSplit, .notes, .saveButton]
        } else {
            tableData = [.overtimeHeader, .segment, .tour, .rdo, .travelTime, .cashAndTimeSplit, .notes, .saveButton]
        }
		tableView.reloadData()
        view.backgroundColor = .bgMainCell
	}
	
	private func isValidInfo() -> Bool {
        if overtimeModel.totalOvertimeWorked == 0 && overtimeModel.travelMinutes == 0 {
            showErrorAlert()
            return false
        }
        if overtimeModel.type == "Cash" || overtimeModel.type == "Time" {
			if overtimeModel.rdo && (overtimeModel.actualStartTime != nil && overtimeModel.actualEndTime != nil) {
				return true
			} else {
				if overtimeModel.scheduledStartTime == nil || overtimeModel.scheduledEndTime == nil ||
					overtimeModel.actualStartTime == nil || overtimeModel.actualEndTime == nil {
					showErrorAlert()
					return false
				}
			}
		} else if overtimeModel.type == "Paid Detail" {
			if overtimeModel.actualStartTime != nil && overtimeModel.actualEndTime != nil {
				return true
			} else{
				showErrorAlert()
				return false
			}
		}
		return true
	}
	
	private func showErrorAlert() {
		Alert.show(title: "Error", subtitle: "Invalid data")
	}
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		self.view.endEditing(true)
	}
	
	override func updateKeyboardHeight(_ height: CGFloat) {
		super.updateKeyboardHeight(height)
		var h: CGFloat = 0.0
		if height != 0.0 {
			h = height - 75
		}
		tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, h, 0.0)
		tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, h, 0.0)
	}
	
	/// if check paid detail then (sheduled: start time and end time and and rdo and travel time and chash&time split deactivate
	///
	/// - Parameter type: String
	private func checkOvertymeType(type: String) {
		if type == "Paid Detail" {
			overtimeModel.scheduledStartTime = nil
			overtimeModel.scheduledEndTime = nil
			overtimeModel.rdo = true
			overtimeModel.travelMinutes = 0
			overtimeModel.typeTravelTime = nil
			overtimeModel.splitCashMinutes = 0
			tableView.reloadData()
		}
	}
	
	//MARK: - Cell Emun
	enum Cell: Int {
		case overtimeHeader
		case segment
		case tour
		case rdo
		case travelTime
		case cashAndTimeSplit
		case notes
		case saveButton
        case tourRDO
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
			
			overtimeHeader.startScheduledDate = overtimeModel.scheduledStartTime
			overtimeHeader.endScheduledDate = overtimeModel.scheduledEndTime
			overtimeHeader.startActualDate = overtimeModel.actualStartTime
			overtimeHeader.endActualDate = overtimeModel.actualEndTime
			
			checkRDO = { [weak self] (isOn) in
				if isOn {
					self?.overtimeModel.scheduledStartTime = nil
					self?.overtimeModel.scheduledEndTime = nil
					self?.overtimeModel.totalOvertimeWorked = self?.overtimeModel.totalActualTime ?? 0
				}
				overtimeHeader.switchToRDO(isOn: isOn)
			}
			
			overtimeHeader.onDateUpdateForTextF = { [weak self] (date, tf) in
				switch tf {
				case .startScheduledDate:
					self?.overtimeModel.scheduledStartTime = date
					
					if (self?.overtimeModel.myTour)! {
						
						let start = Double(self?.startTourSecond ?? 0)
						let end = Double(self?.endTourSecond ?? 0)
						
						let dayTimeInterval = 86400.0
						
						if let startActual = overtimeHeader.startActualDate {
							overtimeHeader.startActualDate = date.changeDate(toDate: startActual)
						}
						
						if start > end {
							if let endScheduled = overtimeHeader.endScheduledDate {
								overtimeHeader.endScheduledDate = date.changeDate(toDate: endScheduled).addingTimeInterval(dayTimeInterval)
							}
							if let endActual = overtimeHeader.endActualDate {
								overtimeHeader.endActualDate = date.changeDate(toDate: endActual).addingTimeInterval(dayTimeInterval)
							}
						} else {
							if let endScheduled = overtimeHeader.endScheduledDate {
								overtimeHeader.endScheduledDate = date.changeDate(toDate: endScheduled)
							}
							if let endActual = overtimeHeader.endActualDate {
								overtimeHeader.endActualDate = date.changeDate(toDate: endActual)
							}
						}
						
						self?.overtimeModel.scheduledStartTime = overtimeHeader.startScheduledDate
						self?.overtimeModel.scheduledEndTime = overtimeHeader.endScheduledDate
						self?.overtimeModel.actualStartTime = overtimeHeader.startActualDate
						self?.overtimeModel.actualEndTime = overtimeHeader.endActualDate
					}
					
				case .endScheduledDate:
					self?.overtimeModel.scheduledEndTime = date
				case .startActualDate:
					self?.overtimeModel.actualStartTime = date
				case .endActualDate:
					self?.overtimeModel.actualEndTime = date
				}
			}
			
			overtimeHeader.onTotalActualTime = { [weak self] (time) in
				self?.overtimeModel.totalActualTime = time
				if self?.overtimeModel.rdo ?? false {
					overtimeHeader.totalOverTimeWorkedLabel.text = time.getTimeFromMinutes()
					self?.overtimeModel.totalOvertimeWorked = time
				}
			}
			
			overtimeHeader.onTotalOvertime = {[weak self] (totalWorkedMinutes) in
				self?.overtimeModel.totalOvertimeWorked = totalWorkedMinutes
			}
			
			isEnableSheduledTime = { [weak self] (isEnabled) in
				overtimeHeader.startTimeTextField.isEnabled = isEnabled
				overtimeHeader.endTimeTextField.isEnabled = isEnabled
			}
			
			overtimeHeader.onDidPressDoneButton = { [weak self] () in
				self?.view.endEditing(true)
			}
			
			isEnableMyTour = { [weak self] (isOn) in
				if isOn {
					let start = Double(self?.startTourSecond ?? 0)
					let end = Double(self?.endTourSecond ?? 0)
					var endTimeInterval = 0.0
					if start > end {
						endTimeInterval = (86400.0 - start) + end
					} else {
						endTimeInterval = end - start
					}
					overtimeHeader.startScheduledDate = Date().trimTime().addingTimeInterval(start)
					overtimeHeader.endScheduledDate = overtimeHeader.startScheduledDate!.addingTimeInterval(endTimeInterval)
					overtimeHeader.startActualDate = Date().trimTime().addingTimeInterval(start)
					overtimeHeader.endActualDate = nil
					overtimeHeader.totalOverTimeWorkedLabel.text = ""
					overtimeHeader.totalActualLabel.text = ""
					overtimeHeader.totalOverTimeWorkedLabel.text = ""
					
					self?.overtimeModel.scheduledStartTime = overtimeHeader.startScheduledDate
					self?.overtimeModel.scheduledEndTime = overtimeHeader.endScheduledDate
					self?.overtimeModel.actualStartTime = overtimeHeader.startActualDate
					self?.overtimeModel.actualEndTime = nil
					self?.overtimeModel.totalActualTime = 0
					self?.overtimeModel.totalOvertimeWorked = 0
				}
			}
			
			return overtimeHeader
		case .segment:
			guard let segmentCell = tableView.dequeueReusableCell(withIdentifier: segmentCellIdentifier, for: indexPath) as? SegmentTableViewCell else { fatalError() }
			var items = ["Cash", "Time", "Paid Detail"]
			if !SettingsManager.shared.paidDetail {
				if overtimeModel.type != "Paid Detail" {
					items.removeLast()
				}
			}
			segmentCell.segmentControl.setItems(items: items)
			segmentCell.setCornersStyle(style: .fullRounded)
			segmentCell.bottomConstraint.constant = 10
			segmentCell.segmentControl.selectedSegmentIndex = items.lastIndex(of: overtimeModel.type) ?? 0
			segmentCell.click = { [weak self] (type) in
				self?.checkOvertymeType(type: type)
				self?.overtimeModel.type = type
				if type == "Paid Detail" {
					self?.isEnableSheduledTime?(false)
					self?.isEnableRDO?(false)
					self?.isChangeRDO?(true)
					self?.isEnableTravelTime?(false)
					self?.isEnableSplit?(false)
					self?.isEnableTour?(false)
				} else {
					self?.isEnableSheduledTime?(true)
					self?.isEnableRDO?(true)
					self?.isEnableTravelTime?(true)
					self?.isEnableSplit?(true)
					self?.isEnableTour?(true)
				}
			}
			if overtimeModel.type == "Paid Detail" {
				self.isEnableSheduledTime?(false)
				self.isEnableRDO?(false)
				self.isChangeRDO?(true)
				self.isEnableTravelTime?(false)
				self.isEnableSplit?(false)
				self.isEnableTour?(false)
			}
			
			return segmentCell
			
		case .tour:
			guard let tourVC = tableView.dequeueReusableCell(withIdentifier: switchCellsIdentifier, for: indexPath) as? CalculatorSwitchTableViewCell else { fatalError() }
			tourVC.setText(title: "My Tour", helpText: nil)
			tourVC.switсh.isOn = overtimeModel.myTour
			
			tourVC.changeValue = { [weak self] (isOn) in
				if isOn {
					//if selected my tour need off rdo
					self?.isChangeRDO!(!isOn)
					self?.overtimeModel.rdo = false
					self?.checkRDO?(false)
					//
					if self?.startTourSecond == 0 || self?.endTourSecond == 0 {
						Alert.show(title: nil, subtitle: "Enter your tour time")
						DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
							tourVC.switсh.isOn = false
							self?.overtimeModel.myTour = false
						})
						return
					}
				}
				self?.overtimeModel.myTour = isOn
				self?.isEnableMyTour?(isOn)
			}
			
			isEnableTour = { [weak self] (isEnabled) in
				tourVC.switсh.isEnabled = isEnabled
				if !isEnabled {
					DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
						tourVC.switсh.isOn = false
					})
					self?.overtimeModel.myTour = false
				}
			}
			
			isChangeMyTour = { [weak self] (isOn) in
				if !isOn {
					self?.overtimeModel.myTour = false
					DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
						tourVC.switсh.isOn = false
					})
				}
				
			}
			
			return tourVC
		case .rdo:
			guard let rdoVC = tableView.dequeueReusableCell(withIdentifier: switchCellsIdentifier, for: indexPath) as? CalculatorSwitchTableViewCell else { fatalError() }
			
			rdoVC.switсh.isOn = overtimeModel.rdo
			self.checkRDO?(overtimeModel.rdo)
			rdoVC.setText(title: "RDO", helpText: nil)
			rdoVC.separator.isHidden = false
			rdoVC.changeValue = { [weak self] (isOn) in
				if isOn {
					self?.isChangeMyTour!(!isOn)
					self?.overtimeModel.totalOvertimeWorked = self?.overtimeModel.totalActualTime ?? 0
				}
				self?.checkRDO?(isOn)
				self?.overtimeModel.rdo = isOn
			}
			
			isEnableRDO = { [weak self] (isEnabled) in
				rdoVC.switсh.isEnabled = isEnabled
			}
			
			isChangeRDO = { [weak self] (isOn) in
				self?.overtimeModel.rdo = isOn
				DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
					rdoVC.switсh.isOn = isOn
				})
			}
			
			return rdoVC
            
        case .tourRDO:
            
            guard let tourRDOVC = tableView.dequeueReusableCell(withIdentifier: doubleSwitchCellsIdentifier, for: indexPath) as? CalculatorDoubleSwitchTableViewCell else { fatalError() }
            if UIScreen.main.bounds.width <= 320 {
                tourRDOVC.setLeftText(title: "Tour", helpText: nil)
            } else {
                tourRDOVC.setLeftText(title: "My Tour", helpText: nil)
            }
            tourRDOVC.leftSwitсh.isOn = overtimeModel.myTour
            tourRDOVC.leftSeparator.isHidden = false
            tourRDOVC.changeLeftValue = { [weak self] (isOn) in
                if isOn {
                    //if selected my tour need off rdo
                    self?.isChangeRDO!(!isOn)
                    self?.overtimeModel.rdo = false
                    self?.checkRDO?(false)
                    //
                    if self?.startTourSecond == 0 || self?.endTourSecond == 0 {
                        Alert.show(title: nil, subtitle: "Enter your tour time")
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                            tourRDOVC.leftSwitсh.isOn = false
                            self?.overtimeModel.myTour = false
                        })
                        return
                    }
                }
                self?.overtimeModel.myTour = isOn
                self?.isEnableMyTour?(isOn)
            }
            
            isEnableTour = { [weak self] (isEnabled) in
                tourRDOVC.leftSwitсh.isEnabled = isEnabled
                if !isEnabled {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                        tourRDOVC.leftSwitсh.isOn = false
                    })
                    self?.overtimeModel.myTour = false
                }
            }
            
            isChangeMyTour = { [weak self] (isOn) in
                if !isOn {
                    self?.overtimeModel.myTour = false
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                        tourRDOVC.leftSwitсh.isOn = false
                    })
                }
                
            }
            
            tourRDOVC.rightSwitсh.isOn = overtimeModel.rdo
            self.checkRDO?(overtimeModel.rdo)
            tourRDOVC.setRightText(title: "RDO", helpText: nil)
            tourRDOVC.rightSeparator.isHidden = false
            tourRDOVC.changeRightValue = { [weak self] (isOn) in
                if isOn {
                    self?.isChangeMyTour!(!isOn)
                    self?.overtimeModel.totalOvertimeWorked = self?.overtimeModel.totalActualTime ?? 0
                }
                self?.checkRDO?(isOn)
                self?.overtimeModel.rdo = isOn
            }
            
            isEnableRDO = { [weak self] (isEnabled) in
                tourRDOVC.rightSwitсh.isEnabled = isEnabled
            }
            
            isChangeRDO = { [weak self] (isOn) in
                self?.overtimeModel.rdo = isOn
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                    tourRDOVC.rightSwitсh.isOn = isOn
                })
            }
            
            return tourRDOVC
			
		case .travelTime:
			guard let travelVC = tableView.dequeueReusableCell(withIdentifier: switchCellsIdentifier, for: indexPath) as? CalculatorSwitchTableViewCell else { fatalError() }
			let title = "Travel Time"
			if overtimeModel.typeTravelTime != nil {
				travelVC.setText(title: title, helpText: "\(overtimeModel.typeTravelTime ?? ""): \(overtimeModel.travelMinutes.getTimeFromMinutes())")
				travelVC.switсh.isOn = true
			} else {
				travelVC.setText(title: title, helpText: nil)
			}
			
			travelVC.separator.isHidden = false
			travelVC.changeValue = { [weak self] (isOn) in
				print("checkbox isOn = \(isOn)")
				if isOn {
					let travelPopup = self?.storyboard?.instantiateViewController(withIdentifier: TravelTimePopupViewController.className) as! TravelTimePopupViewController
					travelPopup.callBack = { [weak self] (type, time, isDone) in
						if !isDone {
							travelVC.switсh.isOn = false
							self?.overtimeModel.typeTravelTime = nil
							self?.overtimeModel.travelMinutes = 0
							return
						}
						if time == 0 {
							travelVC.setText(title: title, helpText: nil)
							travelVC.switсh.isOn = false
							self?.overtimeModel.typeTravelTime = nil
							self?.overtimeModel.travelMinutes = 0
						} else {
							travelVC.setText(title: title, helpText: "\(type): \(time.getTimeFromMinutes())")
							self?.overtimeModel.typeTravelTime = type
							self?.overtimeModel.travelMinutes = time
						}
					}
					self?.present(travelPopup, animated: true, completion: nil)
				} else {
					travelVC.setText(title: title, helpText: nil)
					self?.overtimeModel.typeTravelTime = nil
					self?.overtimeModel.travelMinutes = 0
				}
			}
			isEnableTravelTime = { [weak self] (isEnabled) in
				travelVC.switсh.isEnabled = isEnabled
			}
			return travelVC
			
		case .cashAndTimeSplit:
			guard let cashAndTimeSplitVC = tableView.dequeueReusableCell(withIdentifier: switchCellsIdentifier, for: indexPath) as? CalculatorSwitchTableViewCell else { fatalError() }
			let title = "Cash & Time Split"
			if overtimeModel.splitCashMinutes != 0 && overtimeModel.splitTimeMinutes != 0 {
				cashAndTimeSplitVC.setText(title: title, helpText: "Time: \(overtimeModel.splitTimeMinutes.getTimeFromMinutes())        Cash: \(overtimeModel.splitCashMinutes.getTimeFromMinutes())")
				cashAndTimeSplitVC.switсh.isOn = true
			} else {
				cashAndTimeSplitVC.setText(title: title, helpText: nil)
				cashAndTimeSplitVC.switсh.isOn = false
			}
			
			cashAndTimeSplitVC.changeValue = { [weak self] (isOn) in
				print("checkbox isOn = \(isOn)")
				if isOn {
					if (self?.overtimeModel.rdo)! {
						self?.overtimeModel.totalOvertimeWorked = self?.overtimeModel.totalActualTime ?? 0
					}
					if self?.overtimeModel.totalOvertimeWorked == 0 {
						DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
							cashAndTimeSplitVC.switсh.isOn = false
						})
						Alert.show(title: "Error", subtitle: "Please fill out all fields!")
						return
					}
					let vc = self?.storyboard?.instantiateViewController(withIdentifier: CashAndTimePopupViewController.className) as! CashAndTimePopupViewController
					vc.overtimeTotalWorket = self?.overtimeModel.totalOvertimeWorked ?? 0
					vc.callBack = { [weak self] (cash, time, isDone) in
						if !isDone {
							cashAndTimeSplitVC.switсh.isOn = false
							cashAndTimeSplitVC.setText(title: title, helpText: nil)
							return
						}
						cashAndTimeSplitVC.setText(title: title, helpText: "Time: \(time.getTimeFromMinutes())        Cash: \(cash.getTimeFromMinutes())")
						self?.overtimeModel.splitCashMinutes = cash
						self?.overtimeModel.splitTimeMinutes = time
					}
					self?.present(vc, animated: true, completion: nil)
				} else {
					self?.overtimeModel.splitCashMinutes = 0
					self?.overtimeModel.splitTimeMinutes = 0
					cashAndTimeSplitVC.setText(title: title, helpText: nil)
				}
			}
			isEnableSplit = { [weak self] (isEnabled) in
				cashAndTimeSplitVC.switсh.isEnabled = isEnabled
			}
			return cashAndTimeSplitVC
			
		case .notes:
			guard let notesCell = tableView.dequeueReusableCell(withIdentifier: notesCellIdentifier, for: indexPath) as? NotesTableViewCell else { fatalError() }
			notesCell.startEdit = {
				let index = IndexPath(row: Cell.notes.rawValue, section: 0)
				self.tableView.scrollToRow(at: index, at: .middle, animated: true)
			}
			notesCell.updateValue = {[weak self] (text) in
				self?.overtimeModel.notes = text;
			}
			notesCell.notesTextView.text = overtimeModel.notes
			return notesCell
			
		case .saveButton:
			guard let saveCell = tableView.dequeueReusableCell(withIdentifier: saveButtonIdentifier, for: indexPath) as? OneButtonTableViewCell else { fatalError() }
			saveCell.setButton(title: "Save Results", backgroundColor: .customBlue1)
            if UIScreen.main.bounds.height <= 736 {
                saveCell.buttonHeight.constant = 34.0
            }
			saveCell.click = { [weak self] in
                
                //Rule for pre-configured tour on different days
                if self!.overtimeModel.myTour &&
                self!.overtimeModel.scheduledStartTime?.getTime() == "23:15" && self!.overtimeModel.scheduledEndTime?.getTime() == "07:50" {
                    self?.overtimeModel.createDate = self?.overtimeModel.actualEndTime
                } else {
                    self?.overtimeModel.createDate = self?.overtimeModel.actualStartTime
                }
                
				guard let overtime = self?.overtimeModel else {return}
				if !self!.isValidInfo() {
					return
				}
				if self?.overtimeModel.type == "Paid Detail" {
					self?.overtimeModel.overtimeRate = SettingsManager.shared.paidDetailRate
				} else {
					self?.overtimeModel.overtimeRate = SettingsManager.shared.overtimeRate
				}
				
				print("save button clicked")
				DataBaseManager.shared.createOvertime(object: overtime)
                if #available(iOS 14, *) {
                    self?.reloadWidget()
                } else {
                    // Fallback on earlier versions
                }
                NotificationCenter.default.post(name: Notification.Name.dataForWidgetDidChange, object: nil)
				if let pageVC = self?.parent as? OvertimePageViewController {
					if let vc = pageVC.pages[1] as? OvertimeHistoryViewController {
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
							pageVC.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
						})
					}
				}
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
