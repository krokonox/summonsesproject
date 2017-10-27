//
//  SettingsViewController.swift
//  Summonses
//
//  Created by Vlad on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
    let data = [["Style settings"], ["Contact us"]]
    let headerTitles = ["General", "Contacts"]
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return data[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingPrototypeCell") as! SettingTableViewCell
        
        cell.titleLabel.text = data[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        let isSetting = indexPath.section == 0 && indexPath.row == 0
        if isSetting {
            cell.detailLabel.text = StyleManager.getAppStyle().description()
        }
        cell.detailLabel.isHidden = !isSetting
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.contentView.backgroundColor = StyleManager.getAppStyle().backgroundColorForSectionHeader()
    }
}
