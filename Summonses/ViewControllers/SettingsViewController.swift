//
//  SettingsViewController.swift
//  Summonses
//
//  Created by Vlad on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit
import MessageUI
import SwiftyUserDefaults

class SettingsViewController: BaseViewController {
	
	@IBOutlet weak var contactSupport:		UIView!
	@IBOutlet weak var writeReview:			UIView!
	@IBOutlet weak var termsConditions:		UIView!
	@IBOutlet weak var plusSettings:		UIView!
	
	@IBOutlet weak var scrollView:			UIScrollView!
	
	@IBOutlet weak var paidDetailSwitch:	UISwitch!
	@IBOutlet weak var fiveMinutsSwitch:	UISwitch!
	@IBOutlet weak var exportCalendar:		UISwitch!
    @IBOutlet weak var startOfWeekSwitch: UISwitch! 
	@IBOutlet weak var overtimeRate: 		UITextField!
	@IBOutlet weak var paidDetailRate: 		UITextField!
	
	@IBOutlet weak var startTourTextField: 	UITextField!
	@IBOutlet weak var endTourTextField: 	UITextField!
	var startTourSecond: Int = 0
	var endTourSecond: Int = 0
	
	@IBOutlet weak var rdoStackView: 		UIStackView!
	@IBOutlet weak var overtimeStackView: 	UIStackView!
    
    @IBOutlet weak var rdoIcon: UIImageView!
    @IBOutlet weak var overtimeIcon: UIImageView!
    
	
	let datePicker = UIDatePicker()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTimePicker()
		setupViewActions()
		

		startTourSecond = UserDefaults.standard.integer(forKey: K.UserDefaults.startTourSecond)
		endTourSecond = UserDefaults.standard.integer(forKey: K.UserDefaults.endTourSecond)
		if startTourSecond == 0 {
			startTourTextField.placeholder = startTourSecond.getTimeFromSeconds()
		} else {
			startTourTextField.text = startTourSecond.getTimeFromSeconds()
		}
		startTourTextField.delegate = self
		
