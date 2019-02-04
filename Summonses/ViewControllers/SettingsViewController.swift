//
//  SettingsViewController.swift
//  Summonses
//
//  Created by Vlad on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: BaseViewController {
  
  @IBOutlet weak var contactSupport: UIView!
  @IBOutlet weak var writeReview: UIView!
  @IBOutlet weak var termsConditions: UIView!
	
	@IBOutlet weak var paidDetailSwitch: UISwitch!
	@IBOutlet weak var fiveMinutsSwitch: UISwitch!
	@IBOutlet weak var overtimeRate: UITextField!
	@IBOutlet weak var paidDetailRate: UITextField!
	
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewActions()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    paidDetailSwitch.isOn = SettingsManager.shared.paidDetail
		fiveMinutsSwitch.isOn = SettingsManager.shared.fiveMinuteIncrements
    setupView()
  }
  
  private func setupView() {
    navigationItem.title = "Settings"
    navigationItem.rightBarButtonItem = nil
    self.view.backgroundColor = UIColor.bgMainCell
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
  }
	
	@objc private func paidDetailChanged(_ item: UISwitch) {
		SettingsManager.shared.paidDetail = item.isOn
	}
	
	@objc private func fiveMinutsChanged(_ item: UISwitch) {
		SettingsManager.shared.fiveMinuteIncrements = item.isOn
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


