//
//  BaseSettingsViewController.swift
//  Summonses
//
//  Created by Pavel Budankov on 26.10.17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class BaseSettingsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings_icon"), style: .plain, target: self, action: #selector(pushSettingsViewController))
        navigationItem.rightBarButtonItem =  menuButton
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
