//
//  StyleViewController.swift
//  Summonses
//
//  Created by Artsiom Shmaenkov on 10/26/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class StyleViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension StyleViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppStyle.count()
    }
    

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StylePrototypeCell", for: indexPath) as! StyleTableViewCell
        
        if let appStyle = AppStyle(rawValue:indexPath.row) {
            cell.titleLabel.text = appStyle.description()
            cell.accessoryType = StyleManager.getAppStyle() == appStyle ? .checkmark : .none
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let newStyle = AppStyle(rawValue: indexPath.row) {
            StyleManager.setAppStyle(appStyle: newStyle)
            updateStyle()
            NotificationCenter.default.post(name:Notification.Name(rawValue: "AppStyleUpdate"), object: nil)
            tableView.reloadData()
        }
    }
}
