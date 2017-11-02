//
//  SettingsViewController.swift
//  Summonses
//
//  Created by Vlad on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
    let data = ["Styles", "Contact us"]
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "SETTINGS"
        tableView.reloadRows(at:[IndexPath(row: 0, section: 0)], with:.none)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            return indexPath.section == 0 && indexPath.row == 0
        }
        
        return false
    }
}

extension SettingsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingPrototypeCell") as! SettingTableViewCell
        
        cell.titleLabel.text = data[indexPath.row]
        
        let isSetting = indexPath.section == 0 && indexPath.row == 0
        if isSetting {
            cell.detailLabel.text = StyleManager.getAppStyle().description()
        }
        cell.detailLabel.isHidden = !isSetting
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.contentView.backgroundColor = StyleManager.getAppStyle().backgroundColorForSectionHeader()
    }
}