		if endTourSecond == 0 {
			endTourTextField.placeholder = endTourSecond.getTimeFromSeconds()
		} else {
			endTourTextField.text = endTourSecond.getTimeFromSeconds()
		}
		endTourTextField.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupView()
	}
	
	private func setupView() {
		navigationItem.title = "Settings"
		navigationItem.rightBarButtonItem = nil
		self.view.backgroundColor = UIColor.bgMainCell
        
		//if Defaults[.proOvertimeCalculator] || Defaults[.proRDOCalendar] {
			//plusSettings.isHidden = false
			if !Defaults[.proOvertimeCalculator] {
                //overtimeStackView.isHidden = false
                overtimeStackView.isUserInteractionEnabled = true
                overtimeIcon.isUserInteractionEnabled = true
                let overtimeIconTapGesture = UITapGestureRecognizer(target: self, action: #selector(onOvertimeIconTap(_:)))
                let overtimeTapGesture = UITapGestureRecognizer(target: self, action: #selector(onOvertimeTap(_:)))
                overtimeIcon.addGestureRecognizer(overtimeIconTapGesture)
                overtimeStackView.addGestureRecognizer(overtimeTapGesture)
                
                overtimeIcon.isHidden = false
                for view in overtimeStackView.subviews {
                    for subview in view.subviews {
                        if let labelView = subview as? UILabel {
                            labelView.isEnabled = false
                        }
                        if let switchView = subview as? UISwitch {
                            switchView.isEnabled = false
                        }
                        if let textFieldView = subview as? UITextField {
                            textFieldView.isEnabled = false
                        }
                    }
                }
			} else {
				//overtimeStackView.isHidden = true
                overtimeIcon.isHidden = true
                for view in overtimeStackView.subviews {
                    for subview in view.subviews {
                        if let labelView = subview as? UILabel {
                            labelView.isEnabled = true
                        }
                        if let switchView = subview as? UISwitch {
                            switchView.isEnabled = true
                        }
                        if let textFieldView = subview as? UITextField {
                            textFieldView.isEnabled = true
                        }
                    }
                }
			}
			
			if !Defaults[.proRDOCalendar] {
				//rdoStackView.isHidden = false
                rdoStackView.isUserInteractionEnabled = true
                rdoIcon.isUserInteractionEnabled = true
                let rdoIconTapGesture = UITapGestureRecognizer(target: self, action: #selector(onRDOIconTap(_:)))
                let rdoTapGesture = UITapGestureRecognizer(target: self, action: #selector(onRDOTap(_:)))
                rdoIcon.addGestureRecognizer(rdoIconTapGesture)
                rdoStackView.addGestureRecognizer(rdoTapGesture)
                
                rdoIcon.isHidden = false
                for view in rdoStackView.subviews {
                    for subview in view.subviews {
                        if let labelView = subview as? UILabel {
                            labelView.isEnabled = false
                        }
                        if let switchView = subview as? UISwitch {
                            switchView.isEnabled = false
                        }
                        if let textFieldView = subview as? UITextField {
                            textFieldView.isEnabled = false
                        }
                    }
                }
			} else {
				//rdoStackView.isHidden = true
                rdoIcon.isHidden = true
                for view in rdoStackView.subviews {
                    for subview in view.subviews {
                        if let labelView = subview as? UILabel {
                            labelView.isEnabled = true
                        }
                        if let switchView = subview as? UISwitch {
                            switchView.isEnabled = true
                        }
                        if let textFieldView = subview as? UITextField {
                            textFieldView.isEnabled = true
                        }
                    }
                }
			}
//		} else {
//			//plusSettings.isHidden = true
//
//		}
		
		paidDetailSwitch.isOn = SettingsManager.shared.paidDetail
		fiveMinutsSwitch.isOn = SettingsManager.shared.fiveMinuteIncrements
		exportCalendar.isOn = CalendarSyncManager.shared.isExportCalendar
        startOfWeekSwitch.isOn = SettingsManager.shared.isMondayFirstDay
		fiveMinutsSwitch.onTintColor = .customBlue1
		paidDetailSwitch.onTintColor = .customBlue1
		exportCalendar.onTintColor = .customBlue1
		startOfWeekSwitch.onTintColor = .customBlue1
        
		if SettingsManager.shared.overtimeRate == 0.0 {
			overtimeRate.text = ""
		} else {
			overtimeRate.text = "\(SettingsManager.shared.overtimeRate)"
		}
		if SettingsManager.shared.paidDetailRate == 0.0 {
			paidDetailRate.text = ""
		} else {
			paidDetailRate.text = "\(SettingsManager.shared.paidDetailRate)"
		}
		
		overtimeRate.addTarget(self, action: #selector(changeOvertimeRate(_:)), for: .editingChanged)
		paidDetailRate.addTarget(self, action: #selector(changeOvertimePaidDetail(_:)), for: .editingChanged)
		
		startTourTextField.addTarget(self, action: #selector(changeStartTour), for: .editingChanged)
		
		scrollView.keyboardDismissMode = .onDrag
		
		startTourTextField.inputView = datePicker
		endTourTextField.inputView = datePicker
		
	}
      
    @objc private func onRDOIconTap(_ gesture: UIGestureRecognizer) {
      if (gesture.state == .ended) {
          print("rdo")
          showRDOVC()
      }
    }
    
    @objc private func onRDOTap(_ gesture: UIGestureRecognizer) {
      if (gesture.state == .ended) {
          print("rdo")
          showRDOVC()
      }
    }
    
    @objc private func onOvertimeIconTap(_ gesture: UIGestureRecognizer) {
      if (gesture.state == .ended) {
         print("overtime")
         showOvertimeVC()
      }
    }
    
    @objc private func onOvertimeTap(_ gesture: UIGestureRecognizer) {
      if (gesture.state == .ended) {
         print("overtime")
         showOvertimeVC()
      }
    }
    
    
    func showRDOVC() {
        IAPHandler.shared.showIAPVC(.rdoCalendar) { (vc) in
            if vc != nil {
                self.present(vc!, animated: true, completion: nil)
            }
        }
    }
    
    func showOvertimeVC(){
        IAPHandler.shared.showIAPVC(.otCalculator) { (vc) in
            guard let vc = vc else { return }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
	@objc private func changeOvertimeRate(_ textField: UITextField) {
		SettingsManager.shared.overtimeRate = Double(textField.text ?? "") ?? 0.0
	}
	
	@objc private func changeOvertimePaidDetail(_ textField: UITextField) {
		SettingsManager.shared.paidDetailRate = Double(textField.text ?? "") ?? 0.0
	}
	
	@objc private func changeStartTour() {
		
	}
	
	private func setupViewActions() {
		let gestureContactSupport = UITapGestureRecognizer(target: self, action: #selector(contactSupportAction(sender:)))
		contactSupport.addGestureRecognizer(gestureContactSupport)
		
		let gestureWriteReview = UITapGestureRecognizer(target: self, action: #selector(writeRewiewAction(sender:)))
		writeReview.addGestureRecognizer(gestureWriteReview)
		
		let gestureTermsConditions = UITapGestureRecognizer(target: self, action: #selector(termsConditionsAction(sender:)))
		termsConditions.addGestureRecognizer(gestureTermsConditions)
		
		paidDetailSwitch.addTarget(self, action: #selector(paidDetailChanged(_:)), for: .valueChanged)
		fiveMinutsSwitch.addTarget(self, action: #selector(fiveMinutsChanged(_:)), for: .valueChanged)
		exportCalendar.addTarget(self, action: #selector(exportCalendarChanged(_:)), for: .valueChanged)
        startOfWeekSwitch.addTarget(self, action: #selector(startOfWeekChanged(_:)), for: .valueChanged)
	}
	
	override func updateKeyboardHeight(_ height: CGFloat) {
		super.updateKeyboardHeight(height)
		scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, height, 0.0)
		scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, height, 0.0)
	}
	
	
	@objc private func paidDetailChanged(_ item: UISwitch) {
		SettingsManager.shared.paidDetail = item.isOn
	}
	
	@objc private func fiveMinutsChanged(_ item: UISwitch) {
		SettingsManager.shared.fiveMinuteIncrements = item.isOn
	}
	
	@objc private func exportCalendarChanged(_ item: UISwitch) {
		CalendarSyncManager.shared.isExportCalendar = item.isOn
		CalendarSyncManager.shared.syncCalendar()
	}
	
    @objc private func startOfWeekChanged(_ item: UISwitch) {
        SettingsManager.shared.isMondayFirstDay = item.isOn
    }
    
	@objc private func contactSupportAction(sender: UIView!) {
		
		if !MFMailComposeViewController.canSendMail() {
			Alert.show(title: nil, subtitle: "Mail services are not available!")
			return
		}
		
		let emailTitle = "Support Question from app Summonses"
		let toRecipents = ["summonspartner@gmail.com"]
		
		let mailVC = MFMailComposeViewController()
		mailVC.mailComposeDelegate = self
		mailVC.setSubject(emailTitle)
		mailVC.setToRecipients(toRecipents)
		
		self.present(mailVC, animated: true, completion: nil)
		
	}
	
	@objc private func writeRewiewAction(sender: UIView!) {
		rateApp(appID: "id1329409724")
	}
	
	@objc private func termsConditionsAction(sender: UIView!) {
		Alert.show(title: "Terms and conditions", subtitle: K.supportMessage.conditions)
	}
	
	private func rateApp(appID: String) {
		
		//    let url = URL(string: "itms-apps://itunes.apple.com/app/" + appID + "?action=write-review")
		let url = URL(string: "itms-apps://itunes.apple.com/app/"+appID+"?action=write-review")
		
		if #available(iOS 10.0, *) {
			UIApplication.shared.open(url!, options: [:], completionHandler: nil)
		} else {
			UIApplication.shared.openURL(url!)
		}
		
	}
	
	@objc func onTimeDidChange(_ picker: UIDatePicker){
		let components = Calendar.current.dateComponents([.hour, .minute], from: picker.date)
		if startTourTextField.isFirstResponder {
			print("\(components.hour ?? 00):\(components.minute ?? 00)")
			startTourTextField.text = picker.date.getTime()
			startTourSecond = (components.hour! * 60 * 60) + (components.minute! * 60)
			print("startTourSecond", startTourSecond)
			UserDefaults.standard.set(startTourSecond, forKey: K.UserDefaults.startTourSecond)
		}
		
		if endTourTextField.isFirstResponder {
			print("\(components.hour!):\(components.minute!)")
			endTourTextField.text = picker.date.getTime()
			endTourSecond = (components.hour! * 60 * 60) + (components.minute! * 60)
			UserDefaults.standard.set(endTourSecond, forKey: K.UserDefaults.endTourSecond)
		}
	}
	
	@objc private func doneClicked() {
		view.endEditing(true)
	}
	
	func setupTimePicker() {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		formatter.timeZone = Calendar.current.timeZone
		formatter.locale = Locale(identifier: "en_US_POSIX")
		
		datePicker.minimumDate = formatter.date(from: "01-01-1901")
		datePicker.timeZone = formatter.timeZone
		datePicker.locale = Locale(identifier: "en_GB")
		
		datePicker.datePickerMode = .time
		datePicker.addTarget(self, action: #selector(onTimeDidChange(_:)), for: .valueChanged)
		
		let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: datePicker.frame.size.width, height: 44))
		toolbar.isTranslucent = false
		toolbar.barTintColor = .darkBlue
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
		doneButton.tintColor = .white
		doneButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0, weight: .regular)], for: .normal)
        doneButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0, weight: .regular)], for: .highlighted)
		let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		toolbar.setItems([space, space, doneButton], animated: true)
		startTourTextField.inputAccessoryView = toolbar
		endTourTextField.inputAccessoryView = toolbar
	}
}

extension SettingsViewController : MFMailComposeViewControllerDelegate {
	
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		
		self.dismiss(animated: true, completion: nil)
	}
	
}

extension SettingsViewController: UITextFieldDelegate {
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		
		if textField == self.startTourTextField {
			datePicker.date = Date().trimTime().addingTimeInterval(Double(startTourSecond))
		}
		
		if textField == self.endTourTextField {
			datePicker.date = Date().trimTime().addingTimeInterval(Double(endTourSecond))
		}
	}
	
}


