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
        tableView.register(UINib(nibName: "OffenseTableViewCell", bundle: nil), forCellReuseIdentifier: "offenseidentifierCell")
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "SETTINGS"

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "offenseidentifierCell") as! OffenseTableViewCell
        cell.title.text = data[indexPath.section][indexPath.row]
        //cell.number.text = offenses[indexPath.row].number
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
    
    
}
