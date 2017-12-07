//
//  SettingsViewController.swift
//  Summonses
//
//  Created by Vlad on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit
import ActiveLabel

class SettingsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contactView: UIView!
    
    @IBOutlet weak var contactLabel: ActiveLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActiveLabel()
        tableView.tableFooterView = contactView
    }
    
    func setupActiveLabel() {
        let email = ActiveType.custom(pattern: "\\s" + K.appConfig.supportEmail + "\\b")
        contactLabel.enabledTypes.append(email)
        contactLabel.customize { label in
            label.text = "Please feel free to contact us with any question or suggestions that you might have \n" + K.appConfig.supportEmail
            contactLabel.customColor[email] = .customBlue
            label.handleCustomTap(for: email) {_ in
                let urlString = "mailto:" + K.appConfig.supportEmail
                if let url = URL(string: urlString) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "SETTINGS"
        tableView.reloadRows(at:[IndexPath(row: 0, section: 0)], with:.none)
    }
    @IBAction func onTermsPress(_ sender: Any) {
        
        let alert = UIAlertController(title: "Terms and conditions", message: K.supportMessage.conditions, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))

        alert.view.tintColor = .customBlue
        self.present(alert, animated: true, completion: nil)
    }
}

extension SettingsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingColorPrototypeCell") as! SettingColorTableViewCell
        cell.onSwitchChange = { (accept) in
            StyleManager.setAppStyle(appStyle: AppStyle(rawValue: accept ? 1 : 0)!)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.contentView.backgroundColor = StyleManager.getAppStyle().backgroundColorForSectionHeader()
    }
}
