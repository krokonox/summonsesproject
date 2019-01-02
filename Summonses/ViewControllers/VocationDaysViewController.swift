//
//  VocationDaysViewController.swift
//  Summonses
//
//  Created by Smikun Denis on 02.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class VocationDaysViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    private func setupView() {
        self.parent?.navigationItem.title = "Vocation Days"
        self.view.backgroundColor = UIColor.bgMainCell
    }

}
