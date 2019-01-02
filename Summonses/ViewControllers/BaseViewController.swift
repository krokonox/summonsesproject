//
//  BaseViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/24/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class BaseViewController: MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let menuButton = UIBarButtonItem(image:#imageLiteral(resourceName: "menu_icon"), style: .plain, target: self, action: #selector(pushSettingsViewController))
        navigationItem.rightBarButtonItem =  menuButton
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back_button")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
