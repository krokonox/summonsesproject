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
  @IBOutlet weak var writeReview: 			UIView!
  @IBOutlet weak var termsConditions: 	UIView!
	@IBOutlet weak var plusSettings: 			UIView!
	
	@IBOutlet weak var scrollView: 				UIScrollView!
	
	@IBOutlet weak var paidDetailSwitch: 	UISwitch!
	@IBOutlet weak var fiveMinutsSwitch: 	UISwitch!
	@IBOutlet weak var exportCalendar: 		UISwitch!
	@IBOutlet weak var overtimeRate: 			UITextField!
	@IBOutlet weak var paidDetailRate: 		UITextField!
	
	@IBOutlet weak var rdoStackView: 			UIStackView!
	@IBOutlet weak var overtimeStackView: 			UIStackView!
	
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewActions()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupView()
  }
  
  private func setupView() {
    navigationItem.title = "Settings"
    navigationItem.rightBarButtonItem = nil
    self.view.backgroundColor = UIColor.bgMainCell
		
		if Defaults[.proOvertimeCalculator] || Defaults[.proRDOCalendar] {
			plusSettings.isHidden = false
			if Defaults[.proOvertimeCalculator] {
				overtimeStackView.isHidden = false
			} else {
				overtimeStackView.isHidden = true
			}
			
			if Defaults[.proRDOCalendar] {
				rdoStackView.isHidden = false
			} else {
				rdoStackView.isHidden = true
			}
		} else {
			plusSettings.isHidden = true
		}
		
		paidDetailSwitch.isOn = SettingsManager.shared.paidDetail
		fiveMinutsSwitch.isOn = SettingsManager.shared.fiveMinuteIncrements
		exportCalendar.isOn = CalendarSyncManager.shared.isExportCalendar
		fiveMinutsSwitch.onTintColor = .customBlue1
		paidDetailSwitch.onTintColor = .customBlue1
		exportCalendar.onTintColor = .customBlue1
		
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
		
		scrollView.keyboardDismissMode = .onDrag
		
  }
	
	@objc private func changeOvertimeRate(_ textField: UITextField) {
		SettingsManager.shared.overtimeRate = Double(textField.text ?? "") ?? 0.0
	}
	
	@objc private func changeOvertimePaidDetail(_ textField: UITextField) {
		SettingsManager.shared.paidDetailRate = Double(textField.text ?? "") ?? 0.0
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
}

extension SettingsViewController : MFMailComposeViewControllerDelegate {
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    
    self.dismiss(animated: true, completion: nil)
  }
  
}


